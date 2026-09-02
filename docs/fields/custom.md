# Custom field (`type: "custom"`)

Bring your own widget for fields that are not covered by built-in types. Custom fields use the same `BaseFieldWidget` contract as built-in fields.

## When to use

Use `custom` for domain-specific inputs: star ratings, signatures, color pickers, sliders, file uploads, or any UI that cannot be expressed with standard field types.

## JSON schema

| Property | Type | Required | Description |
|----------|------|----------|-------------|
| `key` | string | yes | Unique field identifier |
| `type` | `"custom"` | yes | Field type |
| `label` | string | yes | Field label |
| `hint` | string | no | Helper text |
| `extra` | object | yes | Custom config passed to your widget (e.g. `widgetId`) |
| `validations` | array | no | Standard validation rules |
| `dependsOn` | object | no | Conditional rules |

## Example JSON

```json
{
  "key": "rating",
  "type": "custom",
  "label": "Your rating",
  "hint": "Tap stars to rate",
  "extra": {
    "widgetId": "star_rating",
    "maxStars": 5
  },
  "validations": [
    { "rule": "required", "message": "Please provide a rating" }
  ]
}
```

## Step 1 — Create a widget

Extend `BaseFieldWidget` and read config from `schema.extra`:

```dart
import 'package:flutter/material.dart';
import 'package:flutter_form_engine/flutter_form_engine.dart';

class StarRatingFieldWidget extends BaseFieldWidget {
  const StarRatingFieldWidget({
    super.key,
    required super.schema,
    required super.value,
    required super.error,
    required super.enabled,
    required super.onChanged,
    required super.onFocusLost,
    required super.resolvedOptions,
  });

  @override
  Widget build(BuildContext context) {
    final maxStars = (schema.extra['maxStars'] as int?) ?? 5;
    // Build your UI, call onChanged(newValue) and onFocusLost()
    return Text('Rating: $value / $maxStars');
  }
}
```

## Step 2 — Register at startup

Pass `customWidgets` to `FormEngineLocator.setup()`. Use `schema.extra['widgetId']` to dispatch multiple custom widgets:

```dart
void main() {
  FormEngineLocator.setup(
    theme: FormEngineTheme.carbon(),
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
          switch (schema.extra['widgetId']) {
            case 'star_rating':
              return StarRatingFieldWidget(
                schema: schema,
                value: value,
                error: error,
                enabled: enabled,
                onChanged: onChanged,
                onFocusLost: onFocusLost,
                resolvedOptions: resolvedOptions,
              );
            default:
              return Text('Unknown widget: ${schema.extra['widgetId']}');
          }
        },
      ),
    ],
  );
  runApp(const MyApp());
}
```

## Step 3 — Use in JSON forms

```dart
FormEngineWidget(
  schema: FormSchema.fromMap({...}),
  onSubmit: (values) => print(values['rating']),
)
```

## Widget contract

Every field builder receives:

| Parameter | Description |
|-----------|-------------|
| `schema` | Full `FieldSchema` including `extra` |
| `value` | Current field value |
| `error` | Validation error message (null if valid) |
| `enabled` | Whether the field is interactive |
| `onChanged` | Call when value changes |
| `onFocusLost` | Call after user finishes editing (triggers validation) |
| `resolvedOptions` | Options after dependency resolution |

## Registering a dedicated FieldType (advanced)

You can also register a new `FieldType` value and widget without using `custom`:

```dart
FormEngineLocator.setup(
  customWidgets: [
    MapEntry(FieldType.slider, ({...}) => SliderFieldWidget(...)),
  ],
);
```

This requires adding the enum value to `FieldType` in the package.

## Demo

The example app registers a `star_rating` custom widget. Run the app and open **Custom field** from the home screen.

See also: `example/lib/widgets/star_rating_field_widget.dart` and `example/lib/screens/custom_demo_screen.dart`.
