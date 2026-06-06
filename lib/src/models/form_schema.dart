import 'dart:convert';

import 'package:equatable/equatable.dart';

import 'field_schema.dart';

class FormSchema extends Equatable {
  const FormSchema({
    required this.id,
    required this.title,
    this.submitLabel = 'Submit',
    this.resetLabel,
    required this.fields,
  });

  final String id;
  final String title;
  final String submitLabel;
  final String? resetLabel;
  final List<FieldSchema> fields;

  factory FormSchema.fromMap(Map<String, dynamic> map) {
    return FormSchema(
      id: map['id'] as String,
      title: map['title'] as String,
      submitLabel: map['submitLabel'] as String? ?? 'Submit',
      resetLabel: map['resetLabel'] as String?,
      fields: (map['fields'] as List<dynamic>)
          .map((e) => FieldSchema.fromMap(e as Map<String, dynamic>))
          .toList(),
    );
  }

  factory FormSchema.fromJson(String json) {
    return FormSchema.fromMap(jsonDecode(json) as Map<String, dynamic>);
  }

  @override
  List<Object?> get props => [id, fields];
}
