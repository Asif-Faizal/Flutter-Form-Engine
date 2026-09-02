# Time field (`type: "time"`)

Time input that opens the platform time picker.

## When to use

Use `time` for appointment times, reminders, or any time-of-day selection (without a calendar date).

## JSON schema

| Property | Type | Required | Description |
|----------|------|----------|-------------|
| `key` | string | yes | Unique field identifier |
| `type` | `"time"` | yes | Field type |
| `label` | string | yes | Field label |
| `hint` | string | no | Placeholder when empty |
| `use24Hour` | boolean | no | 24-hour format. Default `false` |
| `initialValue` | string (ISO) | no | Pre-selected time |
| `validations` | array | no | e.g. `required` |
| `dependsOn` | object | no | Conditional rules |

## Example

```json
{
  "key": "appointment_time",
  "type": "time",
  "label": "Preferred time",
  "use24Hour": true,
  "validations": [
    { "rule": "required", "message": "Select a time" }
  ]
}
```

## Submitted value

`DateTime` anchored to `1970-01-01` with the selected hour and minute. Extract time:

```dart
onSubmit: (values) {
  final time = values['appointment_time'] as DateTime;
  final formatted =
      '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
}
```

## Display format

| `use24Hour` | Display |
|-------------|---------|
| `true` | `14:30` |
| `false` | `2:30 PM` |

Uses the `intl` package (same as the date field).

## Flutter usage

Tap the field to open the native time picker. Registered automatically by `FormEngineLocator.setup()`.

## Demo

Run the example app and open **Time** from the home screen.
