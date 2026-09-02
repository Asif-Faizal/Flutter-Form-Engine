import 'package:flutter/material.dart';

import 'base_field_widget.dart';

/// Boolean field rendered as a single [CheckboxListTile].
class CheckboxFieldWidget extends BaseFieldWidget {
  const CheckboxFieldWidget({
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
    final theme = Theme.of(context);
    final isChecked = value == true;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        CheckboxListTile(
          title: Text(schema.label, style: theme.textTheme.bodyMedium),
          subtitle: schema.hint != null
              ? Text(schema.hint!, style: theme.textTheme.bodySmall)
              : null,
          value: isChecked,
          onChanged: enabled
              ? (checked) {
                  onChanged(checked ?? false);
                  onFocusLost();
                }
              : null,
          contentPadding: EdgeInsets.zero,
          controlAffinity: ListTileControlAffinity.leading,
        ),
        if (error != null)
          Padding(
            padding: const EdgeInsets.only(left: 12, top: 4),
            child: Text(
              error!,
              style: theme.inputDecorationTheme.errorStyle,
            ),
          ),
      ],
    );
  }
}
