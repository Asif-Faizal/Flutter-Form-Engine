import 'package:flutter/material.dart';
import 'package:flutter_form_engine/flutter_form_engine.dart';

import '../widgets/payload_display.dart';

class RadioDemoScreen extends StatefulWidget {
  const RadioDemoScreen({super.key});

  @override
  State<RadioDemoScreen> createState() => _RadioDemoScreenState();
}

class _RadioDemoScreenState extends State<RadioDemoScreen> {
  Map<String, dynamic>? _lastPayload;

  static final _schema = FormSchema.fromMap({
    'id': 'radio_demo',
    'title': 'Radio demo',
    'submitLabel': 'Submit',
    'fields': [
      {
        'key': 'gender',
        'type': 'radio',
        'label': 'Gender',
        'hint': 'Select one option',
        'validations': [
          {'rule': 'required', 'message': 'Please select a gender'},
        ],
        'options': [
          {'label': 'Male', 'value': 'M'},
          {'label': 'Female', 'value': 'F'},
          {'label': 'Other', 'value': 'O'},
        ],
      },
      {
        'key': 'plan',
        'type': 'radio',
        'label': 'Subscription plan',
        'dependsOn': {
          'field': 'gender',
          'condition': 'notEmpty',
          'action': 'show',
        },
        'options': [
          {'label': 'Basic', 'value': 'basic'},
          {'label': 'Pro', 'value': 'pro'},
        ],
      },
    ],
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Radio demo')),
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
