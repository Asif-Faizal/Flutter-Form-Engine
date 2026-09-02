import 'package:flutter/material.dart';
import 'package:flutter_form_engine/flutter_form_engine.dart';

import '../widgets/payload_display.dart';

class MultiSelectDemoScreen extends StatefulWidget {
  const MultiSelectDemoScreen({super.key});

  @override
  State<MultiSelectDemoScreen> createState() => _MultiSelectDemoScreenState();
}

class _MultiSelectDemoScreenState extends State<MultiSelectDemoScreen> {
  Map<String, dynamic>? _lastPayload;

  static final _schema = FormSchema.fromMap({
    'id': 'multiselect_demo',
    'title': 'Multi-select demo',
    'submitLabel': 'Submit',
    'fields': [
      {
        'key': 'skills',
        'type': 'multiSelect',
        'label': 'Skills',
        'hint': 'Pick 1 to 3 skills',
        'minSelect': 1,
        'maxSelect': 3,
        'validations': [
          {'rule': 'required', 'message': 'Select at least one skill'},
          {'rule': 'minSelect', 'value': 1, 'message': 'Pick at least 1'},
          {'rule': 'maxSelect', 'value': 3, 'message': 'Pick at most 3'},
        ],
        'options': [
          {'label': 'Flutter', 'value': 'flutter'},
          {'label': 'Dart', 'value': 'dart'},
          {'label': 'Firebase', 'value': 'firebase'},
          {'label': 'GraphQL', 'value': 'graphql'},
        ],
      },
    ],
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Multi-select demo')),
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
