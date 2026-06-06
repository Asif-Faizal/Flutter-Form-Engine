import 'package:flutter/material.dart';
import 'package:flutter_form_engine/flutter_form_engine.dart';

import 'screens/home_screen.dart';

void main() {
  FormEngineLocator.setup();
  runApp(const ExampleApp());
}

class ExampleApp extends StatelessWidget {
  const ExampleApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Form Engine Example',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorSchemeSeed: Colors.indigo,
        useMaterial3: true,
      ),
      home: const HomeScreen(),
    );
  }
}
