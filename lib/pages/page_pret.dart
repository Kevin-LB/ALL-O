import 'package:allo/data/db/supabase.dart';
import 'package:allo/provider/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// pagepret.dart
class MyLoansPage extends StatefulWidget {
  @override
  _MyLoansPageState createState() => _MyLoansPageState();
}

class _MyLoansPageState extends State<MyLoansPage> {
  List<dynamic> loans = [];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      fetchLoans();
    });
  }

  Future<void> fetchLoans() async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final response =
        await SupabaseDB.selectBiensPreter(userProvider.user['idU']);
    print('Prêts récupérés: ${response}');

    if (response != null) {
      setState(() {
        loans = response;
      });
    } else {
      print('Erreur lors de la récupération des prêts: ${response}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mes prêts'),
      ),
      body: ListView.builder(
        itemCount: loans.length,
        itemBuilder: (context, index) {
          final loan = loans[index];
          return ListTile(
            title: Text(
              'Prêt ${index + 1}',
              style: const TextStyle(
                color: Colors.grey,
                fontSize: 25,
              ),
            ),
            subtitle: Text(
              '${loan['libelleB']}',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 20,
              ),
            ),
          );
        },
      ),
    );
  }
}
