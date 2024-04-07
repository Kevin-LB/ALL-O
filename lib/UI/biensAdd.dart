// ignore_for_file: non_constant_identifier_names, no_leading_underscores_for_local_identifiers

import 'package:allo/UI/Controller/button.dart';
import 'package:allo/UI/acceuil/home.dart';
import 'package:allo/db/alloDB.dart';
import 'package:allo/models/appartenirBiens.dart';
import 'package:allo/models/categorie.dart';
import 'package:allo/models/objet.dart';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class BiensAddPage extends StatefulWidget {
  @override
  State<BiensAddPage> createState() => _BiensAddPageState();
}

class _BiensAddPageState extends State<BiensAddPage> {
  final Map<String, bool> _checkboxValues = {};

  String selectedCategories = "";
  final _bienController = TextEditingController();
  final _descriptionController = TextEditingController();

  final allDb = AllDB();

  @override
  void initState() {
    super.initState();
    initializeDatabase();
  }

  @override
  void dispose() {
    _bienController.dispose();
    _descriptionController.dispose();
    super.dispose();
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

  void onCheckboxChanged(String key, bool? newValue) {
    setState(() {
      _checkboxValues[key] = newValue!;
      selectedCategories = _checkboxValues.entries
          .where((element) => element.value)
          .map((e) => e.key)
          .join(', ');
    });
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
                child: Text("Créer une Biens",
                    style:
                        TextStyle(fontSize: 30.0, color: Color(0xffFFFFFF)))),
            Padding(
                padding: const EdgeInsets.only(bottom: 20.0),
                child: Center(
                  child: Container(
                    width: 300,
                    color: const Color(0xFF8C8585),
                    child: TextFormField(
                      controller: _bienController,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: "Nom du bien",
                        labelStyle: TextStyle(
                            fontSize: 20.0,
                            fontWeight: FontWeight.bold,
                            color: Color.fromRGBO(255, 255, 255, 0.5)),
                      ),
                    ),
                  ),
                )),
            Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: Center(
                child: Container(
                  width: 300,
                  height: 150,
                  color: const Color(0xFF8C8585),
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    controller: _descriptionController,
                    maxLines: null,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Veuillez entrer une description';
                      }
                      return null;
                    },
                    decoration: const InputDecoration(
                      labelText: 'Description',
                      border: InputBorder.none,
                    ),
                  ),
                ),
              ),
            ),
            Padding(
                padding: const EdgeInsets.only(bottom: 20),
                child: Center(
                  child: Container(
                    width: 300,
                    color: const Color(0xFF8C8585),
                    child: TextFormField(
                      readOnly: true,
                      onTap: () {
                        dialogBuilder(context, onCheckboxChanged);
                      },
                      decoration: InputDecoration(
                        labelText: 'Catégorie',
                        hintText: selectedCategories.isEmpty
                            ? 'Sélectionnez une catégorie'
                            : selectedCategories,
                        border: const OutlineInputBorder(),
                      ),
                    ),
                  ),
                )),
            Padding(
              padding: const EdgeInsets.only(top: 10),
              child: ButtonSelect(
                text: "Valider",
                onPressed: () async {
                  final List<Biens> bienList = await allDb.biens();
                  if (bienList.isEmpty) {
                    String libelleBien = _bienController.text;
                    String descriptionAnnonce = _descriptionController.text;
                    print("libelleBien: $libelleBien");
                    print("descriptionAnnonce: $descriptionAnnonce");
                    final bienInsert = Biens(
                      id: 1,
                      libelle: libelleBien,
                      description: descriptionAnnonce,
                      img: 'image1.png',
                      pret: false,
                      idU: 1,
                    );
                    if (selectedCategories.isNotEmpty) {
                      String category = selectedCategories.isNotEmpty
                          ? selectedCategories
                          : '';
                      int idCategorie = await allDb.getCategorieId(category);
                      await allDb.insertAppartenirBiens(Appartenir_Biens(
                        idB: bienInsert.id,
                        idC: idCategorie,
                      ));
                    }

                    await allDb.insertBiens(bienInsert);
                    if (mounted) {
                      Navigator.pop(context);
                    }
                  } else {
                    final id_annonce = bienList.last.id + 1;
                    String libelleBien = _bienController.text;
                    String descriptionAnnonce = _descriptionController.text;
                    final bienInsert = Biens(
                      id: id_annonce,
                      libelle: libelleBien,
                      description: descriptionAnnonce,
                      img: 'image1.png',
                      pret: false,
                      idU: 1,
                    );
                    await allDb.insertBiens(bienInsert);
                    if (mounted) {
                      Navigator.pop(context);
                    }
                  }
                },
                buttonColor: const Color(0xFFD9D9D9),
                textColor: const Color(0xff201D1D),
              ),
            ),
          ],
        ),
      ),
    );
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
