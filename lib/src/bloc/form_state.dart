import 'package:equatable/equatable.dart';

import '../models/field_option.dart';
import '../models/form_schema.dart';

enum FormSubmitStatus { idle, validating, success, failure }

class FormEngineState extends Equatable {
  const FormEngineState({
    this.schema,
    this.values = const {},
    this.errors = const {},
    this.touched = const {},
    this.visibilityMap = const {},
    this.enabledMap = const {},
    this.dynamicOptions = const {},
    this.loadingOptions = const {},
    this.submitStatus = FormSubmitStatus.idle,
    this.isDirty = false,
  });

  final FormSchema? schema;

  /// key → raw user value
  final Map<String, dynamic> values;

  /// key → validation error message (null = valid)
  final Map<String, String?> errors;

  /// keys that the user has interacted with (show errors only for touched fields)
  final Set<String> touched;

  /// key → is the field currently visible
  final Map<String, bool> visibilityMap;

  /// key → is the field currently enabled
  final Map<String, bool> enabledMap;

  /// key → options loaded from a remote endpoint
  final Map<String, List<FieldOption>> dynamicOptions;

  /// key → true while remote options are loading
  final Map<String, bool> loadingOptions;

  final FormSubmitStatus submitStatus;
  final bool isDirty;

  bool get isValid => errors.values.every((e) => e == null);

  bool get isLoading => schema == null;

  /// Whether to show validation error for a given key.
  /// Errors are only surfaced after the user has touched the field.
  String? errorFor(String key) => touched.contains(key) ? errors[key] : null;

  FormEngineState copyWith({
    FormSchema? schema,
    Map<String, dynamic>? values,
    Map<String, String?>? errors,
    Set<String>? touched,
    Map<String, bool>? visibilityMap,
    Map<String, bool>? enabledMap,
    Map<String, List<FieldOption>>? dynamicOptions,
    Map<String, bool>? loadingOptions,
    FormSubmitStatus? submitStatus,
    bool? isDirty,
  }) {
    return FormEngineState(
      schema: schema ?? this.schema,
      values: values ?? this.values,
      errors: errors ?? this.errors,
      touched: touched ?? this.touched,
      visibilityMap: visibilityMap ?? this.visibilityMap,
      enabledMap: enabledMap ?? this.enabledMap,
      dynamicOptions: dynamicOptions ?? this.dynamicOptions,
      loadingOptions: loadingOptions ?? this.loadingOptions,
      submitStatus: submitStatus ?? this.submitStatus,
      isDirty: isDirty ?? this.isDirty,
    );
  }

  @override
  List<Object?> get props => [
        schema,
        values,
        errors,
        touched,
        visibilityMap,
        enabledMap,
        dynamicOptions,
        loadingOptions,
        submitStatus,
        isDirty,
      ];
}
