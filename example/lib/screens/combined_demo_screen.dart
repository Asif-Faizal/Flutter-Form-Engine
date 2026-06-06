import 'package:flutter/material.dart';
import 'package:flutter_form_engine/flutter_form_engine.dart';

import '../widgets/payload_display.dart';

/// Demonstrates conditional show/hide:
/// The "Category" dropdown only appears when a country is selected.
/// The "notes" field only appears when category == 'other'.
class CombinedDemoScreen extends StatefulWidget {
  const CombinedDemoScreen({super.key});

  @override
  State<CombinedDemoScreen> createState() => _CombinedDemoScreenState();
}

class _CombinedDemoScreenState extends State<CombinedDemoScreen> {
  Map<String, dynamic>? _lastPayload;

  static final _schema = FormSchema.fromMap({
    'id': 'combined_demo',
    'title': 'Combined demo',
    'submitLabel': 'Continue',
    'fields': [
      {
        'key': 'full_name',
        'type': 'text',
        'label': 'Full name',
        'validations': [
          {'rule': 'required', 'message': 'Name is required'},
          {'rule': 'minLength', 'value': 2, 'message': 'Too short'},
        ],
      },
      {
        'key': 'country',
        'type': 'dropdown',
        'label': 'Country',
        'validations': [
          {'rule': 'required', 'message': 'Select a country'},
        ],
        'options': [
          {'label': 'India', 'value': 'IN'},
          {'label': 'United States', 'value': 'US'},
          {'label': 'Other', 'value': 'OTHER'},
        ],
      },
      {
        'key': 'category',
        'type': 'dropdown',
        'label': 'Category (appears after country)',
        'dependsOn': {
          'field': 'country',
          'condition': 'notEmpty',
          'action': 'show',
          'clearOnHide': true,
        },
        'validations': [
          {'rule': 'required', 'message': 'Select a category'},
        ],
        'options': [
          {'label': 'Technology', 'value': 'tech'},
          {'label': 'Design', 'value': 'design'},
          {'label': 'Other', 'value': 'other'},
        ],
      },
      {
        'key': 'notes',
        'type': 'text',
        'label': 'Please specify',
        'hint': 'Describe your category',
        'dependsOn': {
          'field': 'category',
          'condition': 'equals',
          'value': 'other',
          'action': 'show',
          'clearOnHide': true,
        },
        'validations': [
          {'rule': 'required', 'message': 'Please specify'},
        ],
      },
    ],
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Combined + conditional')),
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
