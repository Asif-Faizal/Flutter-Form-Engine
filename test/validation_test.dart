import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_form_engine/flutter_form_engine.dart';

void main() {
  const validator = BuiltInValidator();

  FieldSchema field(List<Map<String, dynamic>> rules) {
    return FieldSchema.fromMap({
      'key': 'test',
      'type': 'text',
      'label': 'Test',
      'validations': rules,
    });
  }

  group('required rule', () {
    test('fails on null', () {
      final schema = field([
        {'rule': 'required', 'message': 'Required'},
      ]);
      expect(validator.validate(schema, null, {}), 'Required');
    });

    test('fails on empty string', () {
      final schema = field([
        {'rule': 'required', 'message': 'Required'},
      ]);
      expect(validator.validate(schema, '', {}), 'Required');
    });

    test('passes on non-empty string', () {
      final schema = field([
        {'rule': 'required', 'message': 'Required'},
      ]);
      expect(validator.validate(schema, 'hello', {}), isNull);
    });
  });

  group('email rule', () {
    test('passes valid email', () {
      final schema = field([
        {'rule': 'email', 'message': 'Invalid email'},
      ]);
      expect(validator.validate(schema, 'user@example.com', {}), isNull);
    });

    test('fails invalid email', () {
      final schema = field([
        {'rule': 'email', 'message': 'Invalid email'},
      ]);
      expect(validator.validate(schema, 'not-an-email', {}), 'Invalid email');
    });
  });

  group('minLength rule', () {
    test('fails when too short', () {
      final schema = field([
        {'rule': 'minLength', 'value': 5, 'message': 'Too short'},
      ]);
      expect(validator.validate(schema, 'abc', {}), 'Too short');
    });

    test('passes at exact minimum', () {
      final schema = field([
        {'rule': 'minLength', 'value': 3, 'message': 'Too short'},
      ]);
      expect(validator.validate(schema, 'abc', {}), isNull);
    });
  });

  group('custom rule via registry', () {
    test('applies registered custom rule', () {
      final registry = ValidationRuleRegistry.withBuiltIns()
        ..register(
          'alwaysFail',
          (rule, value, allValues) => rule.message,
        );

      final customValidator = BuiltInValidator(ruleRegistry: registry);
      final schema = field([
        {'rule': 'alwaysFail', 'message': 'Custom failure'},
      ]);

      expect(customValidator.validate(schema, 'anything', {}), 'Custom failure');
    });
  });
}
