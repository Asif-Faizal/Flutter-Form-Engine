import '../models/field_schema.dart';

/// Contract for all validators.
/// Receives the field schema, the field's current value,
/// and the entire form value map for cross-field rules.
abstract class FieldValidator {
  String? validate(
    FieldSchema schema,
    dynamic value,
    Map<String, dynamic> allValues,
  );
}
