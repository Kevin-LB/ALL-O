import 'package:allo/UI/setBrouillons.dart';
import 'package:allo/db/alloDB.dart';
import 'package:allo/models/annonce.dart';
import 'package:allo/models/categorie.dart';
import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';

class BrouillonsPage extends StatefulWidget {
  const BrouillonsPage({Key? key}) : super(key: key);

  @override
  State<BrouillonsPage> createState() => _BrouillonsPageState();
}

class _BrouillonsPageState extends State<BrouillonsPage> {
  Future<Database?> db = AllDB().db;
  Future<List<Annonce>>? annoncesFuture;

  @override
  void initState() {
    super.initState();
    annoncesFuture = db.then((value) => AllDB().annonces());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Brouillons'),
      ),
      body: FutureBuilder<List<Annonce>>(
        future: annoncesFuture,
        builder: (BuildContext context, AsyncSnapshot<List<Annonce>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator();
          } else if (snapshot.hasError) {
            print(snapshot.error);
            return Text('Erreur : ${snapshot.error}');
          } else if (snapshot.hasData && snapshot.data != null) {
            return GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
              ),
              itemCount: snapshot.data!.length,
              itemBuilder: (BuildContext context, int index) {
                Annonce? annonce = snapshot.data![index];
                if (annonce != null) {
                  return GestureDetector(
                    onTap: () async {
                      await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              UpdateAnnoncePage(annonce: annonce ),
                        ),
                      );
                      setState(() {
                        annoncesFuture = db.then((value) => AllDB().annonces());
                      });
                    },
                    child: _buildContainer(annonce),
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
    );
  }

  Widget _buildContainer(Annonce annonce) {
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
        ],
      ),
    );
  }
}
