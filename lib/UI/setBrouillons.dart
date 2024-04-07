import 'package:allo/db/alloDB.dart';
import 'package:allo/db/supabase.dart';
import 'package:allo/models/appartenirAnnonce.dart';
import 'package:flutter/material.dart';
import 'package:allo/models/annonce.dart';

class UpdateAnnoncePage extends StatefulWidget {
  final Annonce annonce;

  UpdateAnnoncePage({required this.annonce});

  @override
  _UpdateAnnoncePageState createState() => _UpdateAnnoncePageState();
}

class _UpdateAnnoncePageState extends State<UpdateAnnoncePage> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  Future<void>? _updateFuture;
  List<Appartenir_Annonce> listeAppartenirAnnonce = [];

  @override
  void initState() {
    super.initState();

    _titleController.text = widget.annonce.libelle;
    _descriptionController.text = widget.annonce.description;
    loadAppartenirAnnonces();
  }

  Future<void> loadAppartenirAnnonces() async {
    List<Appartenir_Annonce> appartenirAnnonces =
        await AllDB().appartenirAnnonceByID(widget.annonce.id);
    setState(() {
      listeAppartenirAnnonce = appartenirAnnonces;
    });
  }

  Future<void> loadAppartenirAnnonces2() async {
    List<Map<String, dynamic>> appartenirAnnonces =
        await SupabaseDB.selectCategoriesbyId(widget.annonce.id);
    setState(() {
      listeAppartenirAnnonce = appartenirAnnonces
          .map((map) => Appartenir_Annonce.fromMap(map))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Modifier l\'annonce'),
      ),
      body: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: <Widget>[
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(labelText: 'Titre'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Veuillez entrer un titre';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _descriptionController,
                decoration: const InputDecoration(labelText: 'Description'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Veuillez entrer une description';
                  }
                  return null;
                },
              ),
              Text(
                  "Catégories de l'annonce ${listeAppartenirAnnonce.map((e) => e.idC).toList()}"),
              FutureBuilder(
                future: _updateFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const CircularProgressIndicator();
                  } else {
                    return Column(
                      children: [
                        ElevatedButton(
                          child: const Text('Soumettre'),
                          onPressed: () async {
                            if (_formKey.currentState!.validate()) {
                              widget.annonce.libelle = _titleController.text;
                              widget.annonce.description =
                                  _descriptionController.text;
                              _updateFuture = AllDB()
                                  .updateAnnonce(widget.annonce)
                                  .then((_) {
                                ajouterAnnonceAAppartenirAnnonce();
                                Navigator.pop(context);
                              });
                            }
                          },
                        ),
                        ElevatedButton(
                          child: const Text('Envoyer à Supabase'),
                          onPressed: () async {
                            print('Envoi à Supabase');
                            if (_formKey.currentState!.validate()) {
                              await SupabaseDB.selectBien_v2();
                              var response = await SupabaseDB.selectBiens(
                                  widget.annonce.idB);
                              if (response.isNotEmpty) {
                                await SupabaseDB.insertAnnonce(
                                  titre: _titleController.text,
                                  description: _descriptionController.text,
                                  idUser: widget.annonce.idU,
                                  idBiens: widget.annonce.idB,
                                ).then((idA) => {
                                      for (Appartenir_Annonce appartenirAnnonce
                                          in listeAppartenirAnnonce)
                                        {
                                          SupabaseDB.insertAppartenirAnnonce(
                                            idAnnonce: idA,
                                            idCategorie: appartenirAnnonce.idC,
                                          )
                                        }
                                    });

                                AllDB().deleteAnnonce(widget.annonce.id);
                                Navigator.pop(context);
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content:
                                        Text("Votre annonce a été publiée"),
                                    backgroundColor: Colors.green,
                                  ),
                                );
                              } else {
                                print(
                                    'Erreur : idBiens n\'existe pas dans la table Biens');
                              }
                            }
                          },
                        ),
                      ],
                    );
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> ajouterAnnonceAAppartenirAnnonce() async {
    List<Annonce> annonces = await AllDB().annonces();

    Annonce annonceAValider = annonces.first;

    // Insérer l'annonce dans Supabase
    await SupabaseDB.insertAnnonce(
      titre: annonceAValider.libelle,
      description: annonceAValider.description,
      idUser: annonceAValider.idU,
      idBiens: annonceAValider.idB,
    );

    List<Annonce> annoncesSupabase = await SupabaseDB.selectAnnonces();
    Annonce annonceInseree = annoncesSupabase.first;
  }
}
