import 'package:equatable/equatable.dart';
import 'package:flutter/services.dart';
import 'conditional_rule.dart';
import 'field_option.dart';
import 'field_type.dart';
import 'validation_rule.dart';

class FieldSchema extends Equatable {
  const FieldSchema({
    required this.key,
    required this.type,
    required this.label,
    this.hint,
    this.required = false,
    this.enabled = true,
    this.visible = true,
    this.initialValue,
    this.validations = const [],
    this.options = const [],
    this.dependsOn,
    this.keyboardType,
    this.minLength,
    this.maxLength,
    this.searchable = false,
    this.minSelect,
    this.maxSelect,
    this.optionsEndpoint,
    this.optionsSourceKey,
    this.minDate,
    this.maxDate,
    this.dateFormat,
    this.use24Hour = false,
    this.extra = const {},
  });

  final String key;
  final FieldType type;
  final String label;
  final String? hint;
  final bool required;
  final bool enabled;
  final bool visible;
  final dynamic initialValue;
  final List<ValidationRule> validations;
  final List<FieldOption> options;
  final ConditionalRule? dependsOn;
  final TextInputType? keyboardType;
  final int? minLength;
  final int? maxLength;
  final bool searchable;
  final int? minSelect;
  final int? maxSelect;
  final String? optionsEndpoint;
  final String? optionsSourceKey;
  final DateTime? minDate;
  final DateTime? maxDate;
  final String? dateFormat;
  final bool use24Hour;
  final Map<String, dynamic> extra;

  factory FieldSchema.fromMap(Map<String, dynamic> map) {
    return FieldSchema(
      key: map['key'] as String,
      type: FieldType.fromString(map['type'] as String),
      label: map['label'] as String,
      hint: map['hint'] as String?,
      required: map['required'] as bool? ?? false,
      enabled: map['enabled'] as bool? ?? true,
      visible: map['visible'] as bool? ?? true,
      initialValue: map['initialValue'],
      validations: (map['validations'] as List<dynamic>? ?? [])
          .map((e) => ValidationRule.fromMap(e as Map<String, dynamic>))
          .toList(),
      options: (map['options'] as List<dynamic>? ?? [])
          .map((e) => FieldOption.fromMap(e as Map<String, dynamic>))
          .toList(),
      dependsOn: map['dependsOn'] != null
          ? ConditionalRule.fromMap(map['dependsOn'] as Map<String, dynamic>)
          : null,
      keyboardType: _parseKeyboardType(map['keyboardType'] as String?),
      minLength: map['minLength'] as int?,
      maxLength: map['maxLength'] as int?,
      searchable: map['searchable'] as bool? ?? false,
      minSelect: map['minSelect'] as int?,
      maxSelect: map['maxSelect'] as int?,
      optionsEndpoint: map['optionsEndpoint'] as String?,
      optionsSourceKey: map['optionsSourceKey'] as String?,
      dateFormat: map['dateFormat'] as String?,
      use24Hour: map['use24Hour'] as bool? ?? false,
      extra: (map['extra'] as Map<String, dynamic>?) ?? const {},
    );
  }

  static TextInputType? _parseKeyboardType(String? raw) {
    return switch (raw) {
      'text' => TextInputType.text,
      'number' => TextInputType.number,
      'emailAddress' => TextInputType.emailAddress,
      'phone' => TextInputType.phone,
      'multiline' => TextInputType.multiline,
      'url' => TextInputType.url,
      'visiblePassword' => TextInputType.visiblePassword,
      _ => null,
    };
  }

  @override
  List<Object?> get props => [key, type];
}
