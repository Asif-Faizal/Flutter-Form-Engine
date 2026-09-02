# flutter_form_engine

A JSON-driven dynamic form builder for Flutter.
Supports text fields, dropdowns, validation, and conditional field logic.
Built with BLoC + Get_it.

## Field types

See [docs/fields/README.md](docs/fields/README.md) for the full field reference:

| Type | Description |
|------|-------------|
| `text`, `email`, `number`, `phone`, `password` | Text inputs |
| `dropdown` | Single-select dropdown |
| `radio` | Single-select radio buttons |
| `checkbox` | Boolean toggle |
| `multiSelect` | Multiple checkboxes |
| `date` | Date picker |
| `time` | Time picker |
| `searchableDropdown` | Type-to-filter dropdown |
| `custom` | Register your own widget |

## Getting started

```yaml
dependencies:
  flutter_form_engine:
    path: ../   # or pub.dev version once published
```

## Usage

See the `example/` directory for a full working demo.
