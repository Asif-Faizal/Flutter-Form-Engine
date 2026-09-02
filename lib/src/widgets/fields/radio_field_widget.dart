import 'package:flutter/material.dart';

import 'base_field_widget.dart';

/// Single-select field rendered as a vertical list of [RadioListTile] options.
class RadioFieldWidget extends BaseFieldWidget {
  const RadioFieldWidget({
    super.key,
    required super.schema,
    required super.value,
    required super.error,
    required super.enabled,
    required super.onChanged,
    required super.onFocusLost,
    required super.resolvedOptions,
  });

  @override
  Widget build(BuildContext context) {
    final options =
        resolvedOptions.isNotEmpty ? resolvedOptions : schema.options;
    final theme = Theme.of(context);

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
          (option) => RadioListTile<dynamic>(
            title: Text(option.label, style: theme.textTheme.bodyMedium),
            value: option.value,
            groupValue: value,
            onChanged: enabled
                ? (selected) {
                    onChanged(selected);
                    onFocusLost();
                  }
                : null,
            contentPadding: EdgeInsets.zero,
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
