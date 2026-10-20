import 'package:flutter/material.dart';
import 'package:flutter_form_engine/flutter_form_engine.dart';

/// Example-app [MediaPicker] that simulates camera / gallery / file picks
/// without platform plugins — useful for demos and widget tests.
class DemoMediaPicker implements MediaPicker {
  DemoMediaPicker(this._navigatorKey);

  final GlobalKey<NavigatorState> _navigatorKey;

  BuildContext? get _context => _navigatorKey.currentContext;

  @override
  Future<MediaFileValue?> pickFromCamera({required FieldSchema schema}) {
    return _pickSingle(
      title: 'Simulate camera capture',
      options: const [
        MediaFileValue(
          name: 'camera_photo.jpg',
          path: '/demo/camera_photo.jpg',
          extension: 'jpg',
          mimeType: 'image/jpeg',
          sizeBytes: 245_000,
          source: MediaSource.camera,
        ),
        MediaFileValue(
          name: 'camera_photo.png',
          path: '/demo/camera_photo.png',
          extension: 'png',
          mimeType: 'image/png',
          sizeBytes: 512_000,
          source: MediaSource.camera,
        ),
      ],
      allowed: MediaConstraints.effectiveImageExtensions(schema),
    );
  }

  @override
  Future<MediaFileValue?> pickFromGallery({required FieldSchema schema}) {
    return _pickSingle(
      title: 'Simulate gallery pick',
      options: const [
        MediaFileValue(
          name: 'gallery_1.jpg',
          path: '/demo/gallery_1.jpg',
          extension: 'jpg',
          mimeType: 'image/jpeg',
          sizeBytes: 180_000,
          source: MediaSource.gallery,
        ),
        MediaFileValue(
          name: 'gallery_2.webp',
          path: '/demo/gallery_2.webp',
          extension: 'webp',
          mimeType: 'image/webp',
          sizeBytes: 95_000,
          source: MediaSource.gallery,
        ),
        MediaFileValue(
          name: 'not_allowed.bmp',
          path: '/demo/not_allowed.bmp',
          extension: 'bmp',
          mimeType: 'image/bmp',
          sizeBytes: 40_000,
          source: MediaSource.gallery,
        ),
      ],
      allowed: MediaConstraints.effectiveImageExtensions(schema),
    );
  }

  @override
  Future<List<MediaFileValue>> pickFiles({
    required FieldSchema schema,
    required List<String> allowedExtensions,
    bool allowMultiple = false,
  }) async {
    final context = _context;
    if (context == null) return const [];

    final samples = <MediaFileValue>[
      const MediaFileValue(
        name: 'resume.pdf',
        path: '/demo/resume.pdf',
        extension: 'pdf',
        mimeType: 'application/pdf',
        sizeBytes: 320_000,
      ),
      const MediaFileValue(
        name: 'report.docx',
        path: '/demo/report.docx',
        extension: 'docx',
        mimeType:
            'application/vnd.openxmlformats-officedocument.wordprocessingml.document',
        sizeBytes: 110_000,
      ),
      const MediaFileValue(
        name: 'clip.mp4',
        path: '/demo/clip.mp4',
        extension: 'mp4',
        mimeType: 'video/mp4',
        sizeBytes: 2_400_000,
      ),
      const MediaFileValue(
        name: 'notes.txt',
        path: '/demo/notes.txt',
        extension: 'txt',
        mimeType: 'text/plain',
        sizeBytes: 4_000,
      ),
      const MediaFileValue(
        name: 'photo.jpg',
        path: '/demo/photo.jpg',
        extension: 'jpg',
        mimeType: 'image/jpeg',
        sizeBytes: 220_000,
      ),
      const MediaFileValue(
        name: 'huge_video.mkv',
        path: '/demo/huge_video.mkv',
        extension: 'mkv',
        mimeType: 'video/x-matroska',
        sizeBytes: 50_000_000,
      ),
    ];

    final filtered = allowedExtensions.isEmpty
        ? samples
        : samples
            .where(
              (f) => MediaConstraints.isExtensionAllowed(
                f.extension,
                allowedExtensions,
              ),
            )
            .toList();

    final selected = await showModalBottomSheet<List<MediaFileValue>>(
      context: context,
      builder: (ctx) {
        final chosen = <MediaFileValue>{};
        return StatefulBuilder(
          builder: (ctx, setState) {
            return SafeArea(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ListTile(
                    title: Text(
                      allowMultiple
                          ? 'Select media (multi)'
                          : 'Select media (single)',
                    ),
                    subtitle: Text(
                      allowedExtensions.isEmpty
                          ? 'Any extension'
                          : 'Allowed: ${allowedExtensions.map((e) => '.$e').join(', ')}',
                    ),
                  ),
                  if (filtered.isEmpty)
                    const Padding(
                      padding: EdgeInsets.all(16),
                      child: Text('No sample files match allowed extensions.'),
                    ),
                  ...filtered.map(
                    (file) => CheckboxListTile(
                      value: chosen.contains(file),
                      title: Text(file.name),
                      subtitle: Text(
                        '.${file.extension} · ${_formatBytes(file.sizeBytes ?? 0)}',
                      ),
                      onChanged: (checked) {
                        setState(() {
                          if (checked == true) {
                            if (!allowMultiple) chosen.clear();
                            chosen.add(file);
                          } else {
                            chosen.remove(file);
                          }
                        });
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(12),
                    child: FilledButton(
                      onPressed: () =>
                          Navigator.pop(ctx, chosen.toList(growable: false)),
                      child: const Text('Add selected'),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );

    return selected ?? const [];
  }

  Future<MediaFileValue?> _pickSingle({
    required String title,
    required List<MediaFileValue> options,
    required List<String> allowed,
  }) async {
    final context = _context;
    if (context == null) return null;

    final visible = options
        .where((f) => MediaConstraints.isExtensionAllowed(f.extension, allowed))
        .toList();

    return showModalBottomSheet<MediaFileValue>(
      context: context,
      builder: (ctx) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(title: Text(title)),
              if (visible.isEmpty)
                const Padding(
                  padding: EdgeInsets.all(16),
                  child: Text('No sample images match allowed extensions.'),
                ),
              ...visible.map(
                (file) => ListTile(
                  leading: const Icon(Icons.image_outlined),
                  title: Text(file.name),
                  subtitle: Text(
                    '.${file.extension} · ${_formatBytes(file.sizeBytes ?? 0)}',
                  ),
                  onTap: () => Navigator.pop(ctx, file),
                ),
              ),
              // Intentionally include one blocked option so demos can show
              // validation rejecting disallowed extensions when chosen via
              // programmatic injection in tests.
              if (options.any(
                (f) => !MediaConstraints.isExtensionAllowed(f.extension, allowed),
              ))
                ListTile(
                  leading: const Icon(Icons.block),
                  title: const Text('Pick blocked type (for validation demo)'),
                  subtitle: Text(
                    options
                        .firstWhere(
                          (f) => !MediaConstraints.isExtensionAllowed(
                            f.extension,
                            allowed,
                          ),
                        )
                        .name,
                  ),
                  onTap: () => Navigator.pop(
                    ctx,
                    options.firstWhere(
                      (f) => !MediaConstraints.isExtensionAllowed(
                        f.extension,
                        allowed,
                      ),
                    ),
                  ),
                ),
            ],
          ),
        );
      },
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
