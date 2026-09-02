import 'package:flutter/material.dart';
import 'package:flutter_form_engine/flutter_form_engine.dart';

import '../widgets/payload_display.dart';

class SearchableDropdownDemoScreen extends StatefulWidget {
  const SearchableDropdownDemoScreen({super.key});

  @override
  State<SearchableDropdownDemoScreen> createState() =>
      _SearchableDropdownDemoScreenState();
}

class _SearchableDropdownDemoScreenState
    extends State<SearchableDropdownDemoScreen> {
  Map<String, dynamic>? _lastPayload;

  static final _schema = FormSchema.fromMap({
    'id': 'searchable_dropdown_demo',
    'title': 'Searchable dropdown demo',
    'submitLabel': 'Submit',
    'fields': [
      {
        'key': 'country',
        'type': 'dropdown',
        'label': 'Country',
        'options': [
          {'label': 'India', 'value': 'IN'},
          {'label': 'United States', 'value': 'US'},
        ],
      },
      {
        'key': 'city',
        'type': 'searchableDropdown',
        'label': 'City',
        'hint': 'Type to search cities…',
        'searchable': true,
        'optionsSourceKey': 'country',
        'dependsOn': {
          'field': 'country',
          'condition': 'notEmpty',
          'action': 'show',
          'clearOnHide': true,
        },
        'validations': [
          {'rule': 'required', 'message': 'Select a city'},
        ],
        'extra': {
          'optionsBySource': {
            'IN': [
              {'label': 'Mumbai', 'value': 'mumbai'},
              {'label': 'Delhi', 'value': 'delhi'},
              {'label': 'Bengaluru', 'value': 'bengaluru'},
              {'label': 'Chennai', 'value': 'chennai'},
            ],
            'US': [
              {'label': 'New York', 'value': 'nyc'},
              {'label': 'San Francisco', 'value': 'sf'},
              {'label': 'Chicago', 'value': 'chicago'},
              {'label': 'Austin', 'value': 'austin'},
            ],
          },
        },
      },
    ],
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Searchable dropdown demo')),
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
