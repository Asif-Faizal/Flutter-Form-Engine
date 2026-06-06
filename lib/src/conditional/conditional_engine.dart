import '../models/conditional_rule.dart';
import '../models/field_schema.dart';
import '../models/form_schema.dart';
import 'condition_evaluator_registry.dart';

/// Evaluates [ConditionalRule]s against the current form values and
/// returns visibility and enabled maps for every field.
class ConditionalEngine {
  const ConditionalEngine({ConditionEvaluatorRegistry? evaluatorRegistry})
      : _evaluatorRegistry = evaluatorRegistry;

  final ConditionEvaluatorRegistry? _evaluatorRegistry;

  ConditionEvaluatorRegistry get _evaluators =>
      _evaluatorRegistry ?? ConditionEvaluatorRegistry.withBuiltIns();

  /// Returns a map of fieldKey → isVisible.
  Map<String, bool> computeVisibility(
    FormSchema schema,
    Map<String, dynamic> values,
  ) {
    final result = <String, bool>{};
    for (final field in schema.fields) {
      result[field.key] = _shouldBeVisible(field, values);
    }
    return result;
  }

  /// Returns a map of fieldKey → isEnabled.
  Map<String, bool> computeEnabled(
    FormSchema schema,
    Map<String, dynamic> values,
  ) {
    final result = <String, bool>{};
    for (final field in schema.fields) {
      result[field.key] = _shouldBeEnabled(field, values);
    }
    return result;
  }

  bool _shouldBeVisible(FieldSchema field, Map<String, dynamic> values) {
    final rule = field.dependsOn;
    if (rule == null) return field.visible;
    if (rule.action == 'show') return _evaluate(rule, values);
    if (rule.action == 'hide') return !_evaluate(rule, values);
    return field.visible;
  }

  bool _shouldBeEnabled(FieldSchema field, Map<String, dynamic> values) {
    final rule = field.dependsOn;
    if (rule == null) return field.enabled;
    if (rule.action == 'enable') return _evaluate(rule, values);
    if (rule.action == 'disable') return !_evaluate(rule, values);
    return field.enabled;
  }

  bool _evaluate(ConditionalRule rule, Map<String, dynamic> values) {
    final base = _evaluators.evaluate(rule, values);

    if (rule.and.isNotEmpty) {
      return base && rule.and.every((r) => _evaluate(r, values));
    }
    if (rule.or.isNotEmpty) {
      return base || rule.or.any((r) => _evaluate(r, values));
    }
    return base;
  }

  /// Returns keys of fields that should be cleared because they just
  /// became hidden and have clearOnHide = true.
  List<String> fieldsToClear(
    FormSchema schema,
    Map<String, dynamic> oldValues,
    Map<String, dynamic> newValues,
  ) {
    final oldVisibility = computeVisibility(schema, oldValues);
    final newVisibility = computeVisibility(schema, newValues);

    return schema.fields
        .where(
          (f) =>
              f.dependsOn?.clearOnHide == true &&
              oldVisibility[f.key] == true &&
              newVisibility[f.key] == false,
        )
        .map((f) => f.key)
        .toList();
  }
}
