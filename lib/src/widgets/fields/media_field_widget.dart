import 'package:flutter/material.dart';

import '../../di/form_engine_locator.dart';
import '../../media/media_constraints.dart';
import '../../models/media_file_value.dart';
import 'base_field_widget.dart';

/// Media / document upload field with allowed-extension filtering.
///
/// Value is always a `List<MediaFileValue>` (empty when nothing selected).
class MediaFieldWidget extends BaseFieldWidget {
  const MediaFieldWidget({
    super.key,
    required super.schema,
    required super.value,
    required super.error,
    required super.enabled,
    required super.onChanged,
    required super.onFocusLost,
    required super.resolvedOptions,
  });

  List<MediaFileValue> get _files => MediaConstraints.asFileList(value);

  List<String> get _allowed =>
      MediaConstraints.allowedExtensionsFor(schema);

  Future<void> _pick() async {
    final picker = FormEngineLocator.mediaPicker;
    final picked = await picker.pickFiles(
      schema: schema,
      allowedExtensions: _allowed,
      allowMultiple: schema.allowMultiple || (schema.maxFiles ?? 1) > 1,
    );
    if (picked.isEmpty) return;

    final filtered = picked
        .where(
          (file) => MediaConstraints.isExtensionAllowed(
            file.extension,
            _allowed,
          ),
        )
        .toList();

    if (filtered.isEmpty) {
      onChanged(const <MediaFileValue>[]);
      onFocusLost();
      return;
    }

    final combined = schema.allowMultiple || (schema.maxFiles ?? 1) > 1
        ? [..._files, ...filtered]
        : filtered;

    final max = schema.maxFiles;
    final limited =
        max != null ? combined.take(max).toList() : combined.toList();

    onChanged(limited);
    onFocusLost();
  }

  void _removeAt(int index) {
    final next = [..._files]..removeAt(index);
    onChanged(next);
    onFocusLost();
  }

  void _clear() {
    onChanged(const <MediaFileValue>[]);
    onFocusLost();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final files = _files;
    final allowedLabel =
        _allowed.isEmpty ? 'any type' : _allowed.map((e) => '.$e').join(', ');

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(schema.label, style: theme.textTheme.labelLarge),
        const SizedBox(height: 4),
        Text(
          schema.hint ?? 'Allowed: $allowedLabel',
          style: theme.textTheme.bodySmall,
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            OutlinedButton.icon(
              onPressed: enabled ? _pick : null,
              icon: const Icon(Icons.attach_file),
              label: Text(files.isEmpty ? 'Add media' : 'Add more'),
            ),
            if (files.isNotEmpty)
              TextButton(
                onPressed: enabled ? _clear : null,
                child: const Text('Clear'),
              ),
          ],
        ),
        if (files.isNotEmpty) ...[
          const SizedBox(height: 8),
          ...List.generate(files.length, (index) {
            final file = files[index];
            return ListTile(
              contentPadding: EdgeInsets.zero,
              dense: true,
              leading: Icon(
                _iconFor(file.extension),
                color: FormEngineLocator.theme.primaryColor,
              ),
              title: Text(file.name, style: theme.textTheme.bodyMedium),
              subtitle: Text(
                [
                  '.${file.extension}',
                  if (file.sizeBytes != null) _formatBytes(file.sizeBytes!),
                ].join(' · '),
                style: theme.textTheme.bodySmall,
              ),
              trailing: enabled
                  ? IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () => _removeAt(index),
                    )
                  : null,
            );
          }),
        ],
        if (error != null)
          Padding(
            padding: const EdgeInsets.only(top: 4),
            child: Text(
              error!,
              style: theme.inputDecorationTheme.errorStyle,
            ),
          ),
      ],
    );
  }

  static IconData _iconFor(String extension) {
    switch (extension) {
      case 'pdf':
        return Icons.picture_as_pdf_outlined;
      case 'mp4':
      case 'mov':
      case 'avi':
      case 'mkv':
        return Icons.videocam_outlined;
      case 'mp3':
      case 'wav':
      case 'aac':
        return Icons.audiotrack_outlined;
      case 'jpg':
      case 'jpeg':
      case 'png':
      case 'gif':
      case 'webp':
        return Icons.image_outlined;
      default:
        return Icons.insert_drive_file_outlined;
    }
  }

  static String _formatBytes(int bytes) {
    if (bytes < 1024) return '$bytes B';
    if (bytes < 1024 * 1024) {
      return '${(bytes / 1024).toStringAsFixed(1)} KB';
    }
    return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
  }
}
