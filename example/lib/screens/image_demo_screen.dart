import 'package:flutter/material.dart';
import 'package:flutter_form_engine/flutter_form_engine.dart';

import '../widgets/payload_display.dart';

class ImageDemoScreen extends StatefulWidget {
  const ImageDemoScreen({super.key});

  @override
  State<ImageDemoScreen> createState() => _ImageDemoScreenState();
}

class _ImageDemoScreenState extends State<ImageDemoScreen> {
  Map<String, dynamic>? _lastPayload;

  static final _schema = FormSchema.fromMap({
    'id': 'image_demo',
    'title': 'Image demo',
    'submitLabel': 'Submit',
    'fields': [
      {
        'key': 'profile_photo',
        'type': 'image',
        'label': 'Profile photo',
        'hint': 'Capture with camera or pick from gallery',
        'allowCamera': true,
        'allowGallery': true,
        'allowedExtensions': ['jpg', 'jpeg', 'png', 'webp'],
        'maxFileSize': 5 * 1024 * 1024,
        'validations': [
          {'rule': 'required', 'message': 'Profile photo is required'},
        ],
      },
      {
        'key': 'id_scan',
        'type': 'image',
        'label': 'ID scan (camera only)',
        'allowCamera': true,
        'allowGallery': false,
        'allowedExtensions': ['jpg', 'png'],
        'dependsOn': {
          'field': 'profile_photo',
          'condition': 'notEmpty',
          'action': 'show',
        },
      },
    ],
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Image demo')),
      body: Column(
        children: [
          Expanded(
            child: FormEngineWidget(
              schema: _schema,
              onSubmit: (values) => setState(() => _lastPayload = values),
            ),
          ),
          if (_lastPayload != null) PayloadDisplay(payload: _lastPayload!),
        ],
      ),
    );
  }
}
