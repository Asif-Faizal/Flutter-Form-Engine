import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_form_engine/flutter_form_engine.dart';

class _FakeMediaPicker implements MediaPicker {
  _FakeMediaPicker({
    this.cameraFile,
    this.galleryFile,
    this.files = const [],
  });

  MediaFileValue? cameraFile;
  MediaFileValue? galleryFile;
  List<MediaFileValue> files;

  int cameraCalls = 0;
  int galleryCalls = 0;
  int filesCalls = 0;
  List<String>? lastAllowedExtensions;

  @override
  Future<MediaFileValue?> pickFromCamera({required FieldSchema schema}) async {
    cameraCalls++;
    return cameraFile;
  }

  @override
  Future<MediaFileValue?> pickFromGallery({required FieldSchema schema}) async {
    galleryCalls++;
    return galleryFile;
  }

  @override
  Future<List<MediaFileValue>> pickFiles({
    required FieldSchema schema,
    required List<String> allowedExtensions,
    bool allowMultiple = false,
  }) async {
    filesCalls++;
    lastAllowedExtensions = allowedExtensions;
    return files;
  }
}

void main() {
  tearDown(() {
    // Isolate locator state between tests.
    FormEngineLocator.setup(reset: true);
  });

  testWidgets('image field captures from camera via MediaPicker', (tester) async {
    final fake = _FakeMediaPicker(
      cameraFile: const MediaFileValue(
        name: 'shot.jpg',
        path: '/tmp/shot.jpg',
        extension: 'jpg',
        sizeBytes: 1200,
        source: MediaSource.camera,
      ),
    );

    FormEngineLocator.setup(
      theme: FormEngineTheme.carbon(),
      mediaPicker: fake,
      reset: true,
    );

    final schema = FormSchema.fromMap({
      'id': 'img',
      'title': 'Img',
      'fields': [
        {
          'key': 'photo',
          'type': 'image',
          'label': 'Photo',
          'allowCamera': true,
          'allowGallery': true,
          'allowedExtensions': ['jpg', 'png'],
        },
      ],
    });

    Map<String, dynamic>? submitted;

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: FormEngineWidget(
            schema: schema,
            onSubmit: (values) => submitted = values,
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.text('Camera'));
    await tester.pumpAndSettle();

    expect(fake.cameraCalls, 1);
    expect(find.text('shot.jpg'), findsOneWidget);

    await tester.tap(find.text('Submit'));
    await tester.pumpAndSettle();

    expect(submitted, isNotNull);
    expect(submitted!['photo'], isA<MediaFileValue>());
    expect((submitted!['photo'] as MediaFileValue).extension, 'jpg');
  });

  testWidgets('media field passes allowedExtensions to picker and stores files',
      (tester) async {
    final fake = _FakeMediaPicker(
      files: const [
        MediaFileValue(
          name: 'resume.pdf',
          path: '/tmp/resume.pdf',
          extension: 'pdf',
          sizeBytes: 500,
        ),
      ],
    );

    FormEngineLocator.setup(
      theme: FormEngineTheme.carbon(),
      mediaPicker: fake,
      reset: true,
    );

    final schema = FormSchema.fromMap({
      'id': 'docs',
      'title': 'Docs',
      'fields': [
        {
          'key': 'resume',
          'type': 'media',
          'label': 'Resume',
          'allowedExtensions': ['pdf', 'docx'],
          'maxFiles': 1,
          'validations': [
            {'rule': 'required', 'message': 'Required'},
          ],
        },
      ],
    });

    Map<String, dynamic>? submitted;

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: FormEngineWidget(
            schema: schema,
            onSubmit: (values) => submitted = values,
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.text('Add media'));
    await tester.pumpAndSettle();

    expect(fake.filesCalls, 1);
    expect(fake.lastAllowedExtensions, ['pdf', 'docx']);
    expect(find.text('resume.pdf'), findsOneWidget);

    await tester.tap(find.text('Submit'));
    await tester.pumpAndSettle();

    final files = submitted!['resume'] as List<MediaFileValue>;
    expect(files, hasLength(1));
    expect(files.first.extension, 'pdf');
  });

  testWidgets('media field drops files outside allowedExtensions', (tester) async {
    final fake = _FakeMediaPicker(
      files: const [
        MediaFileValue(
          name: 'virus.exe',
          path: '/tmp/virus.exe',
          extension: 'exe',
          sizeBytes: 10,
        ),
        MediaFileValue(
          name: 'ok.pdf',
          path: '/tmp/ok.pdf',
          extension: 'pdf',
          sizeBytes: 10,
        ),
      ],
    );

    FormEngineLocator.setup(
      theme: FormEngineTheme.carbon(),
      mediaPicker: fake,
      reset: true,
    );

    final schema = FormSchema.fromMap({
      'id': 'docs',
      'title': 'Docs',
      'fields': [
        {
          'key': 'docs',
          'type': 'media',
          'label': 'Docs',
          'allowedExtensions': ['pdf'],
          'allowMultiple': true,
          'maxFiles': 5,
        },
      ],
    });

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: FormEngineWidget(
            schema: schema,
            onSubmit: (_) {},
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.text('Add media'));
    await tester.pumpAndSettle();

    expect(find.text('ok.pdf'), findsOneWidget);
    expect(find.text('virus.exe'), findsNothing);
  });

  test('schema parses media properties', () {
    final field = FieldSchema.fromMap({
      'key': 'm',
      'type': 'media',
      'label': 'M',
      'allowedExtensions': 'pdf,docx',
      'maxFileSize': 123,
      'maxFiles': 2,
      'allowMultiple': true,
      'allowCamera': false,
      'allowGallery': true,
    });

    expect(field.type, FieldType.media);
    expect(field.allowedExtensions, ['pdf', 'docx']);
    expect(field.maxFileSize, 123);
    expect(field.maxFiles, 2);
    expect(field.allowMultiple, isTrue);
    expect(field.allowCamera, isFalse);
  });

  test('FieldType.fromString supports image and media', () {
    expect(FieldType.fromString('image'), FieldType.image);
    expect(FieldType.fromString('media'), FieldType.media);
  });
}
