import 'package:get_it/get_it.dart';

import '../conditional/condition_evaluator_registry.dart';
import '../conditional/conditional_engine.dart';
import '../models/field_type.dart';
import '../registry/widget_registry.dart';
import '../validation/built_in_validator.dart';
import '../validation/field_validator.dart';
import '../validation/validation_rule_registry.dart';
import '../widgets/fields/dropdown_field_widget.dart';
import '../widgets/fields/text_field_widget.dart';

/// Call [FormEngineLocator.setup()] once in your app's main() before
/// mounting any FormEngineWidget.
///
/// ```dart
/// void main() {
///   FormEngineLocator.setup();
///   runApp(const MyApp());
/// }
/// ```
abstract final class FormEngineLocator {
  static final _locator = GetIt.instance;

  static void setup({
    FieldValidator? customValidator,
    ValidationRuleRegistry? validationRules,
    ConditionEvaluatorRegistry? conditionEvaluators,
    List<MapEntry<FieldType, FieldWidgetBuilder>>? customWidgets,
    bool reset = false,
  }) {
    if (reset) _locator.reset();

    final ruleRegistry = validationRules ?? ValidationRuleRegistry.withBuiltIns();
    final evaluatorRegistry =
        conditionEvaluators ?? ConditionEvaluatorRegistry.withBuiltIns();

    _locator.registerSingleton<ValidationRuleRegistry>(ruleRegistry);
    _locator.registerSingleton<ConditionEvaluatorRegistry>(evaluatorRegistry);

    _locator.registerSingleton<ConditionalEngine>(
      ConditionalEngine(evaluatorRegistry: evaluatorRegistry),
    );

    _locator.registerSingleton<FieldValidator>(
      customValidator ?? BuiltInValidator(ruleRegistry: ruleRegistry),
    );

    final registry = WidgetRegistry();
    _registerBuiltIns(registry);
    customWidgets?.forEach((e) => registry.register(e.key, e.value));
    _locator.registerSingleton<WidgetRegistry>(registry);
  }

  static void _registerBuiltIns(WidgetRegistry registry) {
    for (final type in [
      FieldType.text,
      FieldType.email,
      FieldType.number,
      FieldType.phone,
      FieldType.password,
    ]) {
      registry.register(
        type,
        ({
          required schema,
          required value,
          required error,
          required enabled,
          required onChanged,
          required onFocusLost,
          required resolvedOptions,
        }) =>
            TextFieldWidget(
              schema: schema,
              value: value,
              error: error,
              enabled: enabled,
              onChanged: onChanged,
              onFocusLost: onFocusLost,
              resolvedOptions: resolvedOptions,
            ),
      );
    }

    registry.register(
      FieldType.dropdown,
      ({
        required schema,
        required value,
        required error,
        required enabled,
        required onChanged,
        required onFocusLost,
        required resolvedOptions,
      }) =>
          DropdownFieldWidget(
            schema: schema,
            value: value,
            error: error,
            enabled: enabled,
            onChanged: onChanged,
            onFocusLost: onFocusLost,
            resolvedOptions: resolvedOptions,
          ),
    );
  }

  static FieldValidator get validator => _locator<FieldValidator>();

  static ConditionalEngine get conditionalEngine =>
      _locator<ConditionalEngine>();

  static WidgetRegistry get widgetRegistry => _locator<WidgetRegistry>();

  static ValidationRuleRegistry get validationRules =>
      _locator<ValidationRuleRegistry>();

  static ConditionEvaluatorRegistry get conditionEvaluators =>
      _locator<ConditionEvaluatorRegistry>();
}
