import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'base_field_widget.dart';

/// Date field that opens a platform date picker on tap.
///
/// Stored value is a [DateTime] at local midnight for the selected day.
class DateFieldWidget extends BaseFieldWidget {
  const DateFieldWidget({
    super.key,
    required super.schema,
    required super.value,
    required super.error,
    required super.enabled,
    required super.onChanged,
    required super.onFocusLost,
    required super.resolvedOptions,
  });

  DateTime? get _dateValue => value is DateTime ? value as DateTime : null;

  String _formatDate(DateTime date) {
    final pattern = schema.dateFormat ?? 'yyyy-MM-dd';
    return DateFormat(pattern).format(date);
  }

  Future<void> _pickDate(BuildContext context) async {
    final now = DateTime.now();
    final initial = _dateValue ?? now;
    final firstDate = schema.minDate ?? DateTime(1900);
    final lastDate = schema.maxDate ?? DateTime(now.year + 100);

    final picked = await showDatePicker(
      context: context,
      initialDate: initial.isBefore(firstDate)
          ? firstDate
          : (initial.isAfter(lastDate) ? lastDate : initial),
      firstDate: firstDate,
      lastDate: lastDate,
    );

    if (picked != null) {
      onChanged(DateTime(picked.year, picked.month, picked.day));
      onFocusLost();
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final displayText = _dateValue != null ? _formatDate(_dateValue!) : null;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        InkWell(
          onTap: enabled ? () => _pickDate(context) : null,
          child: InputDecorator(
            decoration: InputDecoration(
              labelText: schema.label,
              hintText: schema.hint ?? schema.dateFormat ?? 'yyyy-MM-dd',
              errorText: error,
              suffixIcon: const Icon(Icons.calendar_today_outlined),
            ).applyDefaults(theme.inputDecorationTheme),
            child: Text(
              displayText ?? '',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: displayText == null ? theme.hintColor : null,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
