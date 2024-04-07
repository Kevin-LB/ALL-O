import 'package:allo/db/alloDB.dart';
import 'package:allo/db/supabase.dart';
import 'package:allo/models/categorie.dart';
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
  final _categoryController = TextEditingController();
  Future<void>? _updateFuture;

  @override
  void initState() {
    super.initState();

    _titleController.text = widget.annonce.libelle;
    _descriptionController.text = widget.annonce.description;
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
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              widget.annonce.libelle = _titleController.text;
                              widget.annonce.description =
                                  _descriptionController.text;
                              _updateFuture = AllDB()
                                  .updateAnnonce(widget.annonce)
                                  .then((_) {
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
                              if (response != null && response.isNotEmpty) {
                                SupabaseDB.insertAnnonce(
                                  titre: _titleController.text,
                                  description: _descriptionController.text,
                                  idUser: widget.annonce.idU,
                                  idBiens: widget.annonce.idB,
                                );
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
}
