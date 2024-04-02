import 'package:flutter/material.dart';
import 'package:allo/UI/Controller/button.dart';
import 'package:allo/UI/acceuil/settingsPage.dart';
import 'package:allo/UI/loginPage.dart';

class PageMenu extends StatefulWidget {
  const PageMenu({super.key});

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
                print("Vous avez cliqué sur Gerer mes annonces");
              },
            ),
            const SizedBox(height: 10),
            ButtonSelect(
              text: "Gerer mes biens",
              tailleWidth: 280,
              tailleHeight: 70,
              fontSize: 40,
              onPressed: () {
                print("Vous avez cliqué sur Gerer mes biens");
              },
            ),
            const SizedBox(height: 10),
            ButtonSelect(
              text: "Reservations",
              tailleWidth: 280,
              tailleHeight: 70,
              fontSize: 40,
              onPressed: () {
                print("Vous avez cliqué sur Reservations");
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
