import 'package:flutter/material.dart';
import '../models/transaction_model.dart';
import '../services/transaction_service.dart';

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
          content: Text('Gagal memperbarui data'),
          backgroundColor: Colors.red,
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: RefreshIndicator(
        onRefresh: onRefresh,
        child: FutureBuilder<List<Transaction>>(
          future: _transactionsFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(
                child: Text(snapshot.error.toString()),
              );
            } else {
              final transactions = snapshot.data ?? [];
              return ListView.builder(
                padding: const EdgeInsets.all(16.0),
                itemCount: transactions.length,
                itemBuilder: (context, index) {
                  final transaction = transactions[index];
                  return Card.outlined(
                    shadowColor: Colors.black,
                    margin: const EdgeInsets.only(bottom: 16.0),
                    child: ListTile(
                      title: Text(
                          '${transaction.book.title} • ${transaction.publisher.name}',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                          )),
                      subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Price: Rp. ${transaction.book.price}',
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
                      onTap: () => print('Tapped ${transaction.id}'),
                    ),
                  );
                },
              );
            }
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          print("Floating button pressed");
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
