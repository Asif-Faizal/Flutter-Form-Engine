import 'package:flutter/material.dart';
import 'package:flutter_form_engine/flutter_form_engine.dart';

import '../widgets/payload_display.dart';

class TextFieldDemoScreen extends StatefulWidget {
  const TextFieldDemoScreen({super.key});

  @override
  State<TextFieldDemoScreen> createState() => _TextFieldDemoScreenState();
}

class _TextFieldDemoScreenState extends State<TextFieldDemoScreen> {
  Map<String, dynamic>? _lastPayload;

  static final _schema = FormSchema.fromMap({
    'id': 'text_demo',
    'title': 'TextField demo',
    'submitLabel': 'Submit',
    'fields': [
      {
        'key': 'full_name',
        'type': 'text',
        'label': 'Full name',
        'hint': 'Enter your full name',
        'keyboardType': 'text',
        'maxLength': 60,
        'validations': [
          {'rule': 'required', 'message': 'Name is required'},
          {'rule': 'minLength', 'value': 3, 'message': 'Min 3 characters'},
        ],
      },
      {
        'key': 'email',
        'type': 'text',
        'label': 'Email address',
        'keyboardType': 'emailAddress',
        'validations': [
          {'rule': 'required', 'message': 'Email is required'},
          {'rule': 'email', 'message': 'Invalid email format'},
        ],
      },
      {
        'key': 'phone',
        'type': 'text',
        'label': 'Phone number',
        'keyboardType': 'phone',
        'validations': [
          {'rule': 'required', 'message': 'Phone is required'},
          {
            'rule': 'regex',
            'value': r'^[0-9]{10}$',
            'message': '10 digits only',
          },
        ],
      },
      {
        'key': 'password',
        'type': 'password',
        'label': 'Password',
        'validations': [
          {'rule': 'required', 'message': 'Password is required'},
          {'rule': 'minLength', 'value': 8, 'message': 'Min 8 characters'},
        ],
      },
    ],
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('TextField demo')),
      body: Column(
        children: [
          Expanded(
            child: FormEngineWidget(
              schema: _schema,
              showResetButton: true,
              onSubmit: (values) => setState(() => _lastPayload = values),
            ),
          ),
          if (_lastPayload != null) PayloadDisplay(payload: _lastPayload!),
        ],
      ),
    );
  }
}
