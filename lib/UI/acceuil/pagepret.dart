import 'package:flutter/material.dart';

class Loan {
  final String title;
  final String borrower;
  final double amount;

  Loan({required this.title, required this.borrower, required this.amount});
}

class MyLoansPage extends StatelessWidget {
  final List<Loan> loans = [
    Loan(title: "Livre", borrower: "Jean", amount: 20.0),
    Loan(title: "Outil de jardinage", borrower: "Marie", amount: 30.0),
    Loan(title: "Vélo", borrower: "Luc", amount: 50.0),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Mes prêts'),
      ),
      body: ListView.builder(
        itemCount: loans.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(loans[index].title),
            subtitle: Text('Emprunté par: ${loans[index].borrower}'),
            trailing: Text('${loans[index].amount.toString()} €'),
          );
        },
      ),
    );
  }
}
