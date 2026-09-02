# Date field (`type: "date"`)

Date input that opens the platform date picker. The stored value is a `DateTime` at local midnight.

## When to use

Use `date` for birth dates, deadlines, appointment dates, or any calendar-day selection.

## JSON schema

| Property | Type | Required | Description |
|----------|------|----------|-------------|
| `key` | string | yes | Unique field identifier |
| `type` | `"date"` | yes | Field type |
| `label` | string | yes | Field label |
| `hint` | string | no | Placeholder when empty |
| `dateFormat` | string | no | Display format (intl pattern). Default `yyyy-MM-dd` |
| `minDate` | string (ISO) | no | Earliest selectable date |
| `maxDate` | string (ISO) | no | Latest selectable date |
| `initialValue` | string (ISO) | no | Pre-selected date |
| `validations` | array | no | `required`, `minAge`, etc. |
| `dependsOn` | object | no | Conditional rules |

## Example — date of birth

```json
{
  "key": "dob",
  "type": "date",
  "label": "Date of birth",
  "dateFormat": "dd/MM/yyyy",
  "maxDate": "2010-01-01",
  "validations": [
    { "rule": "required", "message": "Date of birth is required" },
    { "rule": "minAge", "value": 18, "message": "Must be 18 or older" }
  ]
}
```

## Example — appointment date

```json
{
  "key": "appointment",
  "type": "date",
  "label": "Appointment date",
  "minDate": "2026-01-01",
  "maxDate": "2026-12-31",
  "validations": [
    { "rule": "required", "message": "Pick a date" }
  ]
}
```

## Submitted value

`DateTime` object (local date at midnight). Serialize for APIs:

```dart
onSubmit: (values) {
  final dob = values['dob'] as DateTime;
  final iso = dob.toIso8601String().split('T').first;
}
```

## Validation rules

| Rule | Description |
|------|-------------|
| `required` | Date must be selected |
| `minAge` | `DateTime` must represent age ≥ `value` years |

## Dependencies

The date field uses the [`intl`](https://pub.dev/packages/intl) package for display formatting (included in `pubspec.yaml`).

## Flutter usage

Tap the field to open the native date picker. Registered automatically by `FormEngineLocator.setup()`.

## Demo

Run the example app and open **Date** from the home screen.
