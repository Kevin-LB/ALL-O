import 'package:allo/data/db/supabase.dart';
import 'package:allo/provider/user_provider.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:allo/pages/SignUpPage.dart';
import 'package:allo/pages/home.dart';
import 'package:provider/provider.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Obtenez une référence à UserProvider
    final userProvider = Provider.of<UserProvider>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF3C3838),
        title: FittedBox(
          fit: BoxFit.scaleDown,
          child: RichText(
            text: TextSpan(
              text: "A",
              style: const TextStyle(
                color: Color(0xff57A85A),
                fontSize: 45.0,
              ),
              children: <TextSpan>[
                const TextSpan(
                  text: "'llo",
                  style: TextStyle(
                    color: Color(0xffFFFFFF),
                    fontSize: 30.0,
                  ),
                ),
                TextSpan(
                  text: "Créer un compte",
                  style: const TextStyle(
                    color: Color(0xffFFFFFF),
                    fontSize: 10.0,
                  ),
                  recognizer: TapGestureRecognizer()
                    ..onTap = () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const CreationComptePage()),
                      );
                    },
                ),
              ],
            ),
          ),
        ),
      ),
      body: ListView(
        children: [
          TextFormField(
            controller: _emailController,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'Email',
              icon: Icon(Icons.person_2),
            ),
          ),
          TextFormField(
            controller: _passwordController,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'Password',
              icon: Icon(Icons.lock),
            ),
          ),
          ElevatedButton(
            onPressed: () async {
              final response = await SupabaseDB.verifyUser(
                  _emailController.text.trim(),
                  _passwordController.text.trim());

              if (response['success']) {
                print("Vous êtes connecté");
                userProvider.user = response['user'];
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => const Home()),
                  (route) => false,
                );
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text("Mauvais email ou mot de passe"),
                    backgroundColor: Colors.red,
                  ),
                );
              }
            },
            child: const Text('Se connecter'),
          ),
        ],
      ),
    );
  }
}
