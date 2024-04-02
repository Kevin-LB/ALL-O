// ignore: file_names
import 'package:allo/UI/button.dart';
import 'package:allo/UI/loginPage.dart';
import 'package:flutter/material.dart';

class PageMenu extends StatefulWidget {
  const PageMenu({super.key});

  @override
  State<PageMenu> createState() => _PageMenuState();
}

class _PageMenuState extends State<PageMenu> {
  @override
  Widget build(BuildContext context) {
    void navigateToLogin(BuildContext context) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const LoginPage()),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Menu'),
      ),
      body: Column(
        children: <Widget>[
          const Text('Menu'),
          ButtonSelect(
            text: "Se connecter",
            onPressed: () {
              navigateToLogin(context);
            },
          )
        ],
      ),
    );
  }
}
