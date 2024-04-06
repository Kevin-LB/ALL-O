import 'package:allo/db/supabase.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

final supabase = Supabase.instance.client;

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
  Widget build(Object context) {
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
      body: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _nameController,
              decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Prénom',
                  labelStyle: TextStyle(
                    color: Color.fromRGBO(255, 255, 255, 0.5),
                  ),
                  floatingLabelStyle: TextStyle(
                    color: Color(0xffFFFFFF),
                  )),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _surnameController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Nom',
                labelStyle: TextStyle(
                  color: Color.fromRGBO(255, 255, 255, 0.5),
                ),
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
                labelStyle: TextStyle(
                  color: Color.fromRGBO(255, 255, 255, 0.5),
                ),
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
                labelStyle: TextStyle(
                  color: Color.fromRGBO(255, 255, 255, 0.5),
                ),
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
                labelStyle: TextStyle(
                  color: Color.fromRGBO(255, 255, 255, 0.5),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton(
              onPressed: () async {
                final sm = ScaffoldMessenger.of(context as BuildContext);
                if (_emailController.text.isNotEmpty &&
                    _passwordController.text.isNotEmpty) {
                  try {
                    final userExists = await SupabaseDB.verifyUser(
                      _emailController.text,
                      _passwordController.text,
                    );

                    print('User exists: $userExists');

                    if (userExists) {
                      sm.showSnackBar(
                        const SnackBar(
                          content: Text(
                            "L'utilisateur existe déjà",
                            style: TextStyle(color: Colors.red),
                          ),
                        ),
                      );
                    } else {
                      await SupabaseDB.insertUser(
                        nom: _surnameController.text,
                        prenom: _nameController.text,
                        username: _usernameController.text.trim(),
                        email: _emailController.text.trim(),
                        password: _passwordController.text.trim(),
                      );

                      sm.showSnackBar(
                        const SnackBar(
                          content:
                              Text("L'utilisateur est inscrit avec succès"),
                        ),
                      );
                    }
                  } catch (error, stackTrace) {
                    print('Error: $error');
                    print('Stack trace: $stackTrace');
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
              },
              child: const Text("S'inscrire"),
            ),
          ),
        ],
      ),
    );
  }
}
