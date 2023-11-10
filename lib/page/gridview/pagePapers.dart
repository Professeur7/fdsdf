import 'package:flutter/material.dart';

import '../../screen/home_screen.dart';


class InvoiceAndAccountingPage extends StatefulWidget {
  @override
  _InvoiceAndAccountingPageState createState() => _InvoiceAndAccountingPageState();
}

class _InvoiceAndAccountingPageState extends State<InvoiceAndAccountingPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _amountController = TextEditingController();
  final List<Expense> expenses = [];

  String? clientName;
  String? invoiceAmount;
  DateTime? invoiceDate;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Facturation et Comptabilité"),
        backgroundColor: const Color(0xFF09126C),
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios_new,
            color: Colors.grey,
          ),
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => HomeScreen(), // Remplacez PageDefault par votre widget de page par défaut
              ),
            );
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: <Widget>[
                TextFormField(
                  decoration: InputDecoration(labelText: 'Nom du client'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Ce champ est requis';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    clientName = value;
                  },
                ),
                TextFormField(
                  controller: _amountController,
                  decoration: InputDecoration(labelText: 'Montant de la facture'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Ce champ est requis';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    invoiceAmount = value;
                  },
                ),
                // Utilisez un DatePicker pour la date de la facture
                // Vous pouvez utiliser le package `date_field` ou le widget `showDatePicker` pour cela
                // Ajoutez ici le code pour sélectionner la date
                // Exemple : https://pub.dev/packages/date_field
                ElevatedButton(
                  onPressed: () {
                    // Ouvrez un DatePicker pour sélectionner la date
                    // Mettez à jour la valeur de `invoiceDate` avec la date sélectionnée
                  },
                  child: Text("Sélectionner la date"),
                ),
                ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      _formKey.currentState!.save();
                      final invoice = Invoice(clientName!, double.parse(invoiceAmount!), invoiceDate!);
                      // Ajoutez cette facture à la liste des factures ou gérez-la comme souhaité.
                    }
                  },
                  child: Text("Créer la facture"),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class Invoice {
  final String clientName;
  final double amount;
  final DateTime date;

  Invoice(this.clientName, this.amount, this.date);
}

class Expense {
  final double amount;

  Expense(this.amount);
}
