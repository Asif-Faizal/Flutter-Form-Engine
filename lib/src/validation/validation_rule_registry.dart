import '../models/validation_rule.dart';

/// Signature for a single validation rule handler.
/// Return `null` when valid, or an error message when invalid.
typedef ValidationRuleHandler = String? Function(
  ValidationRule rule,
  dynamic value,
  Map<String, dynamic> allValues,
);

/// Pluggable registry of validation rule handlers.
///
/// Register custom rules at startup without modifying [BuiltInValidator]:
/// ```dart
/// final registry = ValidationRuleRegistry.withBuiltIns()
///   ..register('customRule', (rule, value, all) => ...);
/// ```
class ValidationRuleRegistry {
  ValidationRuleRegistry();

  final Map<String, ValidationRuleHandler> _handlers = {};

  /// Creates a registry pre-populated with all built-in rule handlers.
  factory ValidationRuleRegistry.withBuiltIns() {
    final registry = ValidationRuleRegistry();
    BuiltInValidationRules.registerAll(registry);
    return registry;
  }

  void register(String ruleName, ValidationRuleHandler handler) {
    _handlers[ruleName] = handler;
  }

  void unregister(String ruleName) {
    _handlers.remove(ruleName);
  }

  bool isRegistered(String ruleName) => _handlers.containsKey(ruleName);

  String? apply(
    ValidationRule rule,
    dynamic value,
    Map<String, dynamic> allValues,
  ) {
    final handler = _handlers[rule.rule];
    if (handler == null) return null;
    return handler(rule, value, allValues);
  }
}

/// Built-in validation rule implementations, registered into a [ValidationRuleRegistry].
abstract final class BuiltInValidationRules {
  static void registerAll(ValidationRuleRegistry registry) {
    registry.register('required', _required);
    registry.register('minLength', _minLength);
    registry.register('maxLength', _maxLength);
    registry.register('email', _email);
    registry.register('regex', _regex);
    registry.register('minAge', _minAge);
    registry.register('mustBeTrue', _mustBeTrue);
    registry.register('minSelect', _minSelect);
    registry.register('maxSelect', _maxSelect);
    registry.register('matchField', _matchField);
  }

  static String? _required(
    ValidationRule rule,
    dynamic value,
    Map<String, dynamic> allValues,
  ) {
    if (value == null) return rule.message;
    if (value is String && value.trim().isEmpty) return rule.message;
    if (value is List && value.isEmpty) return rule.message;
    return null;
  }

  static String? _minLength(
    ValidationRule rule,
    dynamic value,
    Map<String, dynamic> allValues,
  ) {
    final min = rule.intValue;
    if (min == null || value == null) return null;
    return value.toString().length < min ? rule.message : null;
  }

  static String? _maxLength(
    ValidationRule rule,
    dynamic value,
    Map<String, dynamic> allValues,
  ) {
    final max = rule.intValue;
    if (max == null || value == null) return null;
    return value.toString().length > max ? rule.message : null;
  }

  static final _emailRegex = RegExp(
    r'^[a-zA-Z0-9._%+\-]+@[a-zA-Z0-9.\-]+\.[a-zA-Z]{2,}$',
  );

  static String? _email(
    ValidationRule rule,
    dynamic value,
    Map<String, dynamic> allValues,
  ) {
    if (value == null || value.toString().isEmpty) return null;
    return _emailRegex.hasMatch(value.toString()) ? null : rule.message;
  }

  static String? _regex(
    ValidationRule rule,
    dynamic value,
    Map<String, dynamic> allValues,
  ) {
    final pattern = rule.stringValue;
    if (pattern == null || value == null) return null;
    return RegExp(pattern).hasMatch(value.toString()) ? null : rule.message;
  }

  static String? _minAge(
    ValidationRule rule,
    dynamic value,
    Map<String, dynamic> allValues,
  ) {
    final minAge = rule.intValue;
    if (minAge == null || value is! DateTime) return null;
    return _ageFrom(value) < minAge ? rule.message : null;
  }

  static int _ageFrom(DateTime dob) {
    final today = DateTime.now();
    var age = today.year - dob.year;
    if (today.month < dob.month ||
        (today.month == dob.month && today.day < dob.day)) {
      age--;
    }
    return age;
  }

  static String? _mustBeTrue(
    ValidationRule rule,
    dynamic value,
    Map<String, dynamic> allValues,
  ) {
    return (value == true) ? null : rule.message;
  }

  static String? _minSelect(
    ValidationRule rule,
    dynamic value,
    Map<String, dynamic> allValues,
  ) {
    final min = rule.intValue;
    if (min == null || value is! List) return null;
    return value.length < min ? rule.message : null;
  }

  static String? _maxSelect(
    ValidationRule rule,
    dynamic value,
    Map<String, dynamic> allValues,
  ) {
    final max = rule.intValue;
    if (max == null || value is! List) return null;
    return value.length > max ? rule.message : null;
  }

  static String? _matchField(
    ValidationRule rule,
    dynamic value,
    Map<String, dynamic> allValues,
  ) {
    return value == allValues[rule.stringValue] ? null : rule.message;
  }
}
