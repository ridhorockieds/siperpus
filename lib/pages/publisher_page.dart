import 'package:flutter/material.dart';
import '../models/publisher_model.dart';
import '../services/publisher_service.dart';
import '../pages/add_publisher_page.dart';
import '../pages/detail_publisher_page.dart';
import 'dart:async';
import 'dart:io';

class PublisherPage extends StatefulWidget {
  const PublisherPage({super.key});

  @override
  _PublisherPageState createState() => _PublisherPageState();
}

class _PublisherPageState extends State<PublisherPage> {
  late Future<List<Publisher>> _publishersFuture;

  @override
  void initState() {
    super.initState();
    _loadPublisher();
  }

  void _loadPublisher() {
    setState(() {
      _publishersFuture = PublisherService.fetchPublisher();
    });
  }

  Future<void> onRefresh() async {
    try {
      final freshData = await PublisherService.fetchPublisher();
      setState(() {
        _publishersFuture = Future.value(freshData);
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
        child: FutureBuilder<List<Publisher>>(
          future: _publishersFuture,
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
                          _publishersFuture = PublisherService.fetchPublisher();
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
              final publishers = snapshot.data ?? [];
              return ListView.builder(
                padding: const EdgeInsets.all(16.0),
                itemCount: publishers.length,
                itemBuilder: (context, index) {
                  final publisher = publishers[index];
                  return CardList(
                      publisher: publisher, onPublisherLoaded: _loadPublisher);
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
                      builder: (context) => const AddPublisherFormPage()))
              .then((onPublisherLoaded) => _loadPublisher());
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}

class CardList extends StatelessWidget {
  final Publisher publisher;
  final VoidCallback onPublisherLoaded;
  const CardList(
      {super.key, required this.publisher, required this.onPublisherLoaded});

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
              'Id: ${publisher.id}',
              style: const TextStyle(
                fontWeight: FontWeight.normal,
              ),
            ),
            Text(
              'Name: ${publisher.name}',
              style: const TextStyle(
                fontWeight: FontWeight.normal,
              ),
            ),
            Text(
              'Phone: ${publisher.phone}',
              style: const TextStyle(
                fontWeight: FontWeight.normal,
              ),
            ),
          ],
        ),
        subtitle:
            Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(publisher.address,
              style: const TextStyle(
                fontWeight: FontWeight.normal,
              ))
        ]),
        trailing: const Icon(Icons.arrow_forward_ios),
        onTap: () => {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => DetailPublisherPage(
                        publisher: publisher,
                      ))).then((result) => onPublisherLoaded())
        },
      ),
    );
  }
}
