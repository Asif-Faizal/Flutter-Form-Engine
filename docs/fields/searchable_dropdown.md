# Searchable dropdown field (`type: "searchableDropdown"`)

Single-select dropdown with a search box to filter options by label.

## When to use

Use `searchableDropdown` when the option list is long and users need to type to find a value quickly. For short lists, use `dropdown` or `radio`.

## JSON schema

| Property | Type | Required | Description |
|----------|------|----------|-------------|
| `key` | string | yes | Unique field identifier |
| `type` | `"searchableDropdown"` | yes | Field type |
| `label` | string | yes | Field label |
| `hint` | string | no | Search placeholder (default: "Type to search…") |
| `searchable` | boolean | no | Documented flag; always searchable for this type |
| `options` | array | yes | `{ "label": string, "value": any }` items |
| `optionsSourceKey` | string | no | Parent field for dependent options |
| `optionsEndpoint` | string | no | Remote options URL |
| `validations` | array | no | e.g. `required` |
| `dependsOn` | object | no | Conditional rules |

## Example

```json
{
  "key": "city",
  "type": "searchableDropdown",
  "label": "City",
  "hint": "Search cities…",
  "searchable": true,
  "validations": [
    { "rule": "required", "message": "Select a city" }
  ],
  "options": [
    { "label": "Mumbai", "value": "mumbai" },
    { "label": "Delhi", "value": "delhi" },
    { "label": "Bengaluru", "value": "bengaluru" },
    { "label": "Chennai", "value": "chennai" },
    { "label": "Kolkata", "value": "kolkata" },
    { "label": "Hyderabad", "value": "hyderabad" }
  ]
}
```

## Submitted value

The selected option's `value` (same as `dropdown`).

## Behaviour

1. User types in the search field to filter options by label (case-insensitive).
2. User taps a matching option from the overlay list.
3. The field shows the selected label and stores the option value.

## Dependent options

Fully supports `optionsSourceKey`, `options[].when`, and remote `optionsEndpoint` — same as dropdown.

## Flutter usage

Registered automatically by `FormEngineLocator.setup()`.

```dart
FormEngineWidget(
  schema: FormSchema.fromMap({...}),
  onSubmit: (values) => print(values['city']),
)
```

## Demo

Run the example app and open **Searchable dropdown** from the home screen.
