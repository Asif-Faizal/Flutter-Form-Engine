# Image field (`type: "image"`)

Capture a photo with the camera or pick from the gallery.

## When to use

Use `image` for profile photos, ID scans, receipts, or any single-image capture/upload. For documents / mixed file types with extension filters, use [`media`](media.md).

## JSON schema

| Property | Type | Required | Description |
|----------|------|----------|-------------|
| `key` | string | yes | Unique field identifier |
| `type` | `"image"` | yes | Field type |
| `label` | string | yes | Field label |
| `hint` | string | no | Helper text |
| `allowCamera` | boolean | no | Show camera button. Default `true` |
| `allowGallery` | boolean | no | Show gallery button. Default `true` |
| `allowMultiple` | boolean | no | Allow multiple images. Default `false` |
| `allowedExtensions` | string[] \| string | no | Override image types. Default `jpg,jpeg,png,gif,webp,heic` |
| `maxFileSize` | number | no | Max bytes per file |
| `maxFiles` | number | no | Max count when `allowMultiple` |
| `required` | boolean | no | Field must have a value |
| `validations` | array | no | `required`, `allowedExtensions`, `maxFileSize`, `maxFiles` |
| `dependsOn` | object | no | Conditional rules |

## Example — profile photo (camera + gallery)

```json
{
  "key": "profile_photo",
  "type": "image",
  "label": "Profile photo",
  "hint": "Take a photo or choose from gallery",
  "allowCamera": true,
  "allowGallery": true,
  "allowedExtensions": ["jpg", "jpeg", "png"],
  "maxFileSize": 5242880,
  "validations": [
    { "rule": "required", "message": "Photo is required" }
  ]
}
```

## Example — gallery only, multiple images

```json
{
  "key": "property_photos",
  "type": "image",
  "label": "Property photos",
  "allowCamera": false,
  "allowGallery": true,
  "allowMultiple": true,
  "maxFiles": 5,
  "validations": [
    { "rule": "maxFiles", "value": 5, "message": "Max 5 photos" }
  ]
}
```

## Submitted value

- Single: `MediaFileValue` (`name`, `path`, `extension`, `mimeType?`, `sizeBytes?`, `source`)
- Multiple: `List<MediaFileValue>`

```dart
onSubmit: (values) {
  final photo = values['profile_photo'] as MediaFileValue;
  print(photo.path); // upload this path/URI to your backend
}
```

## MediaPicker setup

The package ships a `StubMediaPicker` (no-op) by default. Register a real or demo picker:

```dart
FormEngineLocator.setup(
  theme: FormEngineTheme.carbon(),
  mediaPicker: MyImagePicker(), // implements MediaPicker
);
```

`MediaPicker` methods used by this field:

- `pickFromCamera`
- `pickFromGallery`
- `pickFiles` (when `allowMultiple` is true)

## Validation

Schema-level `allowedExtensions`, `maxFileSize`, and `maxFiles` are enforced automatically for `image` fields. You can also declare explicit rules:

| Rule | Description |
|------|-------------|
| `required` | Image must be selected |
| `allowedExtensions` | Extension must be in `value` list |
| `maxFileSize` | Each file size ≤ `value` bytes |
| `maxFiles` | Count ≤ `value` |

## Demo

Run the example app and open **Image** from the home screen (uses a simulated camera/gallery picker).
