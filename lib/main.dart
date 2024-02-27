import 'package:expense_tracker/database/expense_database.dart';
import 'package:expense_tracker/pages/home_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

const String title = "Expense Tracker";

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  //init db
  await ExpenseDatabase.initialize();

  runApp(ChangeNotifierProvider(
    create: (context) => ExpenseDatabase(),
    child: const MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: title,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const HomePage(title: title),
    );
  }
}
