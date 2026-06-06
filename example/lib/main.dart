import 'package:flutter/material.dart';
import 'package:flutter_form_engine/flutter_form_engine.dart';

import 'screens/home_screen.dart';
import 'theme/app_theme.dart';

void main() {
  FormEngineLocator.setup(theme: AppTheme.formEngineTheme);
  runApp(const ExampleApp());
}

class ExampleApp extends StatelessWidget {
  const ExampleApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Form Engine Example',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.materialTheme,
      home: const HomeScreen(),
    );
  }
}
