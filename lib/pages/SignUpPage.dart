import 'package:flutter/material.dart';
import 'package:allo/data/db/supabase.dart';
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
                TextSpan(
                  text: "Se connecter",
                  style: TextStyle(
                    color: Color(0xffFFFFFF),
                    fontSize: 10.0,
                  ),
                ),
              ],
            ),
          ),
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
        print('test verifyUser');
        final userExists = await SupabaseDB.verifyUser(
          _emailController.text,
          _usernameController.text,
        );

        if (userExists) {
          print("L'utilisateur existe déjà");
          sm.showSnackBar(
            const SnackBar(
              content: Text(
                "L'utilisateur existe déjà",
                style: TextStyle(color: Colors.red),
              ),
            ),
          );
        } else {
          print("L'utilisateur n'existe pas");
          await SupabaseDB.insertUser(
            nom: _surnameController.text,
            prenom: _nameController.text,
            username: _usernameController.text.trim(),
            email: _emailController.text.trim(),
            password: _passwordController.text.trim(),
          );

          sm.showSnackBar(
            const SnackBar(
              content: Text("L'utilisateur est inscrit avec succès"),
            ),
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
      sm.showSnackBar(
        const SnackBar(
          content: Text(
            "Veuillez remplir tous les champs",
            style: TextStyle(color: Colors.red),
          ),
        ),
      );
    }
  }
}
