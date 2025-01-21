import 'package:flutter/material.dart';
import 'pages/transaction_page.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

void main() async {
  await dotenv.load(fileName: ".env");
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: DefaultTabController(
        length: 3,
        initialIndex: 2,
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.blue,
            bottom: const TabBar(
              indicatorSize: TabBarIndicatorSize.label,
              dividerColor: Colors.white,
              indicatorWeight: 5.0,
              tabs: [
                Tab(text: 'Book'),
                Tab(text: 'Publisher'),
                Tab(
                  text: 'Transaction',
                ),
              ],
              labelColor: Colors.white,
              unselectedLabelColor: Colors.white70,
              indicatorColor: Colors.white,
              labelStyle: TextStyle(fontWeight: FontWeight.w600),
            ),
            title: Text(
              '${dotenv.env['APP_NAME']}',
              style: const TextStyle(
                  fontWeight: FontWeight.w700, color: Colors.white),
            ),
          ),
          body: const TabBarView(
            children: [
              Center(
                child: Text('Book Page'),
              ),
              Center(
                child: Text('Publisher Page'),
              ),
              TransactionPage(),
            ],
          ),
        ),
      ),
    );
  }
}
