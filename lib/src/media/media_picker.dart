import '../models/field_schema.dart';
import '../models/media_file_value.dart';

/// Abstraction over camera / gallery / file pickers.
///
/// Inject a fake in tests via [FormEngineLocator.setup].
abstract class MediaPicker {
  /// Capture from the device camera (images only).
  Future<MediaFileValue?> pickFromCamera({
    required FieldSchema schema,
  });

  /// Pick an image from the gallery.
  Future<MediaFileValue?> pickFromGallery({
    required FieldSchema schema,
  });

  /// Pick one or more media/document files, filtered by allowed extensions.
  Future<List<MediaFileValue>> pickFiles({
    required FieldSchema schema,
    required List<String> allowedExtensions,
    bool allowMultiple = false,
  });
}

/// Default picker used when no platform integration is registered.
///
/// Returns `null` / empty lists so unit tests and headless runs stay safe.
/// Host apps should register a real implementation (e.g. image_picker /
/// file_picker wrappers) via [FormEngineLocator.setup].
class StubMediaPicker implements MediaPicker {
  const StubMediaPicker();

  @override
  Future<MediaFileValue?> pickFromCamera({required FieldSchema schema}) async {
    return null;
  }

  @override
  Future<MediaFileValue?> pickFromGallery({required FieldSchema schema}) async {
    return null;
  }

  @override
  Future<List<MediaFileValue>> pickFiles({
    required FieldSchema schema,
    required List<String> allowedExtensions,
    bool allowMultiple = false,
  }) async {
    return const [];
  }
}
