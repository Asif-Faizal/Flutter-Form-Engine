import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_form_engine/flutter_form_engine.dart';

void main() {
  const engine = ConditionalEngine();

  FormSchema schema(List<Map<String, dynamic>> fields) {
    return FormSchema.fromMap({
      'id': 'test',
      'title': 'Test',
      'fields': fields,
    });
  }

  test('field with no dependsOn is always visible', () {
    final formSchema = schema([
      {'key': 'name', 'type': 'text', 'label': 'Name'},
    ]);
    final visibility = engine.computeVisibility(formSchema, {});
    expect(visibility['name'], isTrue);
  });

  test('field is hidden when condition is not met', () {
    final formSchema = schema([
      {
        'key': 'country',
        'type': 'dropdown',
        'label': 'Country',
        'options': [],
      },
      {
        'key': 'state',
        'type': 'dropdown',
        'label': 'State',
        'options': [],
        'dependsOn': {
          'field': 'country',
          'condition': 'notEmpty',
          'action': 'show',
        },
      },
    ]);

    final visibility = engine.computeVisibility(formSchema, {});
    expect(visibility['state'], isFalse);
  });

  test('field is visible when condition is met', () {
    final formSchema = schema([
      {
        'key': 'country',
        'type': 'dropdown',
        'label': 'Country',
        'options': [],
      },
      {
        'key': 'state',
        'type': 'dropdown',
        'label': 'State',
        'options': [],
        'dependsOn': {
          'field': 'country',
          'condition': 'notEmpty',
          'action': 'show',
        },
      },
    ]);

    final visibility = engine.computeVisibility(formSchema, {'country': 'IN'});
    expect(visibility['state'], isTrue);
  });

  test('fieldsToClear returns keys when clearOnHide is true', () {
    final formSchema = schema([
      {
        'key': 'country',
        'type': 'dropdown',
        'label': 'Country',
        'options': [],
      },
      {
        'key': 'state',
        'type': 'dropdown',
        'label': 'State',
        'options': [],
        'dependsOn': {
          'field': 'country',
          'condition': 'notEmpty',
          'action': 'show',
          'clearOnHide': true,
        },
      },
    ]);

    final toClear = engine.fieldsToClear(
      formSchema,
      {'country': 'IN', 'state': 'MH'},
      {'country': ''},
    );
    expect(toClear, contains('state'));
  });
}
