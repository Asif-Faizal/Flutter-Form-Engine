import '../models/field_schema.dart';
import '../models/validation_rule.dart';
import 'field_validator.dart';
import 'validation_rule_registry.dart';

/// Validates fields using a pluggable [ValidationRuleRegistry].
///
/// Pass a custom registry to extend or override built-in rules without
/// forking this class.
class BuiltInValidator implements FieldValidator {
  const BuiltInValidator({ValidationRuleRegistry? ruleRegistry})
      : _ruleRegistry = ruleRegistry;

  final ValidationRuleRegistry? _ruleRegistry;

  ValidationRuleRegistry get _registry =>
      _ruleRegistry ?? ValidationRuleRegistry.withBuiltIns();

  @override
  String? validate(
    FieldSchema schema,
    dynamic value,
    Map<String, dynamic> allValues,
  ) {
    for (final rule in schema.validations) {
      final error = _applyRule(rule, value, allValues);
      if (error != null) return error;
    }
    return null;
  }

  String? _applyRule(
    ValidationRule rule,
    dynamic value,
    Map<String, dynamic> allValues,
  ) {
    return _registry.apply(rule, value, allValues);
  }
}

/// Chains multiple [FieldValidator]s — useful for layering custom logic
/// on top of the built-in validator.
class CompositeFieldValidator implements FieldValidator {
  const CompositeFieldValidator(this._validators);

  final List<FieldValidator> _validators;

  @override
  String? validate(
    FieldSchema schema,
    dynamic value,
    Map<String, dynamic> allValues,
  ) {
    for (final validator in _validators) {
      final error = validator.validate(schema, value, allValues);
      if (error != null) return error;
    }
    return null;
  }
}
