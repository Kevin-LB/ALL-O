import 'package:allo/pages/login_page.dart';
import 'package:allo/pages/home.dart';
import 'package:allo/provider/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:allo/data/db/supabase.dart';
import 'package:provider/provider.dart';
import 'package:flutter/gestures.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

// CreationComptePage.dart
class CreationComptePage extends StatefulWidget {
  const CreationComptePage({Key? key}) : super(key: key);

  @override
  State<CreationComptePage> createState() => _CreationComptePageState();
}

class _CreationComptePageState extends State<CreationComptePage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _surnameController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF3C3838),
        title: Row(
          children: [
            RichText(
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
            const Spacer(),
            RichText(
              text: TextSpan(
                text: "Se connecter",
                style: const TextStyle(
                  color: Color(0xffFFFFFF),
                  fontSize: 20.0,
                ),
                recognizer: TapGestureRecognizer()
                  ..onTap = () {
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const LoginPage()),
                      (route) => false,
                    );
                  },
              ),
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: _nameController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Prénom',
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: _surnameController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Nom',
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: _usernameController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Username',
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: _emailController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Email',
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: _passwordController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Mot de Passe',
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ElevatedButton(
                onPressed: _registerUser,
                child: const Text("S'inscrire"),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _registerUser() async {
    final sm = ScaffoldMessenger.of(context);

    if (_emailController.text.isNotEmpty &&
        _passwordController.text.isNotEmpty &&
        _surnameController.text.isNotEmpty &&
        _nameController.text.isNotEmpty &&
        _usernameController.text.isNotEmpty) {
      print('email: ${_emailController.text}');

      try {
        final response = await SupabaseDB.verifyUserInscrit(
          _emailController.text.trim(),
          _usernameController.text.trim(),
        );

        if (response['success'] == false) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("L'utilisateur existe déjà"),
              backgroundColor: Colors.red,
            ),
          );
        } else {
          final newUser = await SupabaseDB.insertUser(
            nom: _surnameController.text,
            prenom: _nameController.text,
            username: _usernameController.text.trim(),
            email: _emailController.text.trim(),
            password: _passwordController.text.trim(),
          );
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("L'utilisateur est inscrit avec succès"),
              backgroundColor: Colors.green,
            ),
          );
          print("NEW USER INSERTE: $newUser");

          SharedPreferences prefs = await SharedPreferences.getInstance();
          await prefs.setInt('userId', newUser['idU']);
          await prefs.setBool('isLoggedIn', true);

          Provider.of<UserProvider>(context, listen: false).user = newUser;
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => const Home()),
            (route) => false,
          );
        }
      } catch (error) {
        print('Error: $error');
        sm.showSnackBar(
          const SnackBar(
            content: Text("Erreur lors de l'inscription"),
          ),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Veuillez remplir tous les champs"),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
}
