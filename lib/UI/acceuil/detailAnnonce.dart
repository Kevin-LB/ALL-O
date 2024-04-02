import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:allo/UI/Controller/button.dart';
import 'package:allo/models/annonce.dart';

class DetailPage extends StatelessWidget {
  final Annonce annonce;

  DetailPage({required this.annonce});

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
                  annonce.libelle,
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
              annonce.description,
              style: const TextStyle(
                fontSize: 15,
                color: Colors.white,
              ),
            ),
            const SizedBox(
              height: 40,
            ),
            Text(
              annonce.datePost.toString(),
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
              mainAxisAlignment:
                  MainAxisAlignment.center, // Center elements horizontally
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
                    onPressed: () => print("Repondre à l'annonce")),
              ],
            )
          ],
        ),
      ),
    );
  }
}
