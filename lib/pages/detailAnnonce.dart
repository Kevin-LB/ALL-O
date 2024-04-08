import 'package:allo/UI/components/calendrier.dart';
import 'package:allo/data/db/supabase.dart';
import 'package:allo/data/models/objet.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:allo/UI/components/button.dart';
import 'package:allo/data/models/annonce.dart';
// detailAnnonce.dart
class DetailPage extends StatefulWidget {
  final Annonce annonce;
  DetailPage({required this.annonce});

  @override
  State<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  List<Biens> mesBiens = [];
  List<Biens> aPreter = [];
  DateTime? maDateSelectionnee;

  @override
  void initState() {
    super.initState();
    fetchBiens();
  }

  Future<void> fetchBiens() async {
    var biens = await SupabaseDB.selectBiensByIDAnnonceNonPreter(widget.annonce.idU);
    for (var bienMap in biens) {
      var bien = Biens.fromMap(bienMap);
      mesBiens.add(bien);
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF3C3838),
        centerTitle: true,
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
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  "assets/img/clou.png",
                  width: 150,
                  height: 200,
                  fit: BoxFit.cover,
                ),
                const SizedBox(
                  width: 50,
                ),
                Text(
                  widget.annonce.libelle,
                  style: const TextStyle(
                    fontSize: 40,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 30,
            ),
            Text(
              widget.annonce.description,
              style: const TextStyle(
                fontSize: 15,
                color: Colors.white,
              ),
            ),
            const SizedBox(
              height: 40,
            ),
            Text(
              widget.annonce.datePost.toString(),
              style: const TextStyle(
                fontSize: 15,
                color: Colors.white,
              ),
            ),
            const SizedBox(
              height: 15,
            ),
            const SizedBox(
              height: 15,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ButtonSelect(
                    text: "Commentaires",
                    tailleHeight: 50,
                    tailleWidth: 160,
                    fontSize: 30,
                    onPressed: () => print("Commentaires")),
                const SizedBox(
                  width: 15,
                ),
                ButtonSelect(
                  text: "Répondre à l'annonce",
                  tailleHeight: 50,
                  tailleWidth: 160,
                  fontSize: 20,
                  onPressed: () => dialogBuilder(context, widget.annonce),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  Future<void> dialogBuilder(BuildContext context, Annonce annonce) async {
    return showDialog(
      context: context,
      builder: (context) {
        return FutureBuilder<List<Map<String, dynamic>>>(
          future: SupabaseDB.selectBiensByIDAnnonceNonPreter(annonce.idU),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return const Text('Erreur');
            } else {
              final biens = (snapshot.data as List<Map<String, dynamic>>)
                  .map((bienMap) => Biens.fromMap(bienMap))
                  .toList();
              final mesBiens = List<Biens>.from(biens);
              final aPreter = <Biens>[];
              return StatefulBuilder(
                builder: (BuildContext context, StateSetter setState) {
                  return AlertDialog(
                    title: const Text('Prêter un bien'),
                    content: Column(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                "Mes Biens",
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(height: 10),
                              Expanded(
                                child: ListView.builder(
                                  shrinkWrap: true,
                                  itemCount: mesBiens.length,
                                  itemBuilder: (context, index) {
                                    final bien = mesBiens[index];
                                    return ListTile(
                                      title: Text(bien.libelle),
                                      onTap: () {
                                        setState(() {
                                          mesBiens.remove(bien);
                                          aPreter.add(bien);
                                        });
                                      },
                                    );
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                        const Divider(),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                "A préter",
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 10),
                              Expanded(
                                child: ListView.builder(
                                  shrinkWrap: true,
                                  itemCount: aPreter.length,
                                  itemBuilder: (context, index) {
                                    final bien = aPreter[index];
                                    return ListTile(
                                      title: Text(bien.libelle),
                                    );
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    actions: <Widget>[
                      DateTimePickerButton(
                        onDateSelected: (selectedDate) {
                          print('Date sélectionnée: $selectedDate');
                          setState(() {
                            maDateSelectionnee = selectedDate;
                          });
                        },
                      ),
                      TextButton(
                        onPressed: () {
                          print(
                              'Biens sélectionnés: ${aPreter.map((bien) => bien.libelle).join(', ')}');
                          ajouterDansPreter(
                              biens, annonce, maDateSelectionnee);
                          Navigator.of(context).pop();
                        },
                        child: const Text('OK'),
                      ),
                    ],
                  );
                },
              );
            }
          },
        );
      },
    );
  }

  void ajouterDansPreter(
      List<Biens> biens, Annonce annonce, DateTime? dateSelectionner) {
    for (var bien in biens) {
      print('Ajout de ${bien.libelle} dans la table preter');
      SupabaseDB.insertPreter(annonce, bien.id, dateSelectionner);
    }
  }
}
