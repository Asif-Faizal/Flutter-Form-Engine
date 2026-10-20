import '../models/field_schema.dart';
import '../models/media_file_value.dart';

/// Shared helpers for image/media extension and size checks.
abstract final class MediaConstraints {
  static const defaultImageExtensions = [
    'jpg',
    'jpeg',
    'png',
    'gif',
    'webp',
    'heic',
  ];

  static String normalizeExtension(String raw) {
    return raw.trim().toLowerCase().replaceFirst(RegExp(r'^\.'), '');
  }

  /// Extensions allowed for [schema], normalized (lowercase, no dot).
  static List<String> allowedExtensionsFor(FieldSchema schema) {
    if (schema.allowedExtensions.isNotEmpty) {
      return schema.allowedExtensions
          .map(normalizeExtension)
          .where((e) => e.isNotEmpty)
          .toList();
    }

    final fromExtra = schema.extra['allowedExtensions'];
    if (fromExtra is List) {
      return fromExtra
          .map((e) => normalizeExtension(e.toString()))
          .where((e) => e.isNotEmpty)
          .toList();
    }
    if (fromExtra is String && fromExtra.trim().isNotEmpty) {
      return fromExtra
          .split(RegExp(r'[,|\s]+'))
          .map(normalizeExtension)
          .where((e) => e.isNotEmpty)
          .toList();
    }

    return const [];
  }

  /// Effective allow-list for image fields (defaults to common image types).
  static List<String> effectiveImageExtensions(FieldSchema schema) {
    final configured = allowedExtensionsFor(schema);
    return configured.isEmpty ? defaultImageExtensions : configured;
  }

  static bool isExtensionAllowed(String extension, List<String> allowed) {
    if (allowed.isEmpty) return true;
    return allowed.contains(normalizeExtension(extension));
  }

  static List<MediaFileValue> asFileList(dynamic value) {
    if (value == null) return const [];
    if (value is MediaFileValue) return [value];
    if (value is List) {
      return value.whereType<MediaFileValue>().toList();
    }
    if (value is Map<String, dynamic>) {
      return [MediaFileValue.fromMap(value)];
    }
    return const [];
  }

  static String? validateFiles({
    required FieldSchema schema,
    required dynamic value,
    required List<String> allowedExtensions,
    String? requiredMessage,
    String? extensionMessage,
    String? maxFileSizeMessage,
    String? maxFilesMessage,
  }) {
    final files = asFileList(value);

    if (schema.required && files.isEmpty) {
      return requiredMessage ?? 'File is required';
    }
    if (files.isEmpty) return null;

    final maxFiles = schema.maxFiles;
    if (maxFiles != null && files.length > maxFiles) {
      return maxFilesMessage ?? 'Select at most $maxFiles file(s)';
    }

    for (final file in files) {
      if (!isExtensionAllowed(file.extension, allowedExtensions)) {
        return extensionMessage ??
            'File type ".${file.extension}" is not allowed. '
                'Allowed: ${allowedExtensions.join(', ')}';
      }

      final maxSize = schema.maxFileSize;
      if (maxSize != null &&
          file.sizeBytes != null &&
          file.sizeBytes! > maxSize) {
        return maxFileSizeMessage ??
            'File "${file.name}" exceeds max size of $maxSize bytes';
      }
    }

    return null;
  }
}
