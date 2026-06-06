import 'package:flutter/material.dart';

import 'base_field_widget.dart';

class DropdownFieldWidget extends BaseFieldWidget {
  const DropdownFieldWidget({
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

    final optionValues = options.map((option) => option.value).toSet();
    final selectedValue = optionValues.contains(value) ? value : null;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        DropdownButtonFormField<dynamic>(
          initialValue: selectedValue,
          isExpanded: true,
          style: Theme.of(context).textTheme.bodyMedium,
          decoration: InputDecoration(
            labelText: schema.label,
            hintText: schema.hint,
            errorText: error,
          ).applyDefaults(Theme.of(context).inputDecorationTheme),
          onTap: () {},
          items: options
              .map(
                (o) => DropdownMenuItem<dynamic>(
                  value: o.value,
                  child: Text(
                    o.label,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ),
              )
              .toList(),
          onChanged: enabled
              ? (selected) {
                  onChanged(selected);
                  onFocusLost();
                }
              : null,
        ),
      ],
    );
  }
}
