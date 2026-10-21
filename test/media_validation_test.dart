import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_form_engine/flutter_form_engine.dart';

void main() {
  const validator = BuiltInValidator();

  MediaFileValue file({
    required String name,
    required String extension,
    int? sizeBytes,
  }) {
    return MediaFileValue(
      name: name,
      path: '/tmp/$name',
      extension: extension,
      sizeBytes: sizeBytes,
    );
  }

  group('MediaFileValue.extensionOf', () {
    test('parses common paths', () {
      expect(MediaFileValue.extensionOf('photo.JPG'), 'jpg');
      expect(MediaFileValue.extensionOf('/a/b/c.Pdf'), 'pdf');
      expect(MediaFileValue.extensionOf('noext'), '');
    });
  });

  group('MediaConstraints', () {
    test('normalizes allowedExtensions from list and string', () {
      final fromList = FieldSchema.fromMap({
        'key': 'a',
        'type': 'media',
        'label': 'A',
        'allowedExtensions': ['.PDF', 'Docx'],
      });
      expect(
        MediaConstraints.allowedExtensionsFor(fromList),
        ['pdf', 'docx'],
      );

      final fromString = FieldSchema.fromMap({
        'key': 'b',
        'type': 'media',
        'label': 'B',
        'allowedExtensions': 'mp4, mov | avi',
      });
      expect(
        MediaConstraints.allowedExtensionsFor(fromString),
        ['mp4', 'mov', 'avi'],
      );
    });

    test('image fields default to common image extensions', () {
      final schema = FieldSchema.fromMap({
        'key': 'photo',
        'type': 'image',
        'label': 'Photo',
      });
      expect(
        MediaConstraints.effectiveImageExtensions(schema),
        MediaConstraints.defaultImageExtensions,
      );
    });

    test('isExtensionAllowed is case-insensitive', () {
      expect(
        MediaConstraints.isExtensionAllowed('PDF', ['pdf', 'docx']),
        isTrue,
      );
      expect(
        MediaConstraints.isExtensionAllowed('.docx', ['pdf', 'docx']),
        isTrue,
      );
      expect(
        MediaConstraints.isExtensionAllowed('exe', ['pdf']),
        isFalse,
      );
    });
  });

  group('image field validation', () {
    final schema = FieldSchema.fromMap({
      'key': 'photo',
      'type': 'image',
      'label': 'Photo',
      'required': true,
      'allowedExtensions': ['jpg', 'png'],
      'maxFileSize': 1000,
      'validations': [
        {'rule': 'required', 'message': 'Photo required'},
      ],
    });

    test('fails when missing', () {
      expect(validator.validate(schema, null, {}), 'Photo required');
    });

    test('passes allowed image', () {
      expect(
        validator.validate(
          schema,
          file(name: 'a.jpg', extension: 'jpg', sizeBytes: 500),
          {},
        ),
        isNull,
      );
    });

    test('rejects disallowed image extension', () {
      final error = validator.validate(
        schema,
        file(name: 'a.bmp', extension: 'bmp', sizeBytes: 100),
        {},
      );
      expect(error, contains('not allowed'));
    });

    test('rejects oversized image', () {
      final error = validator.validate(
        schema,
        file(name: 'a.jpg', extension: 'jpg', sizeBytes: 5000),
        {},
      );
      expect(error, contains('exceeds max size'));
    });
  });

  group('media field validation', () {
    final schema = FieldSchema.fromMap({
      'key': 'resume',
      'type': 'media',
      'label': 'Resume',
      'required': true,
      'allowedExtensions': ['pdf', 'docx'],
      'maxFiles': 2,
      'maxFileSize': 10000,
      'validations': [
        {'rule': 'required', 'message': 'Resume required'},
        {
          'rule': 'allowedExtensions',
          'value': ['pdf', 'docx'],
          'message': 'Only PDF/DOCX',
        },
        {
          'rule': 'maxFileSize',
          'value': 10000,
          'message': 'Too large',
        },
        {
          'rule': 'maxFiles',
          'value': 2,
          'message': 'Too many files',
        },
      ],
    });

    test('fails when empty list', () {
      expect(validator.validate(schema, <MediaFileValue>[], {}), 'Resume required');
    });

    test('passes valid pdf', () {
      expect(
        validator.validate(
          schema,
          [file(name: 'cv.pdf', extension: 'pdf', sizeBytes: 100)],
          {},
        ),
        isNull,
      );
    });

    test('rejects txt via allowedExtensions rule', () {
      expect(
        validator.validate(
          schema,
          [file(name: 'notes.txt', extension: 'txt', sizeBytes: 10)],
          {},
        ),
        'Only PDF/DOCX',
      );
    });

    test('rejects oversized file via maxFileSize rule', () {
      expect(
        validator.validate(
          schema,
          [file(name: 'cv.pdf', extension: 'pdf', sizeBytes: 50000)],
          {},
        ),
        'Too large',
      );
    });

    test('rejects too many files via maxFiles rule', () {
      expect(
        validator.validate(
          schema,
          [
            file(name: 'a.pdf', extension: 'pdf', sizeBytes: 10),
            file(name: 'b.pdf', extension: 'pdf', sizeBytes: 10),
            file(name: 'c.pdf', extension: 'pdf', sizeBytes: 10),
          ],
          {},
        ),
        'Too many files',
      );
    });
  });
}
