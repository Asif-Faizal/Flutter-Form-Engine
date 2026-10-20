import 'package:flutter/material.dart';
import 'package:flutter_form_engine/flutter_form_engine.dart';

import '../widgets/payload_display.dart';

class MediaDemoScreen extends StatefulWidget {
  const MediaDemoScreen({super.key});

  @override
  State<MediaDemoScreen> createState() => _MediaDemoScreenState();
}

class _MediaDemoScreenState extends State<MediaDemoScreen> {
  Map<String, dynamic>? _lastPayload;

  static final _schema = FormSchema.fromMap({
    'id': 'media_demo',
    'title': 'Media demo',
    'submitLabel': 'Submit',
    'fields': [
      {
        'key': 'resume',
        'type': 'media',
        'label': 'Resume',
        'hint': 'PDF or DOCX only',
        'allowedExtensions': ['pdf', 'docx'],
        'maxFileSize': 10 * 1024 * 1024,
        'maxFiles': 1,
        'validations': [
          {'rule': 'required', 'message': 'Resume is required'},
          {
            'rule': 'allowedExtensions',
            'value': ['pdf', 'docx'],
            'message': 'Only PDF or DOCX allowed',
          },
        ],
      },
      {
        'key': 'supporting_clips',
        'type': 'media',
        'label': 'Supporting clips',
        'allowedExtensions': 'mp4,mov',
        'allowMultiple': true,
        'maxFiles': 3,
        'maxFileSize': 50 * 1024 * 1024,
        'dependsOn': {
          'field': 'resume',
          'condition': 'notEmpty',
          'action': 'show',
        },
        'validations': [
          {'rule': 'maxFiles', 'value': 3, 'message': 'Max 3 clips'},
        ],
      },
    ],
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Media demo')),
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
