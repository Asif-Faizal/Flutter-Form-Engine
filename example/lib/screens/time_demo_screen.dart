import 'package:flutter/material.dart';
import 'package:flutter_form_engine/flutter_form_engine.dart';

import '../widgets/payload_display.dart';

class TimeDemoScreen extends StatefulWidget {
  const TimeDemoScreen({super.key});

  @override
  State<TimeDemoScreen> createState() => _TimeDemoScreenState();
}

class _TimeDemoScreenState extends State<TimeDemoScreen> {
  Map<String, dynamic>? _lastPayload;

  static final _schema = FormSchema.fromMap({
    'id': 'time_demo',
    'title': 'Time demo',
    'submitLabel': 'Submit',
    'fields': [
      {
        'key': 'appointment_time',
        'type': 'time',
        'label': 'Preferred time (24h)',
        'use24Hour': true,
        'validations': [
          {'rule': 'required', 'message': 'Select a time'},
        ],
      },
      {
        'key': 'reminder_time',
        'type': 'time',
        'label': 'Reminder (12h)',
        'use24Hour': false,
        'dependsOn': {
          'field': 'appointment_time',
          'condition': 'notEmpty',
          'action': 'show',
        },
      },
    ],
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Time demo')),
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
