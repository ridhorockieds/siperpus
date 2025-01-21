import 'package:flutter/material.dart';
import '../models/transaction_add_model.dart';
import '../services/transaction_add_service.dart';
import 'dart:async';
import 'dart:io';

class AddTransactionPage extends StatefulWidget {
  const AddTransactionPage({super.key});

  @override
  _AddTransactionPageState createState() => _AddTransactionPageState();
}

class _AddTransactionPageState extends State<AddTransactionPage> {
  List<Book> books = [];
  List<Publisher> publishers = [];
  Book? selectedBook;
  Publisher? selectedPublisher;
  TextEditingController totalController = TextEditingController();
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  Future<void> _fetchData() async {
    try {
      final fetchedBooks = await TransactionAddService.fetchBooks();
      final fetchedPublishers = await TransactionAddService.fetchPublishers();
      if (mounted) {
        setState(() {
          books = fetchedBooks;
          publishers = fetchedPublishers;
          isLoading = false;
        });
      }
    } on SocketException {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            duration: Duration(seconds: 2),
            content: Text('No internet connection'),
            backgroundColor: Colors.red,
            behavior: SnackBarBehavior.floating,
          ),
        );
        setState(() {
          isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            duration: Duration(seconds: 2),
            content: Text('Error fetching data'),
            backgroundColor: Colors.red,
            behavior: SnackBarBehavior.floating,
          ),
        );
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  Future<void> _submitForm() async {
    if (selectedBook == null ||
        selectedPublisher == null ||
        totalController.text.isEmpty) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              duration: Duration(seconds: 2),
              content: Text('Please fill in all fields'),
              backgroundColor: Colors.red,
              behavior: SnackBarBehavior.floating),
        );
      }
      return;
    }

    try {
      await TransactionAddService.createTransaction(
        selectedBook!.id,
        selectedPublisher!.id,
        int.parse(totalController.text),
      );
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          duration: Duration(seconds: 2),
          content: Text('Transaction created successfully'),
          behavior: SnackBarBehavior.floating,
          backgroundColor: Colors.green,
        ),
      );
      await Future.delayed(const Duration(seconds: 2));
      Navigator.pop(context, true);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          duration: Duration(seconds: 2),
          content: Text('Error creating transaction'),
          behavior: SnackBarBehavior.floating,
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          backgroundColor: Colors.grey[50],
          appBar: AppBar(
            title: const Text(
              'Add Transaction',
              style: TextStyle(color: Colors.white),
            ),
            backgroundColor: Colors.blue,
            foregroundColor: Colors.white,
          ),
          body: isLoading
              ? const Center(
                  child: CircularProgressIndicator(
                  backgroundColor: Colors.white,
                  color: Colors.blue,
                  strokeWidth: 3.0,
                ))
              : Card(
                  elevation: 2.0,
                  color: Colors.white,
                  margin: const EdgeInsets.all(16.0),
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Select Book:',
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 8),
                        DropdownButtonFormField<Book>(
                          isExpanded: true,
                          dropdownColor: Colors.white,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: const BorderSide(
                                  color: Colors.grey,
                                  width: 2.0,
                                )),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: const BorderSide(
                                color: Colors.blue,
                                width: 2.0,
                              ),
                            ),
                          ),
                          value: selectedBook,
                          hint: const Text('Select a Book'),
                          items: books
                              .map(
                                (book) => DropdownMenuItem<Book>(
                                  value: book,
                                  child: Text(book.title),
                                ),
                              )
                              .toList(),
                          onChanged: (value) {
                            setState(() {
                              selectedBook = value;
                            });
                          },
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          'Select Publisher:',
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 8),
                        DropdownButtonFormField<Publisher>(
                          isExpanded: true,
                          dropdownColor: Colors.white,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: const BorderSide(
                                  color: Colors.grey,
                                  width: 2.0,
                                )),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: const BorderSide(
                                color: Colors.blue,
                                width: 2.0,
                              ),
                            ),
                          ),
                          value: selectedPublisher,
                          hint: const Text('Select a Publisher'),
                          items: publishers
                              .map(
                                (publisher) => DropdownMenuItem<Publisher>(
                                  value: publisher,
                                  child: Text(publisher.name),
                                ),
                              )
                              .toList(),
                          onChanged: (value) {
                            setState(() {
                              selectedPublisher = value;
                            });
                          },
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          'Total:',
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 8),
                        TextFormField(
                          controller: totalController,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: const BorderSide(
                                  color: Colors.grey,
                                  width: 2.0,
                                )),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: const BorderSide(
                                color: Colors.blue,
                                width: 2.0,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        SizedBox(
                          width: double.infinity, // Lebar penuh
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.blue, elevation: 0.0),
                            onPressed: () => _submitForm(),
                            child: const Text(
                              'Save',
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                )),
    );
  }
}
