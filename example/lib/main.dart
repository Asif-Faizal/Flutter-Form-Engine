import 'package:flutter/material.dart';

import 'screens/custom_demo_screen.dart';
import 'screens/home_screen.dart';
import 'theme/app_theme.dart';

void main() {
  registerExampleCustomWidgets(theme: AppTheme.formEngineTheme);
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
