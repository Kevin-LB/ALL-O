import 'package:allo/UI/button.dart';
import 'package:allo/UI/home.dart';
import 'package:allo/db/alloDB.dart';
import 'package:allo/models/categorie.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class PageAdd extends StatefulWidget {
  @override
  State<PageAdd> createState() => _PageAddState();
}

class _PageAddState extends State<PageAdd> {
  final Map<String, bool> _checkboxValues = {
  };

  final allDb = AllDB();

  @override
  void initState() {
    super.initState();
    initializeDatabase().then((_) {
      insertCategories();
    });
  }

  Future<void> initializeDatabase() async {
    await allDb.initDb();
    final categories = await getCategories();
    for (var category in categories) {
      _checkboxValues[category.libelle] = false;
    }
  }

  Future<List<Categorie>> getCategories() async {
    try {
      final db = await allDb.db;
      if (db == null) {
        print('Database is null');
        return [];
      }
      final List<Map<String, dynamic>> maps = await db.query('Categorie');
      if (maps.isEmpty) {
        print('No categories found');
        return [];
      }
      return List.generate(maps.length, (i) {
        return Categorie(
          id: maps[i]['id'],
          libelle: maps[i]['libelle'],
        );
      });
    } catch (e) {
      print(e);
      return [];
    }
  }

  void insertCategories() async {
    var categories = [
      const Categorie(id: 1, libelle: 'Outillage'),
      const Categorie(id: 2, libelle: 'Vêtements'),
      const Categorie(id: 3, libelle: 'Meubles'),
      const Categorie(id: 4, libelle: 'Electroménager'),
      const Categorie(id: 5, libelle: 'Jouets'),
      const Categorie(id: 6, libelle: 'Livres'),
    ];

    for (final category in categories) {
      await allDb.insertCategorie(category);
    }
  }

  void onCheckboxChanged(String key, bool? newValue) {
    setState(() {
      _checkboxValues[key] = newValue!;
    });
  }

  void navigateToHome(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const Home()),
    );
  }

  @override
  Widget build(BuildContext context) {
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
                      fontSize: 30.0,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              const Padding(
                  padding: EdgeInsets.only(top: 30, bottom: 70.0),
                  child: Text("Créer une Annonce",
                      style:
                          TextStyle(fontSize: 30.0, color: Color(0xffFFFFFF)))),
              Padding(
                  padding: const EdgeInsets.only(bottom: 20.0),
                  child: Center(
                    child: Container(
                      width: 300,
                      color: const Color(0xFF8C8585),
                      child: TextFormField(
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: "Titre de l'annonce",
                          labelStyle: TextStyle(
                              fontSize: 20.0,
                              fontWeight: FontWeight.bold,
                              color: Color.fromRGBO(255, 255, 255, 0.5)),
                        ),
                      ),
                    ),
                  )),
              Padding(
                  padding: const EdgeInsets.only(bottom: 20),
                  child: Center(
                    child: Container(
                      width: 300,
                      height: 150,
                      color: const Color(0xFF8C8585),
                      child: TextFormField(
                        maxLines: null,
                        decoration: const InputDecoration(
                          labelText: 'Description',
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ),
                  )),
              Padding(
                  padding: const EdgeInsets.only(bottom: 20),
                  child: Center(
                    child: Container(
                      width: 300,
                      color: const Color(0xFF8C8585),
                      child: TextFormField(
                        decoration: InputDecoration(
                          labelText: 'Catégorie',
                          suffixIcon: IconButton(
                            icon: const Icon(Icons.more_vert),
                            onPressed: () {
                              dialogBuilder(context, onCheckboxChanged);
                            },
                          ),
                        ),
                      ),
                    ),
                  )),
              Padding(
                  padding: const EdgeInsets.only(top: 10),
                  child: ButtonSelect(
                    text: "Valider",
                    onPressed: () => navigateToHome(context),
                    buttonColor: const Color(0xFFD9D9D9),
                    textColor: const Color(0xff201D1D),
                  )),
            ],
          ),
        ));
  }

  Future<void> dialogBuilder(
      BuildContext context, Function(String, bool) onCheckboxChanged) {
    return showDialog<void>(
        context: context,
        builder: (BuildContext context) {
          return StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
              return AlertDialog(
                backgroundColor: const Color(0xFF3C3838),
                title: Text('Catégories',
                    style: GoogleFonts.getFont('Jomhuria',
                        fontSize: 40, color: const Color(0xffFFFFFF))),
                content: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: _checkboxValues.keys.map((String key) {
                      return Container(
                        padding: const EdgeInsets.only(bottom: 10.0),
                        color: const Color(0xFF8C8585),
                        child: Row(
                          children: [
                            Text(key,
                                style: const TextStyle(
                                    fontSize: 20.0, color: Color(0xffFFFFFF))),
                            Checkbox(
                              value: _checkboxValues[key],
                              onChanged: (bool? newValue) {
                                setState(() {
                                  _checkboxValues[key] = newValue!;
                                });
                                onCheckboxChanged(key, newValue!);
                              },
                              activeColor: Colors.green,
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                  ),
                ),
                actions: <Widget>[
                  TextButton(
                    style: TextButton.styleFrom(
                      textStyle: Theme.of(context).textTheme.labelLarge,
                    ),
                    child: const Text('OK'),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              );
            },
          );
        });
  }
}
