// Importez les bibliothèques nécessaires
import 'dart:async';
import 'package:allo/UI/SignUpPage.dart';
import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:allo/UI/acceuil/brouillons.dart';
import 'package:allo/db/supabase.dart';
import 'package:allo/UI/Controller/bottomNavBar.dart';
import 'package:allo/UI/Controller/button.dart';
import 'package:allo/UI/acceuil/detailAnnonce.dart';
import 'package:allo/UI/pageAdd.dart';
import 'package:allo/UI/menuPage/pageMenu.dart';
import 'package:allo/UI/pageSearch.dart';
import 'package:allo/UI/acceuil/pagepret.dart';
import 'package:allo/UI/acceuil/settingsPage.dart';
import 'package:allo/db/alloDB.dart';
import 'package:allo/models/annonce.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

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
    selectUser();
    loadAnnonces();
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

  void loadAnnonces() async {
    annoncesFuture = SupabaseDB.selectAnnonces();
    print('Annonces FININI: ${annoncesFuture}');
    setState(() {});
  }

  Future<void> selectUser() async {
    final response = await supabase.from('utilisateur').select();
    print('response: ${response}');

    if (response == null) {
      print(
          'Erreur lors de la récupération de l\'utilisateur: la réponse est null');
    } else if (response != null) {
      print('Erreur lors de la récupération de l\'utilisateur: ');
    } else {
      print('Utilisateur récupéré avec succès: ${response}');
    }
  }

  _selectIndexSwitch(int index) {
    switch (index) {
      case 1:
        return const SearchPage();
      case 2:
        return PageAdd();
      case 3:
        return const PageMenu();
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
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Future<List<Annonce>>? annonces;

  @override
  void initState() {
    super.initState();
    loadAnnonces();
  }

  void loadAnnonces() async {
    List<Annonce> annoncesList = await SupabaseDB.selectAnnonces();
    print('Annonces FININI: $annoncesList');
    annonces = Future.value(annoncesList);
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

  @override
  Widget build(BuildContext context) {
    String getStatus(int index) {
      return index % 2 == 0 ? 'Ouverte' : 'Pourvue';
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
              // Mettez ici le code pour rafraîchir vos données
              // Par exemple, vous pouvez appeler à nouveau loadAnnonces()
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
            ButtonSelect(
              text: "Mes Prêts",
              onPressed: () => navigateToPage2(context),
            ),
            ButtonSelect(
              text: "Brouillons",
              onPressed: () => navigateToBrouillon(context),
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
                          String? status = getStatus(index);
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

  Widget _buildContainer(Annonce annonce, String status) {
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
          Container(
            height: 35.0,
            width: 80,
            decoration: BoxDecoration(
              color: status == 'Ouverte'
                  ? const Color(0xFF92D668)
                  : const Color(0xFFE78138),
              borderRadius: BorderRadius.circular(8.0),
            ),
            alignment: Alignment.center,
            child: Text(
              status,
              style: const TextStyle(
                color: Color(0xFFFFFFFF),
                fontSize: 10.0,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
