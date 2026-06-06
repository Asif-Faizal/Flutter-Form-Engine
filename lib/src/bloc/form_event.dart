import 'package:equatable/equatable.dart';

import '../models/field_option.dart';
import '../models/form_schema.dart';

abstract class FormEngineEvent extends Equatable {
  const FormEngineEvent();
}

/// Feed a parsed schema into the BLoC to initialise the form.
class FormSchemaLoaded extends FormEngineEvent {
  const FormSchemaLoaded(this.schema);
  final FormSchema schema;
  @override
  List<Object?> get props => [schema];
}

/// Fired by every field widget whenever its value changes.
class FormFieldChanged extends FormEngineEvent {
  const FormFieldChanged({required this.key, required this.value});
  final String key;
  final dynamic value;
  @override
  List<Object?> get props => [key, value];
}

/// Fired when a field loses focus — triggers per-field validation display.
class FormFieldFocusLost extends FormEngineEvent {
  const FormFieldFocusLost(this.key);
  final String key;
  @override
  List<Object?> get props => [key];
}

/// User tapped the submit button.
class FormSubmitRequested extends FormEngineEvent {
  const FormSubmitRequested();
  @override
  List<Object?> get props => [];
}

/// User tapped the reset button.
class FormResetRequested extends FormEngineEvent {
  const FormResetRequested();
  @override
  List<Object?> get props => [];
}

/// Returned from a remote options fetch (for dynamic dropdowns).
class FormDynamicOptionsLoaded extends FormEngineEvent {
  const FormDynamicOptionsLoaded({required this.key, required this.options});
  final String key;
  final List<FieldOption> options;
  @override
  List<Object?> get props => [key, options];
}
