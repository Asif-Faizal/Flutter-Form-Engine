import 'package:flutter/material.dart';

import '../../di/form_engine_locator.dart';
import '../../media/media_constraints.dart';
import '../../models/media_file_value.dart';
import 'base_field_widget.dart';

/// Image capture / gallery pick field.
///
/// Value is a single [MediaFileValue] (or `List<MediaFileValue>` when
/// `allowMultiple` is true).
class ImageFieldWidget extends BaseFieldWidget {
  const ImageFieldWidget({
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

  Future<void> _capture(BuildContext context) async {
    final picker = FormEngineLocator.mediaPicker;
    final file = await picker.pickFromCamera(schema: schema);
    if (file == null) return;
    _applySelection(file);
  }

  Future<void> _fromGallery(BuildContext context) async {
    final picker = FormEngineLocator.mediaPicker;
    if (schema.allowMultiple) {
      final files = await picker.pickFiles(
        schema: schema,
        allowedExtensions: MediaConstraints.effectiveImageExtensions(schema),
        allowMultiple: true,
      );
      if (files.isEmpty) return;
      onChanged(files);
      onFocusLost();
      return;
    }

    final file = await picker.pickFromGallery(schema: schema);
    if (file == null) return;
    _applySelection(file);
  }

  void _applySelection(MediaFileValue file) {
    if (schema.allowMultiple) {
      final next = [..._files, file];
      final max = schema.maxFiles;
      onChanged(max != null && next.length > max ? next.take(max).toList() : next);
    } else {
      onChanged(file);
    }
    onFocusLost();
  }

  void _removeAt(int index) {
    final next = [..._files]..removeAt(index);
    onChanged(schema.allowMultiple ? next : (next.isEmpty ? null : next.first));
    onFocusLost();
  }

  void _clear() {
    onChanged(schema.allowMultiple ? <MediaFileValue>[] : null);
    onFocusLost();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final files = _files;
    final allowCamera = schema.allowCamera;
    final allowGallery = schema.allowGallery;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(schema.label, style: theme.textTheme.labelLarge),
        if (schema.hint != null) ...[
          const SizedBox(height: 4),
          Text(schema.hint!, style: theme.textTheme.bodySmall),
        ],
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            if (allowCamera)
              OutlinedButton.icon(
                onPressed: enabled ? () => _capture(context) : null,
                icon: const Icon(Icons.photo_camera_outlined),
                label: const Text('Camera'),
              ),
            if (allowGallery)
              OutlinedButton.icon(
                onPressed: enabled ? () => _fromGallery(context) : null,
                icon: const Icon(Icons.photo_library_outlined),
                label: const Text('Gallery'),
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
                Icons.image_outlined,
                color: FormEngineLocator.theme.primaryColor,
              ),
              title: Text(file.name, style: theme.textTheme.bodyMedium),
              subtitle: Text(
                [
                  '.${file.extension}',
                  if (file.sizeBytes != null) _formatBytes(file.sizeBytes!),
                  file.source.name,
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

  static String _formatBytes(int bytes) {
    if (bytes < 1024) return '$bytes B';
    if (bytes < 1024 * 1024) {
      return '${(bytes / 1024).toStringAsFixed(1)} KB';
    }
    return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
  }
}
