import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../screen/home_screen.dart';

class InvoiceAndAccountingPage extends StatefulWidget {
  @override
  _InvoiceAndAccountingPageState createState() =>
      _InvoiceAndAccountingPageState();
}

class _InvoiceAndAccountingPageState extends State<InvoiceAndAccountingPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _amountController = TextEditingController();
  final List<Invoice> invoices = []; // Mettre à jour le type de liste

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
                builder: (context) =>
                    HomeScreen(), // Votre widget par défaut
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
                  decoration: InputDecoration(
                    labelText: 'Nom du client',
                    prefixIcon: Icon(Icons.person),
                  ),
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
                  decoration: InputDecoration(
                    labelText: 'Montant de la facture',
                    prefixIcon: Icon(Icons.monetization_on),
                  ),
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
                ElevatedButton(
                  onPressed: () async {
                    final DateTime? pickedDate = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime(DateTime.now().year - 5),
                      lastDate: DateTime(DateTime.now().year + 5),
                    );
                    if (pickedDate != null && pickedDate != invoiceDate) {
                      setState(() {
                        invoiceDate = pickedDate;
                      });
                    }
                  },
                  child: Text(invoiceDate != null
                      ? 'Date sélectionnée: ${DateFormat.yMd().format(invoiceDate!)}'
                      : 'Sélectionner la date'),
                ),
                ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      _formKey.currentState!.save();
                      final invoice = Invoice(
                        clientName!,
                        double.parse(invoiceAmount!),
                        invoiceDate!,
                      );
                      setState(() {
                        invoices.add(invoice);
                      });
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Text('Facture créée avec succès!'),
                      ));
                    }
                  },
                  child: Text("Créer la facture"),
                ),
                SizedBox(height: 20),
                Text(
                  'Liste des factures :',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: invoices.map((invoice) {
                    return ListTile(
                      title: Text(
                        '${invoice.clientName} - ${invoice.amount} \$ - ${DateFormat.yMd().format(invoice.date)}',
                      ),
                    );
                  }).toList(),
                ),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFF09126C),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => InvoiceHistoryPage(invoices),
            ),
          );
        },
        child: Icon(Icons.history),
      ),
    );
  }
}

class InvoiceHistoryPage extends StatelessWidget {
  final List<Invoice> invoices;

  const InvoiceHistoryPage(this.invoices);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Historique des Factures'),
        backgroundColor: const Color(0xFF09126C),
      ),
      body: ListView.builder(
        itemCount: invoices.length,
        itemBuilder: (context, index) {
          final invoice = invoices[index];
          return ListTile(
            title: Text(invoice.clientName),
            subtitle: Text(
              'Date : ${DateFormat.yMd().format(invoice.date)}, Mois : ${DateFormat.yMMM().format(invoice.date)}',
            ),
          );
        },
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
