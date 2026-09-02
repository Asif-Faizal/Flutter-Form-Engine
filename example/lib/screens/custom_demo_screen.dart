import 'package:flutter/material.dart';
import 'package:flutter_form_engine/flutter_form_engine.dart';

import '../widgets/payload_display.dart';
import '../widgets/star_rating_field_widget.dart';

class CustomDemoScreen extends StatefulWidget {
  const CustomDemoScreen({super.key});

  @override
  State<CustomDemoScreen> createState() => _CustomDemoScreenState();
}

class _CustomDemoScreenState extends State<CustomDemoScreen> {
  Map<String, dynamic>? _lastPayload;

  static final _schema = FormSchema.fromMap({
    'id': 'custom_demo',
    'title': 'Custom field demo',
    'submitLabel': 'Submit',
    'fields': [
      {
        'key': 'product_name',
        'type': 'text',
        'label': 'Product name',
        'validations': [
          {'rule': 'required', 'message': 'Name is required'},
        ],
      },
      {
        'key': 'rating',
        'type': 'custom',
        'label': 'Your rating',
        'hint': 'Tap stars to rate',
        'extra': {'widgetId': 'star_rating', 'maxStars': 5},
        'validations': [
          {'rule': 'required', 'message': 'Please provide a rating'},
        ],
      },
    ],
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Custom field demo')),
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

/// Registers example custom widgets. Call from `main()` before `runApp`.
void registerExampleCustomWidgets() {
  FormEngineLocator.setup(
    theme: FormEngineLocator.theme,
    customWidgets: [
      MapEntry(
        FieldType.custom,
        ({
          required schema,
          required value,
          required error,
          required enabled,
          required onChanged,
          required onFocusLost,
          required resolvedOptions,
        }) {
          final widgetId = schema.extra['widgetId'] as String?;
          if (widgetId == 'star_rating') {
            return StarRatingFieldWidget(
              schema: schema,
              value: value,
              error: error,
              enabled: enabled,
              onChanged: onChanged,
              onFocusLost: onFocusLost,
              resolvedOptions: resolvedOptions,
            );
          }
          return Text(
            'Unknown custom widget: $widgetId',
            style: TextStyle(color: FormEngineLocator.theme.errorColor),
          );
        },
      ),
    ],
    reset: true,
  );
}
