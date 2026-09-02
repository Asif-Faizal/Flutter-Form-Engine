import 'package:flutter/material.dart';

import 'base_field_widget.dart';

/// Multi-select field rendered as a list of [CheckboxListTile] options.
///
/// Submitted value is a `List` of selected option values.
class MultiSelectFieldWidget extends BaseFieldWidget {
  const MultiSelectFieldWidget({
    super.key,
    required super.schema,
    required super.value,
    required super.error,
    required super.enabled,
    required super.onChanged,
    required super.onFocusLost,
    required super.resolvedOptions,
  });

  List<dynamic> get _selectedValues {
    if (value is List) return List<dynamic>.from(value as List);
    return const [];
  }

  void _toggleOption(dynamic optionValue) {
    final selected = List<dynamic>.from(_selectedValues);
    if (selected.contains(optionValue)) {
      selected.remove(optionValue);
    } else {
      selected.add(optionValue);
    }
    onChanged(selected);
    onFocusLost();
  }

  @override
  Widget build(BuildContext context) {
    final options =
        resolvedOptions.isNotEmpty ? resolvedOptions : schema.options;
    final theme = Theme.of(context);
    final selected = _selectedValues;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(schema.label, style: theme.textTheme.labelLarge),
        if (schema.hint != null) ...[
          const SizedBox(height: 4),
          Text(schema.hint!, style: theme.textTheme.bodySmall),
        ],
        ...options.map(
          (option) => CheckboxListTile(
            title: Text(option.label, style: theme.textTheme.bodyMedium),
            value: selected.contains(option.value),
            onChanged: enabled ? (_) => _toggleOption(option.value) : null,
            contentPadding: EdgeInsets.zero,
            controlAffinity: ListTileControlAffinity.leading,
            dense: true,
          ),
        ),
        if (error != null)
          Padding(
            padding: const EdgeInsets.only(top: 4),
            child: Text(
              error!,
              style: theme.inputDecorationTheme.errorStyle,
            ),
          ),
      ],
    );
  }
}
