import 'package:get_it/get_it.dart';

import '../conditional/condition_evaluator_registry.dart';
import '../conditional/conditional_engine.dart';
import '../media/media_picker.dart';
import '../models/field_type.dart';
import '../registry/widget_registry.dart';
import '../validation/built_in_validator.dart';
import '../validation/field_validator.dart';
import '../validation/validation_rule_registry.dart';
import '../options/dependent_options_resolver.dart';
import '../theme/form_engine_theme.dart';
import '../widgets/fields/checkbox_field_widget.dart';
import '../widgets/fields/date_field_widget.dart';
import '../widgets/fields/dropdown_field_widget.dart';
import '../widgets/fields/image_field_widget.dart';
import '../widgets/fields/media_field_widget.dart';
import '../widgets/fields/multi_select_field_widget.dart';
import '../widgets/fields/radio_field_widget.dart';
import '../widgets/fields/searchable_dropdown_field_widget.dart';
import '../widgets/fields/time_field_widget.dart';
import '../widgets/fields/text_field_widget.dart';

/// Call [FormEngineLocator.setup()] once in your app's main() before
/// mounting any FormEngineWidget.
///
/// ```dart
/// void main() {
///   FormEngineLocator.setup(theme: myFormEngineTheme);
///   runApp(const MyApp());
/// }
/// ```
abstract final class FormEngineLocator {
  static final _locator = GetIt.instance;

  static void setup({
    FormEngineTheme? theme,
    FieldValidator? customValidator,
    ValidationRuleRegistry? validationRules,
    ConditionEvaluatorRegistry? conditionEvaluators,
    List<MapEntry<FieldType, FieldWidgetBuilder>>? customWidgets,
    MediaPicker? mediaPicker,
    bool reset = false,
  }) {
    // Prefer synchronous reassignment over GetIt.reset() (async) so tests and
    // hot-restart callers can safely re-run setup without racing registrations.
    if (reset) {
      _locator.allowReassignment = true;
    }

    _registerSingleton<FormEngineTheme>(theme ?? FormEngineTheme.carbon());

    final ruleRegistry = validationRules ?? ValidationRuleRegistry.withBuiltIns();
    final evaluatorRegistry =
        conditionEvaluators ?? ConditionEvaluatorRegistry.withBuiltIns();

    _registerSingleton<ValidationRuleRegistry>(ruleRegistry);
    _registerSingleton<ConditionEvaluatorRegistry>(evaluatorRegistry);

    _registerSingleton<ConditionalEngine>(
      ConditionalEngine(evaluatorRegistry: evaluatorRegistry),
    );

    _registerSingleton<DependentOptionsResolver>(
      const DependentOptionsResolver(),
    );

    _registerSingleton<FieldValidator>(
      customValidator ?? BuiltInValidator(ruleRegistry: ruleRegistry),
    );

    _registerSingleton<MediaPicker>(
      mediaPicker ?? const StubMediaPicker(),
    );

    final registry = WidgetRegistry();
    _registerBuiltIns(registry);
    customWidgets?.forEach((e) => registry.register(e.key, e.value));
    _registerSingleton<WidgetRegistry>(registry);

    if (reset) {
      _locator.allowReassignment = false;
    }
  }

  static void _registerSingleton<T extends Object>(T instance) {
    if (_locator.isRegistered<T>()) {
      _locator.unregister<T>();
    }
    _locator.registerSingleton<T>(instance);
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

    registry.register(
      FieldType.searchableDropdown,
      ({
        required schema,
        required value,
        required error,
        required enabled,
        required onChanged,
        required onFocusLost,
        required resolvedOptions,
      }) =>
          SearchableDropdownFieldWidget(
            schema: schema,
            value: value,
            error: error,
            enabled: enabled,
            onChanged: onChanged,
            onFocusLost: onFocusLost,
            resolvedOptions: resolvedOptions,
          ),
    );

    registry.register(
      FieldType.radio,
      ({
        required schema,
        required value,
        required error,
        required enabled,
        required onChanged,
        required onFocusLost,
        required resolvedOptions,
      }) =>
          RadioFieldWidget(
            schema: schema,
            value: value,
            error: error,
            enabled: enabled,
            onChanged: onChanged,
            onFocusLost: onFocusLost,
            resolvedOptions: resolvedOptions,
          ),
    );

    registry.register(
      FieldType.checkbox,
      ({
        required schema,
        required value,
        required error,
        required enabled,
        required onChanged,
        required onFocusLost,
        required resolvedOptions,
      }) =>
          CheckboxFieldWidget(
            schema: schema,
            value: value,
            error: error,
            enabled: enabled,
            onChanged: onChanged,
            onFocusLost: onFocusLost,
            resolvedOptions: resolvedOptions,
          ),
    );

    registry.register(
      FieldType.multiSelect,
      ({
        required schema,
        required value,
        required error,
        required enabled,
        required onChanged,
        required onFocusLost,
        required resolvedOptions,
      }) =>
          MultiSelectFieldWidget(
            schema: schema,
            value: value,
            error: error,
            enabled: enabled,
            onChanged: onChanged,
            onFocusLost: onFocusLost,
            resolvedOptions: resolvedOptions,
          ),
    );

    registry.register(
      FieldType.date,
      ({
        required schema,
        required value,
        required error,
        required enabled,
        required onChanged,
        required onFocusLost,
        required resolvedOptions,
      }) =>
          DateFieldWidget(
            schema: schema,
            value: value,
            error: error,
            enabled: enabled,
            onChanged: onChanged,
            onFocusLost: onFocusLost,
            resolvedOptions: resolvedOptions,
          ),
    );

    registry.register(
      FieldType.time,
      ({
        required schema,
        required value,
        required error,
        required enabled,
        required onChanged,
        required onFocusLost,
        required resolvedOptions,
      }) =>
          TimeFieldWidget(
            schema: schema,
            value: value,
            error: error,
            enabled: enabled,
            onChanged: onChanged,
            onFocusLost: onFocusLost,
            resolvedOptions: resolvedOptions,
          ),
    );

    registry.register(
      FieldType.searchableDropdown,
      ({
        required schema,
        required value,
        required error,
        required enabled,
        required onChanged,
        required onFocusLost,
        required resolvedOptions,
      }) =>
          SearchableDropdownFieldWidget(
            schema: schema,
            value: value,
            error: error,
            enabled: enabled,
            onChanged: onChanged,
            onFocusLost: onFocusLost,
            resolvedOptions: resolvedOptions,
          ),
    );

    registry.register(
      FieldType.image,
      ({
        required schema,
        required value,
        required error,
        required enabled,
        required onChanged,
        required onFocusLost,
        required resolvedOptions,
      }) =>
          ImageFieldWidget(
            schema: schema,
            value: value,
            error: error,
            enabled: enabled,
            onChanged: onChanged,
            onFocusLost: onFocusLost,
            resolvedOptions: resolvedOptions,
          ),
    );

    registry.register(
      FieldType.media,
      ({
        required schema,
        required value,
        required error,
        required enabled,
        required onChanged,
        required onFocusLost,
        required resolvedOptions,
      }) =>
          MediaFieldWidget(
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

  static FormEngineTheme get theme => _locator<FormEngineTheme>();

  static DependentOptionsResolver get dependentOptionsResolver =>
      _locator<DependentOptionsResolver>();

  static MediaPicker get mediaPicker => _locator<MediaPicker>();
}
