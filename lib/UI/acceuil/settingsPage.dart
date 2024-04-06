import 'package:flutter/material.dart';
import 'package:allo/UI/loginPage.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  void navigateToLogin(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const LoginPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF3C3838),
        title: const Text(
          'Paramètres',
          style: TextStyle(
            color: Color(0xFFFFFFFF),
          ),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                IconButton(
                  icon: const Icon(Icons.login),
                  onPressed: () {
                    navigateToLogin(context);
                  },
                ),
                TextButton(
                  child: const Text(
                    'Se connecter',
                    style: TextStyle(
                      color: Color(0xFFFFFFFF),
                    ),
                  ),
                  onPressed: () {
                    navigateToLogin(context);
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}