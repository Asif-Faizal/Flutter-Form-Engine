# Checkbox field (`type: "checkbox"`)

Boolean input rendered as a single checkbox with a label.

## When to use

Use `checkbox` for yes/no consent, terms acceptance, or any single true/false value. For multiple independent booleans, use separate checkbox fields.

## JSON schema

| Property | Type | Required | Description |
|----------|------|----------|-------------|
| `key` | string | yes | Unique field identifier |
| `type` | `"checkbox"` | yes | Field type |
| `label` | string | yes | Label shown next to the checkbox |
| `hint` | string | no | Subtitle/helper text |
| `initialValue` | boolean | no | Default `false` |
| `validations` | array | no | Use `mustBeTrue` for required acceptance |
| `dependsOn` | object | no | Conditional show/hide/enable rule |
| `enabled` | boolean | no | Default `true` |

## Example — terms acceptance

```json
{
  "key": "accept_terms",
  "type": "checkbox",
  "label": "I accept the terms and conditions",
  "hint": "You must accept to continue",
  "validations": [
    { "rule": "mustBeTrue", "message": "You must accept the terms" }
  ]
}
```

## Example — optional preference

```json
{
  "key": "newsletter",
  "type": "checkbox",
  "label": "Subscribe to newsletter",
  "initialValue": false
}
```

## Submitted value

`true` or `false`.

## Validation rules

| Rule | Description |
|------|-------------|
| `mustBeTrue` | Checkbox must be checked (common for terms) |
| `required` | Treats unchecked as invalid |

## Flutter usage

Registered automatically by `FormEngineLocator.setup()`.

```dart
FormEngineWidget(
  schema: FormSchema.fromMap({
    'id': 'signup',
    'title': 'Sign up',
    'fields': [
      {
        'key': 'accept_terms',
        'type': 'checkbox',
        'label': 'I accept the terms',
        'validations': [
          {'rule': 'mustBeTrue', 'message': 'Required'},
        ],
      },
    ],
  }),
  onSubmit: (values) => print(values['accept_terms']),
)
```

## Demo

Run the example app and open **Checkbox** from the home screen.
