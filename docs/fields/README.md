# Field types reference

JSON-driven field types supported by **flutter_form_engine**.

## Built-in rendered fields

| Type | Doc | Description |
|------|-----|-------------|
| `text` | — | Single-line text input |
| `email` | — | Text with email keyboard |
| `number` | — | Numeric text input |
| `phone` | — | Phone keyboard |
| `password` | — | Obscured text |
| `dropdown` | — | Single-select dropdown |
| `radio` | [radio.md](radio.md) | Single-select radio buttons |
| `checkbox` | [checkbox.md](checkbox.md) | Boolean checkbox |
| `multiSelect` | [multi_select.md](multi_select.md) | Multi-select checkboxes |
| `date` | [date.md](date.md) | Date picker |
| `time` | [time.md](time.md) | Time picker |
| `searchableDropdown` | [searchable_dropdown.md](searchable_dropdown.md) | Filterable dropdown |
| `custom` | [custom.md](custom.md) | Bring-your-own widget |

## Quick start

```dart
import 'package:flutter_form_engine/flutter_form_engine.dart';

void main() {
  FormEngineLocator.setup(theme: FormEngineTheme.carbon());
  runApp(const MyApp());
}
```

```dart
FormEngineWidget(
  schema: FormSchema.fromJson('''
    {
      "id": "signup",
      "title": "Sign up",
      "fields": [
        { "key": "name", "type": "text", "label": "Name" },
        { "key": "plan", "type": "radio", "label": "Plan", "options": [] }
      ]
    }
  '''),
  onSubmit: (values) => print(values),
)
```

## Shared schema properties

All fields support:

- `key`, `type`, `label`
- `hint`, `required`, `enabled`, `visible`, `initialValue`
- `validations` — see validation rules in package README
- `dependsOn` — conditional show/hide/enable/disable

Option-based fields (`dropdown`, `radio`, `multiSelect`, `searchableDropdown`) also support:

- `options`, `optionsSourceKey`, `optionsEndpoint`
- `extra.optionsBySource` for grouped dependent options

## Example app

```bash
cd example
flutter pub get
flutter run
```

Each field type has a dedicated demo screen on the home page.
