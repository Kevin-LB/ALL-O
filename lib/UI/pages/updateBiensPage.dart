import 'package:allo/data/db/alloDB.dart';
import 'package:allo/data/db/supabase.dart';
import 'package:allo/data/models/objet.dart';
import 'package:flutter/material.dart';
// updateBiensPage.dart
class UpdateBiensPage extends StatefulWidget {
  final Biens biens;

  UpdateBiensPage({required this.biens});

  @override
  _UpdateBiensPageState createState() => _UpdateBiensPageState();
}

class _UpdateBiensPageState extends State<UpdateBiensPage> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  Future<void>? _updateFuture;

  @override
  void initState() {
    super.initState();

    _titleController.text = widget.biens.libelle;
    _descriptionController.text = widget.biens.description;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Modifier Biens'),
      ),
      body: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: <Widget>[
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(labelText: 'Nom du Bien'),
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
              ElevatedButton(
                child: const Text('Soumettre'),
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    widget.biens.libelle = _titleController.text;
                    widget.biens.description = _descriptionController.text;

                    _updateFuture = AllDB()
                        .updateBiens(widget.biens)
                        .then((value) => Navigator.pop(context));
                  }
                },
              ),
              ElevatedButton(
                child: const Text('Envoyer à Supabase'),
                onPressed: () async {
                  print('Envoi Biens à Supabase ');
                  if (_formKey.currentState!.validate()) {
                    SupabaseDB.insertBiens(
                      titre: _titleController.text,
                      description: _descriptionController.text,
                      idUser: widget.biens.idU,
                    );

                    AllDB().deleteBiens(widget.biens.id);
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("Votre biens a été publiée"),
                        backgroundColor: Colors.green,
                      ),
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
