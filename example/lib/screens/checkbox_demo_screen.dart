import 'package:flutter/material.dart';
import 'package:flutter_form_engine/flutter_form_engine.dart';

import '../widgets/payload_display.dart';

class CheckboxDemoScreen extends StatefulWidget {
  const CheckboxDemoScreen({super.key});

  @override
  State<CheckboxDemoScreen> createState() => _CheckboxDemoScreenState();
}

class _CheckboxDemoScreenState extends State<CheckboxDemoScreen> {
  Map<String, dynamic>? _lastPayload;

  static final _schema = FormSchema.fromMap({
    'id': 'checkbox_demo',
    'title': 'Checkbox demo',
    'submitLabel': 'Continue',
    'fields': [
      {
        'key': 'accept_terms',
        'type': 'checkbox',
        'label': 'I accept the terms and conditions',
        'hint': 'You must accept to continue',
        'validations': [
          {'rule': 'mustBeTrue', 'message': 'You must accept the terms'},
        ],
      },
      {
        'key': 'newsletter',
        'type': 'checkbox',
        'label': 'Subscribe to newsletter',
        'initialValue': false,
        'dependsOn': {
          'field': 'accept_terms',
          'condition': 'equals',
          'value': true,
          'action': 'show',
        },
      },
    ],
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Checkbox demo')),
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
