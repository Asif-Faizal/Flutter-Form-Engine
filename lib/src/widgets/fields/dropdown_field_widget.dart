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

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        DropdownButtonFormField<dynamic>(
          initialValue: value,
          isExpanded: true,
          decoration: InputDecoration(
            labelText: schema.label,
            hintText: schema.hint,
            errorText: error,
          ),
          onTap: () {},
          items: options
              .map(
                (o) => DropdownMenuItem<dynamic>(
                  value: o.value,
                  child: Text(o.label),
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
