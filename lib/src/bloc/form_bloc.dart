import 'package:flutter_bloc/flutter_bloc.dart';

import '../conditional/conditional_engine.dart';
import '../models/field_option.dart';
import '../models/form_schema.dart';
import '../validation/field_validator.dart';
import 'form_event.dart';
import 'form_state.dart';

class FormEngineBloc extends Bloc<FormEngineEvent, FormEngineState> {
  FormEngineBloc({
    required FieldValidator validator,
    required ConditionalEngine conditionalEngine,
    this.onSubmit,
  })  : _validator = validator,
        _conditionalEngine = conditionalEngine,
        super(const FormEngineState()) {
    on<FormSchemaLoaded>(_onSchemaLoaded);
    on<FormFieldChanged>(_onFieldChanged);
    on<FormFieldFocusLost>(_onFocusLost);
    on<FormSubmitRequested>(_onSubmitRequested);
    on<FormResetRequested>(_onResetRequested);
    on<FormDynamicOptionsLoaded>(_onDynamicOptionsLoaded);
  }

  final FieldValidator _validator;
  final ConditionalEngine _conditionalEngine;

  /// Called with the cleaned, visible-only values after successful validation.
  final void Function(Map<String, dynamic> values)? onSubmit;

  void _onSchemaLoaded(
    FormSchemaLoaded event,
    Emitter<FormEngineState> emit,
  ) {
    final schema = event.schema;
    final initialValues = _buildInitialValues(schema);
    final visibility = _conditionalEngine.computeVisibility(
      schema,
      initialValues,
    );
    final enabled = _conditionalEngine.computeEnabled(schema, initialValues);
    final errors = _validateAll(
      schema,
      initialValues,
      visibilityMap: visibility,
    );

    emit(
      state.copyWith(
        schema: schema,
        values: initialValues,
        errors: errors,
        visibilityMap: visibility,
        enabledMap: enabled,
        isDirty: false,
      ),
    );
  }

  void _onFieldChanged(
    FormFieldChanged event,
    Emitter<FormEngineState> emit,
  ) {
    final schema = state.schema;
    if (schema == null) return;

    final oldValues = Map<String, dynamic>.from(state.values);
    final newValues = Map<String, dynamic>.from(state.values)
      ..[event.key] = event.value;

    final toClear = _conditionalEngine.fieldsToClear(
      schema,
      oldValues,
      newValues,
    );
    for (final k in toClear) {
      newValues.remove(k);
    }

    final visibility = _conditionalEngine.computeVisibility(schema, newValues);
    final enabled = _conditionalEngine.computeEnabled(schema, newValues);
    final errors = _validateAll(
      schema,
      newValues,
      visibilityMap: visibility,
    );

    emit(
      state.copyWith(
        values: newValues,
        errors: errors,
        visibilityMap: visibility,
        enabledMap: enabled,
        isDirty: true,
      ),
    );
  }

  void _onFocusLost(
    FormFieldFocusLost event,
    Emitter<FormEngineState> emit,
  ) {
    final touched = Set<String>.from(state.touched)..add(event.key);
    emit(state.copyWith(touched: touched));
  }

  void _onSubmitRequested(
    FormSubmitRequested event,
    Emitter<FormEngineState> emit,
  ) {
    final schema = state.schema;
    if (schema == null) return;

    final visibility =
        _conditionalEngine.computeVisibility(schema, state.values);
    final allVisibleKeys = schema.fields
        .where((f) => visibility[f.key] != false)
        .map((f) => f.key)
        .toSet();

    final errors = _validateAll(
      schema,
      state.values,
      visibilityMap: visibility,
    );
    emit(
      state.copyWith(
        touched: allVisibleKeys,
        errors: errors,
        visibilityMap: visibility,
        submitStatus: FormSubmitStatus.validating,
      ),
    );

    final hasErrors = errors.entries.any(
      (e) => visibility[e.key] != false && e.value != null,
    );

    if (hasErrors) {
      emit(state.copyWith(submitStatus: FormSubmitStatus.idle));
      return;
    }

    final payload = Map<String, dynamic>.fromEntries(
      state.values.entries.where(
        (e) => visibility[e.key] != false,
      ),
    );

    onSubmit?.call(payload);
    emit(state.copyWith(submitStatus: FormSubmitStatus.success));
  }

  void _onResetRequested(
    FormResetRequested event,
    Emitter<FormEngineState> emit,
  ) {
    final schema = state.schema;
    if (schema == null) return;

    final initialValues = _buildInitialValues(schema);
    final visibility = _conditionalEngine.computeVisibility(
      schema,
      initialValues,
    );
    final enabled = _conditionalEngine.computeEnabled(schema, initialValues);

    emit(
      state.copyWith(
        values: initialValues,
        errors: _validateAll(
          schema,
          initialValues,
          visibilityMap: visibility,
        ),
        touched: {},
        visibilityMap: visibility,
        enabledMap: enabled,
        submitStatus: FormSubmitStatus.idle,
        isDirty: false,
      ),
    );
  }

  void _onDynamicOptionsLoaded(
    FormDynamicOptionsLoaded event,
    Emitter<FormEngineState> emit,
  ) {
    final dynamicOptions =
        Map<String, List<FieldOption>>.from(state.dynamicOptions)
          ..[event.key] = event.options;
    final loadingOptions = Map<String, bool>.from(state.loadingOptions)
      ..[event.key] = false;

    emit(
      state.copyWith(
        dynamicOptions: dynamicOptions,
        loadingOptions: loadingOptions,
      ),
    );
  }

  Map<String, dynamic> _buildInitialValues(FormSchema schema) {
    return {
      for (final f in schema.fields)
        if (f.initialValue != null) f.key: f.initialValue,
    };
  }

  Map<String, String?> _validateAll(
    FormSchema schema,
    Map<String, dynamic> values, {
    required Map<String, bool> visibilityMap,
  }) {
    return {
      for (final f in schema.fields)
        f.key: visibilityMap[f.key] == false
            ? null
            : _validator.validate(f, values[f.key], values),
    };
  }
}
