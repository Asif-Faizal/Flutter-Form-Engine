import 'package:flutter/material.dart';

import '../../models/field_type.dart';
import 'base_field_widget.dart';

class TextFieldWidget extends BaseFieldWidget {
  const TextFieldWidget({
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
    return Focus(
      onFocusChange: (hasFocus) {
        if (!hasFocus) onFocusLost();
      },
      child: TextFormField(
        initialValue: value?.toString(),
        enabled: enabled,
        obscureText: schema.type == FieldType.password,
        keyboardType: schema.keyboardType,
        maxLength: schema.maxLength,
        style: Theme.of(context).textTheme.bodyMedium,
        decoration: InputDecoration(
          labelText: schema.label,
          hintText: schema.hint,
          errorText: error,
          counterText: schema.maxLength != null ? null : '',
        ).applyDefaults(Theme.of(context).inputDecorationTheme),
        onChanged: onChanged,
      ),
    );
  }
}
