import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_form_engine/flutter_form_engine.dart';

void main() {
  const resolver = DependentOptionsResolver();

  FieldSchema field({
    String? optionsSourceKey,
    List<Map<String, dynamic>> options = const [],
    Map<String, dynamic> extra = const {},
  }) {
    return FieldSchema.fromMap({
      'key': 'child',
      'type': 'dropdown',
      'label': 'Child',
      if (optionsSourceKey != null) 'optionsSourceKey': optionsSourceKey,
      'options': options,
      if (extra.isNotEmpty) 'extra': extra,
    });
  }

  test('returns all options when no optionsSourceKey is set', () {
    final child = field(
      options: [
        {'label': 'A', 'value': 'a'},
        {'label': 'B', 'value': 'b'},
      ],
    );

    final options = resolver.resolve(field: child, values: {});
    expect(options, hasLength(2));
  });

  test('filters options by when matching source value', () {
    final child = field(
      optionsSourceKey: 'country',
      options: [
        {'label': 'IT Services', 'value': 'it', 'when': 'IN'},
        {'label': 'Software', 'value': 'sw', 'when': 'US'},
      ],
    );

    final indiaOptions = resolver.resolve(
      field: child,
      values: {'country': 'IN'},
    );
    expect(indiaOptions, hasLength(1));
    expect(indiaOptions.first.value, 'it');

    final usOptions = resolver.resolve(
      field: child,
      values: {'country': 'US'},
    );
    expect(usOptions, hasLength(1));
    expect(usOptions.first.value, 'sw');
  });

  test('returns empty list when source value is missing', () {
    final child = field(
      optionsSourceKey: 'country',
      options: [
        {'label': 'IT Services', 'value': 'it', 'when': 'IN'},
      ],
    );

    expect(
      resolver.resolve(field: child, values: {}),
      isEmpty,
    );
  });

  test('supports optionsBySource map in extra', () {
    final child = field(
      optionsSourceKey: 'country',
      extra: {
        'optionsBySource': {
          'IN': [
            {'label': 'Maharashtra', 'value': 'MH'},
          ],
          'US': [
            {'label': 'California', 'value': 'CA'},
          ],
        },
      },
    );

    final indiaOptions = resolver.resolve(
      field: child,
      values: {'country': 'IN'},
    );
    expect(indiaOptions.single.label, 'Maharashtra');
  });

  test('clearStaleDependentValues removes invalid child selection', () {
    final schema = FormSchema.fromMap({
      'id': 'test',
      'title': 'Test',
      'fields': [
        {
          'key': 'country',
          'type': 'dropdown',
          'label': 'Country',
          'options': [],
        },
        {
          'key': 'category',
          'type': 'dropdown',
          'label': 'Category',
          'optionsSourceKey': 'country',
          'options': [
            {'label': 'IT', 'value': 'it', 'when': 'IN'},
            {'label': 'Software', 'value': 'sw', 'when': 'US'},
          ],
        },
      ],
    });

    final cleared = resolver.clearStaleDependentValues(
      schema,
      {'country': 'IN', 'category': 'it'},
      'country',
    );

    expect(cleared['category'], 'it');

    final clearedAfterChange = resolver.clearStaleDependentValues(
      schema,
      {'country': 'US', 'category': 'it'},
      'country',
    );

    expect(clearedAfterChange.containsKey('category'), isFalse);
  });
}
