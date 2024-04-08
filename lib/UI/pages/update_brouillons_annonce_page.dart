import 'package:allo/data/db/alloDB.dart';
import 'package:allo/data/db/supabase.dart';
import 'package:allo/data/models/appartenirAnnonce.dart';
import 'package:allo/provider/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:allo/data/models/annonce.dart';
import 'package:provider/provider.dart';

// setBrouillons.dart
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

    print('id appartenirAnnonces : $appartenirAnnonces');
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
    final userProvider = Provider.of<UserProvider>(context, listen: false);

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
              FutureBuilder(
                future: _updateFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const CircularProgressIndicator();
                  } else {
                    return Column(
                      children: [
                        ElevatedButton(
                          child: const Text('Modifier l\'annonce'),
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
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text("Votre annonce a été modifiée"),
                                  backgroundColor: Colors.yellowAccent,
                                ),
                              );
                            }
                          },
                        ),
                        ElevatedButton(
                          child:
                              const Text('Supprimer l\'annonce du brouillons'),
                          onPressed: () async {
                            AllDB().deleteAnnonce(widget.annonce.id);
                            Navigator.pop(context);
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text(
                                    "Votre annonce a été supprimée du brouillons"),
                                backgroundColor: Colors.red,
                              ),
                            );
                          },
                        ),
                        ElevatedButton(
                          child: const Text('Publier l\'annonce sur Allo'),
                          onPressed: () async {
                            if (_formKey.currentState!.validate()) {
                              {
                                await SupabaseDB.insertAnnonce(
                                  titre: _titleController.text,
                                  description: _descriptionController.text,
                                  idUser: userProvider.user['idU'],
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

    await SupabaseDB.insertAnnonce(
      titre: annonceAValider.libelle,
      description: annonceAValider.description,
      idUser: annonceAValider.idU, // a modifier
    );

    List<Annonce> annoncesSupabase = await SupabaseDB.selectAnnonces();
    Annonce annonceInseree = annoncesSupabase.first;
  }
}
