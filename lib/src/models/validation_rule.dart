import 'package:equatable/equatable.dart';

class ValidationRule extends Equatable {
  const ValidationRule({
    required this.rule,
    this.value,
    required this.message,
  });

  /// Rule name: 'required', 'minLength', 'maxLength', 'email',
  /// 'regex', 'minAge', 'mustBeTrue', 'matchField', etc.
  final String rule;

  /// Optional comparand — a number, string, or list depending on the rule.
  final dynamic value;

  /// Error message shown when the rule fails.
  final String message;

  int? get intValue =>
      value is int ? value as int : int.tryParse(value.toString());

  String? get stringValue => value?.toString();

  factory ValidationRule.fromMap(Map<String, dynamic> map) {
    return ValidationRule(
      rule: map['rule'] as String,
      value: map['value'],
      message: map['message'] as String,
    );
  }

  @override
  List<Object?> get props => [rule, value, message];
}
