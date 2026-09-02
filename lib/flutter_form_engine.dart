/// Flutter Form Engine — JSON-driven dynamic form builder.
library flutter_form_engine;

// Models
export 'src/models/form_schema.dart';
export 'src/models/field_schema.dart';
export 'src/models/field_type.dart';
export 'src/models/field_option.dart';
export 'src/models/validation_rule.dart';
export 'src/models/conditional_rule.dart';

// Parser
export 'src/parser/form_schema_parser.dart';

// BLoC
export 'src/bloc/form_bloc.dart';
export 'src/bloc/form_event.dart';
export 'src/bloc/form_state.dart';

// Validation
export 'src/validation/field_validator.dart';
export 'src/validation/built_in_validator.dart';
export 'src/validation/validation_rule_registry.dart';

// Conditional
export 'src/conditional/conditional_engine.dart';
export 'src/conditional/condition_evaluator_registry.dart';

// Options
export 'src/options/dependent_options_resolver.dart';

// Theme
export 'src/theme/form_engine_theme.dart';
export 'src/theme/form_engine_theme_applicator.dart';

// Registry
export 'src/registry/widget_registry.dart';

// Widgets
export 'src/widgets/form_engine_widget.dart';
export 'src/widgets/fields/base_field_widget.dart';
export 'src/widgets/fields/text_field_widget.dart';
export 'src/widgets/fields/checkbox_field_widget.dart';
export 'src/widgets/fields/date_field_widget.dart';
export 'src/widgets/fields/dropdown_field_widget.dart';
export 'src/widgets/fields/multi_select_field_widget.dart';
export 'src/widgets/fields/radio_field_widget.dart';

// DI
export 'src/di/form_engine_locator.dart';
