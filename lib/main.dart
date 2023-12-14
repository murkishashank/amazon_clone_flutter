import 'package:flutter/material.dart';
import 'package:flutter_amazon_clone/constants/global_variables.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Amazon Clone',
      theme: ThemeData(
        scaffoldBackgroundColor: GlobalVariables.backgroundColor,
        colorScheme: const ColorScheme.light(
          primary: GlobalVariables.secondaryColor,
        ),
        appBarTheme: const AppBarTheme(
          elevation: 0,
          iconTheme: IconThemeData(
            color: Colors.black,
          ),
        ),
      ),
      home: Scaffold(
        appBar: AppBar(
          title: const Text("Amazon Clone"),
        ),
        body: Column(
          children: [
            const Center(
              child: Text('Flutter Demo Home Page'),
            ),
            ElevatedButton(onPressed: () {}, child: Text("Click"))
          ],
        ),
      ),
    );
  }
}
