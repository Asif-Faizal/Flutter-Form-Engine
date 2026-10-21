# Media field (`type: "media"`)

Attach documents or other media files with **allowed extension** filtering.

## When to use

Use `media` when users upload PDFs, Office docs, video clips, or a restricted set of file types. For camera/gallery image capture, use [`image`](image.md).

## JSON schema

| Property | Type | Required | Description |
|----------|------|----------|-------------|
| `key` | string | yes | Unique field identifier |
| `type` | `"media"` | yes | Field type |
| `label` | string | yes | Field label |
| `hint` | string | no | Helper text (defaults to listing allowed extensions) |
| `allowedExtensions` | string[] \| string | **recommended** | e.g. `["pdf","docx"]` or `"pdf,docx"` |
| `maxFileSize` | number | no | Max bytes per file |
| `maxFiles` | number | no | Max number of files |
| `allowMultiple` | boolean | no | Allow selecting more than one. Default `false` |
| `required` | boolean | no | At least one file required |
| `validations` | array | no | `required`, `allowedExtensions`, `maxFileSize`, `maxFiles` |
| `dependsOn` | object | no | Conditional rules |

> If `allowedExtensions` is empty, any extension is accepted (picker still works; size/count rules still apply).

## Example — PDF / DOCX only

```json
{
  "key": "resume",
  "type": "media",
  "label": "Upload resume",
  "allowedExtensions": ["pdf", "docx"],
  "maxFileSize": 10485760,
  "maxFiles": 1,
  "validations": [
    { "rule": "required", "message": "Resume is required" },
    {
      "rule": "allowedExtensions",
      "value": ["pdf", "docx"],
      "message": "Only PDF or DOCX allowed"
    },
    {
      "rule": "maxFileSize",
      "value": 10485760,
      "message": "File must be under 10 MB"
    }
  ]
}
```

## Example — multiple videos with extension allow-list

```json
{
  "key": "clips",
  "type": "media",
  "label": "Video clips",
  "allowedExtensions": "mp4,mov",
  "allowMultiple": true,
  "maxFiles": 3,
  "maxFileSize": 52428800,
  "validations": [
    { "rule": "maxFiles", "value": 3, "message": "Max 3 clips" }
  ]
}
```

## Submitted value

Always a `List<MediaFileValue>` (empty list when nothing selected):

```dart
onSubmit: (values) {
  final files = values['resume'] as List<MediaFileValue>;
  for (final file in files) {
    print('${file.name} (${file.extension}) -> ${file.path}');
  }
}
```

## How extension filtering works

1. **Picker filter** — `MediaPicker.pickFiles` receives `allowedExtensions` so the platform UI can pre-filter.
2. **Client-side re-check** — `MediaFieldWidget` drops files whose extension is not allowed.
3. **Validator** — `BuiltInValidator` enforces schema `allowedExtensions` / rules on submit and blur.

Extensions are compared case-insensitively without a leading dot (`PDF` ≡ `pdf` ≡ `.pdf`).

## MediaPicker setup

```dart
FormEngineLocator.setup(
  mediaPicker: MyFilePicker(), // implements MediaPicker.pickFiles
);
```

## Demo

Run the example app and open **Media** from the home screen. Try selecting a blocked type to see validation.

## Tests

```bash
./tool/run_media_tests.sh
# or
flutter test test/media_validation_test.dart test/media_field_test.dart
```
