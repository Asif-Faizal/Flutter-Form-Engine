import 'package:flutter/material.dart';

import '../../models/field_option.dart';
import 'base_field_widget.dart';

/// Single-select dropdown with a type-to-filter search box.
class SearchableDropdownFieldWidget extends BaseFieldWidget {
  const SearchableDropdownFieldWidget({
    super.key,
    required super.schema,
    required super.value,
    required super.error,
    required super.enabled,
    required super.onChanged,
    required super.onFocusLost,
    required super.resolvedOptions,
  });

  List<FieldOption> get _options =>
      resolvedOptions.isNotEmpty ? resolvedOptions : schema.options;

  FieldOption? _optionForValue(dynamic selected) {
    for (final option in _options) {
      if (option.value == selected) return option;
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final selected = _optionForValue(value);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Autocomplete<FieldOption>(
          initialValue: selected != null
              ? TextEditingValue(text: selected.label)
              : null,
          displayStringForOption: (option) => option.label,
          optionsBuilder: (query) {
            final normalized = query.text.trim().toLowerCase();
            if (normalized.isEmpty) return _options;
            return _options.where(
              (option) => option.label.toLowerCase().contains(normalized),
            );
          },
          onSelected: enabled
              ? (option) {
                  onChanged(option.value);
                  onFocusLost();
                }
              : null,
          fieldViewBuilder: (context, controller, focusNode, onFieldSubmitted) {
            return TextFormField(
              controller: controller,
              focusNode: focusNode,
              enabled: enabled,
              style: theme.textTheme.bodyMedium,
              decoration: InputDecoration(
                labelText: schema.label,
                hintText: schema.hint ?? 'Type to search…',
                errorText: error,
                suffixIcon: const Icon(Icons.search),
              ).applyDefaults(theme.inputDecorationTheme),
              onFieldSubmitted: (_) => onFieldSubmitted(),
            );
          },
          optionsViewBuilder: (context, onSelected, options) {
            return Align(
              alignment: Alignment.topLeft,
              child: Material(
                elevation: 4,
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxHeight: 200),
                  child: ListView.builder(
                    padding: EdgeInsets.zero,
                    shrinkWrap: true,
                    itemCount: options.length,
                    itemBuilder: (context, index) {
                      final option = options.elementAt(index);
                      return ListTile(
                        title: Text(
                          option.label,
                          style: theme.textTheme.bodyMedium,
                        ),
                        onTap: enabled ? () => onSelected(option) : null,
                      );
                    },
                  ),
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}
