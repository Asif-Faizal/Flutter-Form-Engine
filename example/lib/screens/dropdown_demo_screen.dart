import 'package:flutter/material.dart';
import 'package:flutter_form_engine/flutter_form_engine.dart';

import '../widgets/payload_display.dart';

class DropdownDemoScreen extends StatefulWidget {
  const DropdownDemoScreen({super.key});

  @override
  State<DropdownDemoScreen> createState() => _DropdownDemoScreenState();
}

class _DropdownDemoScreenState extends State<DropdownDemoScreen> {
  Map<String, dynamic>? _lastPayload;

  static final _schema = FormSchema.fromMap({
    'id': 'dropdown_demo',
    'title': 'Dropdown demo',
    'submitLabel': 'Submit',
    'fields': [
      {
        'key': 'country',
        'type': 'dropdown',
        'label': 'Country',
        'hint': 'Select a country',
        'validations': [
          {'rule': 'required', 'message': 'Please select a country'},
        ],
        'options': [
          {'label': 'India', 'value': 'IN'},
          {'label': 'United States', 'value': 'US'},
          {'label': 'United Kingdom', 'value': 'GB'},
          {'label': 'Germany', 'value': 'DE'},
          {'label': 'Japan', 'value': 'JP'},
        ],
      },
      {
        'key': 'category',
        'type': 'dropdown',
        'label': 'Category',
        'validations': [
          {'rule': 'required', 'message': 'Please select a category'},
        ],
        'options': [
          {'label': 'Technology', 'value': 'tech'},
          {'label': 'Design', 'value': 'design'},
          {'label': 'Business', 'value': 'business'},
          {'label': 'Science', 'value': 'science'},
        ],
      },
    ],
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Dropdown demo')),
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
