# Radio field (`type: "radio"`)

Single-select input rendered as a vertical list of radio buttons.

## When to use

Use `radio` when all options should be visible at once and the user must pick exactly one. For long option lists, prefer `dropdown` or `searchableDropdown`.

## JSON schema

| Property | Type | Required | Description |
|----------|------|----------|-------------|
| `key` | string | yes | Unique field identifier |
| `type` | `"radio"` | yes | Field type |
| `label` | string | yes | Group label shown above the options |
| `hint` | string | no | Helper text below the label |
| `options` | array | yes | `{ "label": string, "value": any }` items |
| `optionsSourceKey` | string | no | Parent field key for dependent options |
| `dependsOn` | object | no | Conditional show/hide/enable rule |
| `validations` | array | no | Validation rules (e.g. `required`) |
| `enabled` | boolean | no | Default `true` |
| `visible` | boolean | no | Default `true` |
| `initialValue` | any | no | Pre-selected option value |

## Example

```json
{
  "key": "gender",
  "type": "radio",
  "label": "Gender",
  "hint": "Select one option",
  "validations": [
    { "rule": "required", "message": "Please select a gender" }
  ],
  "options": [
    { "label": "Male", "value": "M" },
    { "label": "Female", "value": "F" },
    { "label": "Other", "value": "O" }
  ]
}
```

## Submitted value

The selected option's `value` (e.g. `"M"`, `"F"`, or `"O"`).

## Conditional logic

Works with `dependsOn` actions: `show`, `hide`, `enable`, `disable`.

```json
{
  "key": "plan_type",
  "type": "radio",
  "label": "Plan",
  "dependsOn": {
    "field": "country",
    "condition": "notEmpty",
    "action": "show"
  },
  "options": [
    { "label": "Basic", "value": "basic" },
    { "label": "Pro", "value": "pro" }
  ]
}
```

## Dependent options

Options can be filtered by another field using `optionsSourceKey` or `options[].when` — same as dropdown fields.

## Flutter usage

No extra setup is required. `FormEngineLocator.setup()` registers the radio widget automatically.

```dart
FormEngineWidget(
  schema: FormSchema.fromMap({...}),
  onSubmit: (values) => print(values['gender']),
)
```

## Demo

Run the example app and open **Radio** from the home screen.
