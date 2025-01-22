import 'package:flutter/material.dart';
import '../models/book_model.dart';
import '../services/book_service.dart';
import '../pages/add_book.dart';
import '../pages/detail_book.dart';
import 'dart:async';
import 'dart:io';

class BookPage extends StatefulWidget {
  const BookPage({super.key});

  @override
  _BookPageState createState() => _BookPageState();
}

class _BookPageState extends State<BookPage> {
  late Future<List<Book>> _booksFuture;

  @override
  void initState() {
    super.initState();
    _loadBook();
  }

  void _loadBook() {
    setState(() {
      _booksFuture = BookService.fetchBook();
    });
  }

  Future<void> onRefresh() async {
    try {
      final freshData = await BookService.fetchBook();
      setState(() {
        _booksFuture = Future.value(freshData);
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
        child: FutureBuilder<List<Book>>(
          future: _booksFuture,
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
                          _booksFuture = BookService.fetchBook();
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
              final books = snapshot.data ?? [];
              return ListView.builder(
                padding: const EdgeInsets.all(16.0),
                itemCount: books.length,
                itemBuilder: (context, index) {
                  final book = books[index];
                  return CardList(book: book, onBookLoaded: _loadBook);
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
                      builder: (context) => const AddBookFormPage()))
              .then((onBookLoaded) => _loadBook());
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}

class CardList extends StatelessWidget {
  final Book book;
  final VoidCallback onBookLoaded;
  const CardList({super.key, required this.book, required this.onBookLoaded});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2.0,
      color: Colors.white,
      margin: const EdgeInsets.only(bottom: 15.0),
      child: ListTile(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Id: ${book.id}',
              style: const TextStyle(
                fontWeight: FontWeight.normal,
              ),
            ),
            Text(
              'Judul: ${book.title}',
              style: const TextStyle(
                fontWeight: FontWeight.normal,
              ),
            ),
            Text(
              'Stock: ${book.stock}',
              style: const TextStyle(
                fontWeight: FontWeight.normal,
              ),
            ),
          ],
        ),
        subtitle:
            Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(book.price,
              style: const TextStyle(
                fontWeight: FontWeight.normal,
              )),
        ]),
        trailing: const Icon(Icons.arrow_forward_ios),
        onTap: () => {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => DetailBookPage(
                        book: book,
                      ))).then((result) => onBookLoaded())
        },
      ),
    );
  }
}
