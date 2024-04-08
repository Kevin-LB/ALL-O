import 'dart:async';
import 'package:allo/pages/biens_page.dart';
import 'package:allo/data/models/categorie.dart';
import 'package:allo/data/models/objet.dart';
import 'package:allo/provider/user_provider.dart';
import 'package:allo/service/notif_services.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:allo/pages/brouillons.dart';
import 'package:allo/data/db/supabase.dart';
import 'package:allo/UI/components/bottom_nav_bar.dart';
import 'package:allo/UI/components/button.dart';
import 'package:allo/pages/detail_annonce.dart';
import 'package:allo/UI/pages/page_add.dart';
import 'package:allo/pages/page_menu.dart';
import 'package:allo/pages/page_pret.dart';
import 'package:allo/pages/settings_page.dart';
import 'package:allo/data/db/alloDB.dart';
import 'package:allo/data/models/annonce.dart';

// home.dart
class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

Map<int, List<Annonce>> annoncesARendre = {};

class _HomeState extends State<Home> {
  int _selectedIndex = 0;
  Session? _session;
  Future<List<Annonce>>? annoncesFuture;
  Future<Database?> db = AllDB().db;
  final supabase = Supabase.instance.client;

  @override
  void initState() {
    super.initState();
    _getSession();
    loadAnnonces();
    insertCategories().then((_) => insertCategorieSupabase());
  }

  Future<void> _getSession() async {
    try {
      await Future.delayed(Duration.zero);
      if (supabase.auth.currentSession != null) {
        print('User est authentifié');
      } else {
        print("User n'est pas authentifié");
      }
      if (!mounted) {
        return;
      }
      setState(() {});
    } catch (e) {
      print('Failed to get session: $e');
    }
  }

  Future<void> insertCategories() async {
    var categories = [
      const Categorie(id: 1, libelle: 'Outillage'),
      const Categorie(id: 2, libelle: 'Vêtements'),
      const Categorie(id: 3, libelle: 'Meubles'),
      const Categorie(id: 4, libelle: 'Electroménager'),
      const Categorie(id: 5, libelle: 'Jouets'),
      const Categorie(id: 6, libelle: 'Livres'),
    ];

    for (final category in categories) {
      try {
        await AllDB().insertCategorie(category);
      } catch (e) {
        print('Erreur lors de l\'insertion de la catégorie $category: $e');
      }
    }
  }

  insertCategorieSupabase() async {
    List<Categorie> categories = await AllDB().categories();
    for (final category in categories) {
      var exists = await supabase
          .from('categories')
          .select()
          .eq('idC', category.id)
          .maybeSingle();
      if (exists == null) {
        SupabaseDB.insertCategories(category.libelle, category.id);
      }
    }
  }

  void loadAnnonces() async {
    annoncesFuture = SupabaseDB.selectAnnonces();
    setState(() {});
  }

  _selectIndexSwitch(int index) {
    switch (index) {
      case 1:
        return PageAdd();
      case 2:
        return PageMenu(annoncesArendre: annoncesARendre);
      default:
        return HomeScreen();
    }
  }

  void _onItemSelected(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _selectIndexSwitch(_selectedIndex),
      bottomNavigationBar: CustomBottomNavBar(
        selectedIndex: _selectedIndex,
        onItemSelected: _onItemSelected,
      ),
    );
  }
}

class HomeScreen extends StatefulWidget {
  HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Future<List<Annonce>>? annonces;
  List<Biens> biens = [];

  _HomeScreenState();

  @override
  void initState() {
    super.initState();
    loadAnnonces();
  }

  Future<DateTime?> getDatePret(int idBiens) async {
    var datePretString = await SupabaseDB.getDatePret(idBiens);

    if (datePretString != null) {
      print('Date FIN Pret: $datePretString');
      return datePretString;
    } else {
      print("La date n'a pas pu être analysée: $datePretString");
      return null;
    }
  }

  void loadAnnonces() async {
    List<Annonce> annoncesList = await SupabaseDB.selectAnnonces();
    annonces = Future.value(annoncesList);
    for (Annonce annonce in annoncesList) {
      DateTime? datePret = await getDatePret(annonce.idB);
      if (datePret != null) {
        print('Date de prêt pour l\'annonce ${annonce.id}: $datePret');
      } else {
        print('Pas de date de prêt pour l\'annonce ${annonce.id}');
      }
    }
    setState(() {});
  }

  void navigateToPage2(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => MyLoansPage()),
    );
  }

  void navigateToBrouillon(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const BrouillonsPage()),
    );
  }

  void navigateToBiens(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => BiensPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    Future<String> getStatusAnnonce(Annonce annonce) async {
      var etatAnnonce = await SupabaseDB.getidbfromAnnonce(annonce.id);
      DateTime? dateFinPret = await getDatePret(annonce.idB);
      if (dateFinPret != null && dateFinPret.isBefore(DateTime.now())) {
        if (!annoncesARendre.values
            .expand((v) => v)
            .any((annonceExistante) => annonceExistante.id == annonce.id)) {
          if (!annoncesARendre.containsKey(userProvider.user["idU"])) {
            annoncesARendre[userProvider.user["idU"]] = [annonce];
          } else {
            annoncesARendre[userProvider.user["idU"]]?.add(annonce);
          }
        }
        print("annoncesARendre: $annoncesARendre");
        if (annonce.idU == userProvider.user["idU"]) {
          await NotificationService().showNotification(
              id: annonce.id,
              title: 'Fin de prêt',
              body:
                  "Fin de prêt pour l'annonce ${annonce.libelle}, rendez vous sur gerer les biens pour faire un rendu");
        }

        return "Faire un rendu";
      }
      if (etatAnnonce == null) {
        return 'Ouverte';
      }

      return etatAnnonce == 0 ? 'Ouverte' : 'Pourvue';
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF3C3838),
        title: FittedBox(
          fit: BoxFit.scaleDown,
          child: RichText(
            text: const TextSpan(
              text: "A",
              style: TextStyle(
                color: Color(0xff57A85A),
                fontSize: 45.0,
              ),
              children: <TextSpan>[
                TextSpan(
                  text: "'llo",
                  style: TextStyle(
                    color: Color(0xffFFFFFF),
                  ),
                ),
              ],
            ),
          ),
        ),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              loadAnnonces();
            },
          ),
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const SettingsPage()),
              );
            },
          ),
        ],
      ),
      body: Container(
        color: const Color(0xFF3C3838),
        padding: const EdgeInsets.only(top: 40.0, left: 10.0, bottom: 60.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Bienvenue sur Allo",
                style: TextStyle(
                    color: Color(0xffFFFFFF),
                    fontSize: 30.0,
                    fontWeight: FontWeight.bold)),
            const SizedBox(height: 20.0),
            Text(
                userProvider.user != null
                    ? "Bonjour ${userProvider.user["prenom"]}"
                    : "Bonjour",
                style: const TextStyle(
                    color: Color(0xffFFFFFF),
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold)),
            const SizedBox(height: 20.0),
            Row(
              children: [
                ButtonSelect(
                  text: "Mes Prêts",
                  onPressed: () => navigateToPage2(context),
                ),
                const SizedBox(width: 10),
                ButtonSelect(
                  text: "Brouillons",
                  onPressed: () => navigateToBrouillon(context),
                ),
                const SizedBox(width: 10),
                ButtonSelect(
                  text: "BIENSB",
                  onPressed: () => navigateToBiens(context),
                ),
              ],
            ),
            const Padding(
              padding: EdgeInsets.only(top: 20.0),
              child: Text(
                'Annonces',
                style: TextStyle(
                  color: Color.fromRGBO(255, 255, 255, 0.5),
                  fontSize: 25.0,
                ),
              ),
            ),
            Expanded(
              child: FutureBuilder<List<Annonce>>(
                future: annonces,
                builder: (BuildContext context,
                    AsyncSnapshot<List<Annonce>> snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const CircularProgressIndicator();
                  } else if (snapshot.hasError) {
                    print(snapshot.error);
                    return Text('Erreur : ${snapshot.error}');
                  } else if (snapshot.hasData && snapshot.data != null) {
                    return GridView.builder(
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                      ),
                      itemCount: snapshot.data!.length,
                      itemBuilder: (BuildContext context, int index) {
                        Annonce? annonce = snapshot.data![index];
                        if (annonce != null) {
                          Future<String> status = getStatusAnnonce(annonce);
                          return GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      DetailPage(annonce: annonce),
                                ),
                              );
                            },
                            child: _buildContainer(annonce, status),
                          );
                        } else {
                          return Container();
                        }
                      },
                    );
                  } else {
                    return const Text("Aucune annonce disponible");
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContainer(Annonce annonce, Future<String> status) {
    Color colorAnnonce(String status) {
      switch (status) {
        case 'Cloturée':
          return const Color.fromARGB(255, 137, 0, 0);
        case 'Pourvue':
          return const Color(0xFFE78138);
        case "Faire un rendu":
          return const Color.fromARGB(255, 75, 79, 73);
        default:
          return const Color(0xFF92D668);
      }
    }

    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFD9D9D9),
        borderRadius: BorderRadius.circular(5.0),
      ),
      margin: const EdgeInsets.symmetric(
        vertical: 10.0,
        horizontal: 5.0,
      ),
      padding: const EdgeInsets.all(10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Image.asset(
                "assets/img/clou.png",
                width: 70,
                height: 60,
                fit: BoxFit.cover,
              ),
              const SizedBox(width: 10.0),
              Flexible(
                child: Text(
                  annonce.libelle,
                  style: const TextStyle(
                    color: Color(0xFF000000),
                    fontSize: 15.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          FutureBuilder<String>(
            future: status,
            builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const CircularProgressIndicator();
              } else if (snapshot.hasError) {
                return Text('Erreur : ${snapshot.error}');
              } else {
                return Container(
                  height: 35.0,
                  width: 80,
                  decoration: BoxDecoration(
                    color: colorAnnonce(snapshot.data!),
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    snapshot.data!,
                    style: const TextStyle(
                      color: Color(0xFFFFFFFF),
                      fontSize: 10.0,
                    ),
                  ),
                );
              }
            },
          ),
        ],
      ),
    );
  }
}
