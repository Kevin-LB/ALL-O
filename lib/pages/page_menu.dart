import 'package:allo/UI/pages/gerer_biens.dart';
import 'package:allo/data/models/annonce.dart';
import 'package:allo/pages/home.dart';
import 'package:allo/UI/pages/gestion_annonce.dart';
import 'package:allo/service/notif_services.dart';
import 'package:flutter/material.dart';
import 'package:allo/UI/components/button.dart';
import 'package:allo/pages/settingsPage.dart';
import 'package:allo/pages/loginPage.dart';

// pageMenu.dart
class PageMenu extends StatefulWidget {
  final Map<int, List<Annonce>> annoncesArendre;

  const PageMenu({
    super.key,
    required this.annoncesArendre,
  });

  @override
  State<PageMenu> createState() => _PageMenuState();
}

class _PageMenuState extends State<PageMenu> {
  @override
  Widget build(BuildContext context) {
    void navigateToSettings(BuildContext context) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const SettingsPage()),
      );
    }

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
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            const SizedBox(height: 10),
            ButtonSelect(
              text: "Gerer mes annonces",
              tailleWidth: 280,
              tailleHeight: 70,
              fontSize: 40,
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const GestionAnnonce()));
              },
            ),
            const SizedBox(height: 10),
            ButtonSelect(
              text: "Gerer les biens",
              tailleWidth: 280,
              tailleHeight: 70,
              fontSize: 40,
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => GererBiens(
                              annonceArendre: widget.annoncesArendre,
                            )));
              },
            ),
            const SizedBox(height: 10),
            ButtonSelect(
              text: "Paramètres",
              tailleWidth: 280,
              tailleHeight: 70,
              fontSize: 40,
              onPressed: () {
                navigateToSettings(context);
              },
            ),
          ],
        ),
      ),
    );
  }
}
