# Multi-select field (`type: "multiSelect"`)

Multiple-choice input rendered as a list of checkboxes. The submitted value is a `List` of selected option values.

## When to use

Use `multiSelect` when the user may pick zero or more options from a fixed list. For exactly one choice, use `radio` or `dropdown`.

## JSON schema

| Property | Type | Required | Description |
|----------|------|----------|-------------|
| `key` | string | yes | Unique field identifier |
| `type` | `"multiSelect"` | yes | Field type |
| `label` | string | yes | Group label |
| `hint` | string | no | Helper text |
| `options` | array | yes | `{ "label": string, "value": any }` items |
| `minSelect` | number | no | Minimum selections (also validated via rules) |
| `maxSelect` | number | no | Maximum selections |
| `optionsSourceKey` | string | no | Parent field for dependent options |
| `initialValue` | array | no | Pre-selected values |
| `validations` | array | no | `required`, `minSelect`, `maxSelect` |
| `dependsOn` | object | no | Conditional visibility/enable rules |

## Example

```json
{
  "key": "skills",
  "type": "multiSelect",
  "label": "Skills",
  "hint": "Pick 1 to 3 skills",
  "minSelect": 1,
  "maxSelect": 3,
  "validations": [
    { "rule": "required", "message": "Select at least one skill" },
    { "rule": "minSelect", "value": 1, "message": "Pick at least 1" },
    { "rule": "maxSelect", "value": 3, "message": "Pick at most 3" }
  ],
  "options": [
    { "label": "Flutter", "value": "flutter" },
    { "label": "Dart", "value": "dart" },
    { "label": "Firebase", "value": "firebase" },
    { "label": "GraphQL", "value": "graphql" }
  ]
}
```

## Submitted value

Array of selected values, e.g. `["flutter", "dart"]`. Empty selection is `[]`.

## Validation rules

| Rule | Description |
|------|-------------|
| `required` | List must not be empty |
| `minSelect` | Minimum number of selections |
| `maxSelect` | Maximum number of selections |

## Dependent options

Supports `optionsSourceKey` and `options[].when` — same as dropdown. Stale selections are cleared when the parent field changes.

## Flutter usage

```dart
FormEngineWidget(
  schema: FormSchema.fromMap({...}),
  onSubmit: (values) {
    final skills = values['skills'] as List<dynamic>;
    print(skills);
  },
)
```

## Demo

Run the example app and open **Multi-select** from the home screen.
