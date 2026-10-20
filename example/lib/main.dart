import 'package:flutter/material.dart';

import 'media/demo_media_picker.dart';
import 'screens/custom_demo_screen.dart';
import 'screens/home_screen.dart';
import 'theme/app_theme.dart';

final navigatorKey = GlobalKey<NavigatorState>();

void main() {
<<<<<<< HEAD
  registerExampleCustomWidgets(theme: AppTheme.formEngineTheme);
=======
  FormEngineLocator.setup(
    theme: AppTheme.formEngineTheme,
    mediaPicker: DemoMediaPicker(navigatorKey),
  );
  registerExampleCustomWidgets();
>>>>>>> e327aa8 (feat: add image field with camera/gallery capture and media foundation)
  runApp(const ExampleApp());
}

class ExampleApp extends StatelessWidget {
  const ExampleApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: navigatorKey,
      title: 'Form Engine Example',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.materialTheme,
      home: const HomeScreen(),
    );
  }
}
