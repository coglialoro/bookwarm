import 'package:bookwarm/schermate/home.dart';
import 'package:flutter/material.dart';

void main() async {
  runApp(
    const App(),
  );
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: "BookWarm",
      home: HomePage(),
      debugShowCheckedModeBanner: false, // Toglie il banner di debug
    );
  }
}
