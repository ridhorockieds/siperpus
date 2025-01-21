import 'package:flutter/material.dart';
import '../models/transaction_model.dart';
import '../services/transaction_service.dart';
import 'add_transaction_page.dart';
import 'detail_transaction_page.dart';
import 'dart:async';
import 'dart:io';

class TransactionPage extends StatefulWidget {
  const TransactionPage({super.key});

  @override
  _TransactionPageState createState() => _TransactionPageState();
}

class _TransactionPageState extends State<TransactionPage> {
  late Future<List<Transaction>> _transactionsFuture;

  @override
  void initState() {
    super.initState();
    _loadTransaction();
  }

  void _loadTransaction() {
    setState(() {
      _transactionsFuture = TransactionService.fetchTransactions();
    });
  }

  Future<void> onRefresh() async {
    try {
      final freshData = await TransactionService.fetchTransactions();
      setState(() {
        _transactionsFuture = Future.value(freshData);
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Failed to refresh data'),
          backgroundColor: Colors.red,
          behavior: SnackBarBehavior.floating,
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: RefreshIndicator(
        color: Colors.blue,
        backgroundColor: Colors.white,
        onRefresh: onRefresh,
        child: FutureBuilder<List<Transaction>>(
          future: _transactionsFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                  child: CircularProgressIndicator(
                color: Colors.blue,
                strokeWidth: 3.0,
              ));
            } else if (snapshot.hasError) {
              String errorMessage;

              if (snapshot.error is SocketException) {
                errorMessage = 'Not connected to the internet.';
              } else if (snapshot.error is TimeoutException) {
                errorMessage = 'Request timed out.';
              } else if (snapshot.error.toString().contains('404')) {
                errorMessage = 'Data not found.';
              } else if (snapshot.error.toString().contains('500')) {
                errorMessage = 'Error fetching data from the server.';
              } else {
                errorMessage = 'An error occurred.';
              }

              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.error, color: Colors.red, size: 48),
                    const SizedBox(height: 16),
                    Text(
                      errorMessage,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                      ),
                      onPressed: () {
                        setState(() {
                          _transactionsFuture =
                              TransactionService.fetchTransactions();
                        });
                      },
                      child: const Text(
                        'Refresh',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ],
                ),
              );
            } else {
              final transactions = snapshot.data ?? [];
              return ListView.builder(
                padding: const EdgeInsets.all(16.0),
                itemCount: transactions.length,
                itemBuilder: (context, index) {
                  final transaction = transactions[index];
                  return CardList(
                      transaction: transaction,
                      onTransactionLoaded: _loadTransaction);
                },
              );
            }
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        elevation: 2.0,
        shape: const CircleBorder(),
        onPressed: () {
          Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const AddTransactionPage()))
              .then((onTransactionLoaded) => _loadTransaction());
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}

class CardList extends StatelessWidget {
  final Transaction transaction;
  final VoidCallback onTransactionLoaded;
  const CardList(
      {super.key,
      required this.transaction,
      required this.onTransactionLoaded});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2.0,
      color: Colors.white,
      margin: const EdgeInsets.only(bottom: 15.0),
      child: ListTile(
        title: Text('${transaction.book.title} • ${transaction.publisher.name}',
            style: const TextStyle(
              fontWeight: FontWeight.bold,
            )),
        subtitle:
            Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(transaction.book.price,
              style: const TextStyle(
                fontWeight: FontWeight.w400,
              )),
          Text(
            'Total: ${transaction.total}',
            style: const TextStyle(
              fontWeight: FontWeight.w400,
            ),
          ),
        ]),
        trailing: const Icon(Icons.arrow_forward_ios),
        onTap: () => {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => DetailTransactionPage(
                        transaction: transaction,
                      ))).then((result) => onTransactionLoaded())
        },
      ),
    );
  }
}
