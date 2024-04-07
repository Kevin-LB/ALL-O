// ignore_for_file: non_constant_identifier_names, no_leading_underscores_for_local_identifiers

import 'package:allo/UI/Controller/button.dart';
import 'package:allo/UI/acceuil/home.dart';
import 'package:allo/db/alloDB.dart';
import 'package:allo/db/supabase.dart';
import 'package:allo/models/appartenirAnnonce.dart';
import 'package:allo/models/categorie.dart';
import 'package:allo/models/annonce.dart';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class PageAdd extends StatefulWidget {
  @override
  State<PageAdd> createState() => _PageAddState();
}

class _PageAddState extends State<PageAdd> {
  final Map<String, bool> _checkboxValues = {};
  String selectedCategories = "";
  final _annonceController = TextEditingController();
  final _descriptionController = TextEditingController();

  final allDb = AllDB();

  @override
  void initState() {
    super.initState();
    initializeDatabase();
  }

  @override
  void dispose() {
    _annonceController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> initializeDatabase() async {
    final categories = await SupabaseDB.selectCategories();
    print("Les catégories récupérées sont : $categories");
    for (var category in categories) {
      if (category['libelleC'] != null) {
        _checkboxValues[category['libelleC']] = false;
      } else {
        print("Le libellé de la catégorie est null");
      }
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

  void navigateToHome(BuildContext context) {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => const Home()),
      (Route<dynamic> route) => false,
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
                        controller: _annonceController,
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
                    final List<Annonce> annonceList = await allDb.annonces();
                    if (annonceList.isEmpty) {
                      String libelleAnnonce = _annonceController.text;
                      String descriptionAnnonce = _descriptionController.text;
                      print("libelleAnnonce: $libelleAnnonce");
                      print("descriptionAnnonce: $descriptionAnnonce");
                      final annonceInsert = Annonce(
                        id: 1,
                        libelle: libelleAnnonce,
                        description: descriptionAnnonce,
                        datePost: DateTime.now(),
                        idB: 1,
                        idU: 1,
                      );
                      print(
                          "les catégories sélectionnées: $selectedCategories");
                      if (selectedCategories.isNotEmpty) {
                        print(
                            "les catégories sélectionnées: $selectedCategories");
                        if (selectedCategories.isNotEmpty) {
                          String categories = selectedCategories.isNotEmpty
                              ? selectedCategories
                              : '';
                          for (final categorie in categories.split(', ')) {
                            int idCategorie =
                                await allDb.getCategorieId(categorie);
                            print("Test insertAppartenirAnnonce");
                            await allDb
                                .insertAppartenirAnnonce(Appartenir_Annonce(
                              idA: annonceInsert.id,
                              idC: idCategorie,
                            ));
                          }
                        }
                      }

                      await allDb.insertAnnonce(annonceInsert);
                      if (mounted) {
                        navigateToHome(context);
                      }
                    } else {
                      final id_annonce = annonceList.last.id + 1;
                      String libelleAnnonce = _annonceController.text;
                      String descriptionAnnonce = _descriptionController.text;
                      final annonceInsert = Annonce(
                        id: id_annonce,
                        libelle: libelleAnnonce,
                        description: descriptionAnnonce,
                        datePost: DateTime.now(),
                        idB: 1,
                        idU: 1,
                      );
                      await allDb.insertAnnonce(annonceInsert);
                      print(
                          "les catégories sélectionnées: $selectedCategories");
                      if (selectedCategories.isNotEmpty) {
                        String categories = selectedCategories.isNotEmpty
                            ? selectedCategories
                            : '';
                        for (final categorie in categories.split(', ')) {
                          int idCategorie =
                              await allDb.getCategorieId(categorie);
                          print("Test insertAppartenirAnnonce");
                          await allDb
                              .insertAppartenirAnnonce(Appartenir_Annonce(
                            idA: annonceInsert.id,
                            idC: idCategorie,
                          ));
                        }
                      }
                      if (mounted) {
                        navigateToHome(context);
                      }
                    }
                  },
                  buttonColor: const Color(0xFFD9D9D9),
                  textColor: const Color(0xff201D1D),
                ),
              ),
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
