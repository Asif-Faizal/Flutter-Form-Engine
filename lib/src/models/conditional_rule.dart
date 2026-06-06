import 'package:equatable/equatable.dart';

/// Describes when a field should be shown, hidden, enabled, disabled,
/// required, or cleared — based on another field's value.
class ConditionalRule extends Equatable {
  const ConditionalRule({
    required this.field,
    required this.condition,
    this.value,
    required this.action,
    this.clearOnHide = false,
    this.and = const [],
    this.or = const [],
  });

  /// The key of the field this rule watches.
  final String field;

  /// Comparison operator:
  /// 'equals' | 'notEquals' | 'notEmpty' | 'isEmpty' |
  /// 'contains' | 'in' | 'greaterThan' | 'lessThan'
  final String condition;

  /// The comparand value (null for notEmpty/isEmpty).
  final dynamic value;

  /// What to do when the condition is true:
  /// 'show' | 'hide' | 'enable' | 'disable' | 'require' | 'clear'
  final String action;

  /// If true, the field's current value is wiped when it becomes hidden.
  final bool clearOnHide;

  /// All of these sub-rules must also be true (AND chain).
  final List<ConditionalRule> and;

  /// At least one of these sub-rules must be true (OR chain).
  final List<ConditionalRule> or;

  factory ConditionalRule.fromMap(Map<String, dynamic> map) {
    return ConditionalRule(
      field: map['field'] as String,
      condition: map['condition'] as String,
      value: map['value'],
      action: map['action'] as String,
      clearOnHide: map['clearOnHide'] as bool? ?? false,
      and: (map['and'] as List<dynamic>? ?? [])
          .map((e) => ConditionalRule.fromMap(e as Map<String, dynamic>))
          .toList(),
      or: (map['or'] as List<dynamic>? ?? [])
          .map((e) => ConditionalRule.fromMap(e as Map<String, dynamic>))
          .toList(),
    );
  }

  @override
  List<Object?> get props => [field, condition, value, action];
}
