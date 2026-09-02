import 'package:flutter/material.dart';
import 'package:flutter_form_engine/flutter_form_engine.dart';

import '../widgets/payload_display.dart';

class DateDemoScreen extends StatefulWidget {
  const DateDemoScreen({super.key});

  @override
  State<DateDemoScreen> createState() => _DateDemoScreenState();
}

class _DateDemoScreenState extends State<DateDemoScreen> {
  Map<String, dynamic>? _lastPayload;

  static final _schema = FormSchema.fromMap({
    'id': 'date_demo',
    'title': 'Date demo',
    'submitLabel': 'Submit',
    'fields': [
      {
        'key': 'dob',
        'type': 'date',
        'label': 'Date of birth',
        'dateFormat': 'dd/MM/yyyy',
        'maxDate': '2010-01-01',
        'validations': [
          {'rule': 'required', 'message': 'Date of birth is required'},
          {'rule': 'minAge', 'value': 18, 'message': 'Must be 18 or older'},
        ],
      },
      {
        'key': 'appointment',
        'type': 'date',
        'label': 'Appointment date',
        'hint': 'Select a future date',
        'minDate': '2026-01-01',
        'maxDate': '2026-12-31',
        'dependsOn': {
          'field': 'dob',
          'condition': 'notEmpty',
          'action': 'show',
        },
        'validations': [
          {'rule': 'required', 'message': 'Pick an appointment date'},
        ],
      },
    ],
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Date demo')),
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
