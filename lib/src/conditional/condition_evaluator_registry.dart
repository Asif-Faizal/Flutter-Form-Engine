import '../models/conditional_rule.dart';

/// Signature for a single condition evaluator.
typedef ConditionHandler = bool Function(
  ConditionalRule rule,
  Map<String, dynamic> values,
);

/// Pluggable registry of condition handlers for [ConditionalEngine].
///
/// Register custom conditions at startup:
/// ```dart
/// final evaluators = ConditionEvaluatorRegistry.withBuiltIns()
///   ..register('startsWith', (rule, values) => ...);
/// ```
class ConditionEvaluatorRegistry {
  ConditionEvaluatorRegistry();

  final Map<String, ConditionHandler> _handlers = {};

  factory ConditionEvaluatorRegistry.withBuiltIns() {
    final registry = ConditionEvaluatorRegistry();
    BuiltInConditions.registerAll(registry);
    return registry;
  }

  void register(String conditionName, ConditionHandler handler) {
    _handlers[conditionName] = handler;
  }

  void unregister(String conditionName) {
    _handlers.remove(conditionName);
  }

  bool evaluate(ConditionalRule rule, Map<String, dynamic> values) {
    final handler = _handlers[rule.condition];
    if (handler == null) return true;
    return handler(rule, values);
  }
}

/// Built-in condition handlers registered into [ConditionEvaluatorRegistry].
abstract final class BuiltInConditions {
  static void registerAll(ConditionEvaluatorRegistry registry) {
    registry.register('equals', _equals);
    registry.register('notEquals', _notEquals);
    registry.register('notEmpty', _notEmpty);
    registry.register('isEmpty', _isEmpty);
    registry.register('contains', _contains);
    registry.register('in', _in);
    registry.register('greaterThan', _greaterThan);
    registry.register('lessThan', _lessThan);
  }

  static dynamic _fieldValue(ConditionalRule rule, Map<String, dynamic> values) {
    return values[rule.field];
  }

  static bool _equals(ConditionalRule rule, Map<String, dynamic> values) {
    return _fieldValue(rule, values) == rule.value;
  }

  static bool _notEquals(ConditionalRule rule, Map<String, dynamic> values) {
    return _fieldValue(rule, values) != rule.value;
  }

  static bool _notEmpty(ConditionalRule rule, Map<String, dynamic> values) {
    final fieldValue = _fieldValue(rule, values);
    return fieldValue != null && fieldValue.toString().isNotEmpty;
  }

  static bool _isEmpty(ConditionalRule rule, Map<String, dynamic> values) {
    final fieldValue = _fieldValue(rule, values);
    return fieldValue == null || fieldValue.toString().isEmpty;
  }

  static bool _contains(ConditionalRule rule, Map<String, dynamic> values) {
    final fieldValue = _fieldValue(rule, values);
    return fieldValue?.toString().contains(rule.value.toString()) ?? false;
  }

  static bool _in(ConditionalRule rule, Map<String, dynamic> values) {
    final fieldValue = _fieldValue(rule, values);
    return (rule.value as List).contains(fieldValue);
  }

  static bool _greaterThan(ConditionalRule rule, Map<String, dynamic> values) {
    final fieldValue = _fieldValue(rule, values);
    return fieldValue is num &&
        rule.value is num &&
        fieldValue > (rule.value as num);
  }

  static bool _lessThan(ConditionalRule rule, Map<String, dynamic> values) {
    final fieldValue = _fieldValue(rule, values);
    return fieldValue is num &&
        rule.value is num &&
        fieldValue < (rule.value as num);
  }
}
