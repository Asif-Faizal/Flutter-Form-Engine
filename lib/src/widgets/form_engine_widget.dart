import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/form_bloc.dart';
import '../bloc/form_event.dart';
import '../bloc/form_state.dart';
import '../di/form_engine_locator.dart';
import '../models/field_option.dart';
import '../models/field_schema.dart';
import '../models/form_schema.dart';
import '../registry/widget_registry.dart';

/// The root widget. Provide a [FormSchema] and an [onSubmit] callback.
///
/// ```dart
/// FormEngineWidget(
///   schema: FormSchema.fromJson(jsonString),
///   onSubmit: (values) => print(values),
/// )
/// ```
class FormEngineWidget extends StatelessWidget {
  const FormEngineWidget({
    super.key,
    required this.schema,
    required this.onSubmit,
    this.padding = const EdgeInsets.all(16),
    this.showResetButton = false,
  });

  final FormSchema schema;
  final void Function(Map<String, dynamic> values) onSubmit;
  final EdgeInsets padding;
  final bool showResetButton;

  @override
  Widget build(BuildContext context) {
    return BlocProvider<FormEngineBloc>(
      create: (_) => FormEngineBloc(
        validator: FormEngineLocator.validator,
        conditionalEngine: FormEngineLocator.conditionalEngine,
        onSubmit: onSubmit,
      )..add(FormSchemaLoaded(schema)),
      child: _FormEngineBody(
        padding: padding,
        showResetButton: showResetButton,
      ),
    );
  }
}

class _FormEngineBody extends StatelessWidget {
  const _FormEngineBody({
    required this.padding,
    required this.showResetButton,
  });

  final EdgeInsets padding;
  final bool showResetButton;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FormEngineBloc, FormEngineState>(
      builder: (context, state) {
        final schema = state.schema;
        if (schema == null) {
          return const Center(child: CircularProgressIndicator());
        }

        final registry = FormEngineLocator.widgetRegistry;

        return SingleChildScrollView(
          padding: padding,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              for (final field in schema.fields)
                if (state.visibilityMap[field.key] != false)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: _buildField(
                      context,
                      field,
                      state,
                      registry,
                    ),
                  ),
              const SizedBox(height: 8),
              FilledButton(
                onPressed: state.submitStatus == FormSubmitStatus.validating
                    ? null
                    : () => context
                        .read<FormEngineBloc>()
                        .add(const FormSubmitRequested()),
                child: Text(schema.submitLabel),
              ),
              if (showResetButton) ...[
                const SizedBox(height: 8),
                OutlinedButton(
                  onPressed: () => context
                      .read<FormEngineBloc>()
                      .add(const FormResetRequested()),
                  child: Text(schema.resetLabel ?? 'Reset'),
                ),
              ],
              if (state.submitStatus == FormSubmitStatus.success) ...[
                const SizedBox(height: 12),
                const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.check_circle, color: Colors.green),
                    SizedBox(width: 8),
                    Text('Submitted successfully'),
                  ],
                ),
              ],
            ],
          ),
        );
      },
    );
  }

  Widget _buildField(
    BuildContext context,
    FieldSchema field,
    FormEngineState state,
    WidgetRegistry registry,
  ) {
    final resolvedOptions = [
      ...(state.dynamicOptions[field.key] ?? <FieldOption>[]),
      if ((state.dynamicOptions[field.key] ?? []).isEmpty) ...field.options,
    ];

    return registry.build(
      schema: field,
      value: state.values[field.key],
      error: state.errorFor(field.key),
      enabled: state.enabledMap[field.key] ?? field.enabled,
      onChanged: (v) => context
          .read<FormEngineBloc>()
          .add(FormFieldChanged(key: field.key, value: v)),
      onFocusLost: () => context
          .read<FormEngineBloc>()
          .add(FormFieldFocusLost(field.key)),
      resolvedOptions: resolvedOptions,
    );
  }
}
