import 'package:equatable/equatable.dart';

/// How a media file was obtained.
enum MediaSource { camera, gallery, files }

/// Value stored by [FieldType.image] and [FieldType.media] fields.
class MediaFileValue extends Equatable {
  const MediaFileValue({
    required this.name,
    required this.path,
    required this.extension,
    this.mimeType,
    this.sizeBytes,
    this.source = MediaSource.files,
  });

  /// Display / original file name (e.g. `photo.jpg`).
  final String name;

  /// Local path or URI string for the selected file.
  final String path;

  /// Lowercase extension without dot (e.g. `jpg`, `pdf`).
  final String extension;

  final String? mimeType;
  final int? sizeBytes;
  final MediaSource source;

  factory MediaFileValue.fromMap(Map<String, dynamic> map) {
    return MediaFileValue(
      name: map['name'] as String,
      path: map['path'] as String,
      extension: _normalizeExtension(map['extension'] as String? ?? ''),
      mimeType: map['mimeType'] as String?,
      sizeBytes: map['sizeBytes'] as int?,
      source: MediaSource.values.firstWhere(
        (s) => s.name == map['source'],
        orElse: () => MediaSource.files,
      ),
    );
  }

  Map<String, dynamic> toMap() => {
        'name': name,
        'path': path,
        'extension': extension,
        if (mimeType != null) 'mimeType': mimeType,
        if (sizeBytes != null) 'sizeBytes': sizeBytes,
        'source': source.name,
      };

  /// Extracts a normalized extension from a file name or path.
  static String extensionOf(String fileNameOrPath) {
    final name = fileNameOrPath.split(RegExp(r'[\\/]')).last;
    final dot = name.lastIndexOf('.');
    if (dot < 0 || dot == name.length - 1) return '';
    return _normalizeExtension(name.substring(dot + 1));
  }

  static String _normalizeExtension(String raw) {
    return raw.trim().toLowerCase().replaceFirst(RegExp(r'^\.'), '');
  }

  @override
  List<Object?> get props => [name, path, extension, mimeType, sizeBytes, source];
}
