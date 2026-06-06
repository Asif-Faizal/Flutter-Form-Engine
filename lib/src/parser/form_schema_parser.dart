import 'dart:convert';

import '../models/form_schema.dart';

/// Converts a raw JSON string or decoded Map into a [FormSchema].
///
/// Usage:
///   final schema = FormSchemaParser.parse(jsonString);
///   final schema = FormSchemaParser.parseMap(decodedMap);
abstract final class FormSchemaParser {
  static FormSchema parse(String jsonString) {
    final map = jsonDecode(jsonString) as Map<String, dynamic>;
    return parseMap(map);
  }

  static FormSchema parseMap(Map<String, dynamic> map) {
    return FormSchema.fromMap(map);
  }
}
