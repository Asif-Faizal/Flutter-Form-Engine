import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'base_field_widget.dart';

/// Time field that opens a platform time picker on tap.
///
/// Stored value is a [DateTime] anchored to 1970-01-01 with the selected time.
class TimeFieldWidget extends BaseFieldWidget {
  const TimeFieldWidget({
    super.key,
    required super.schema,
    required super.value,
    required super.error,
    required super.enabled,
    required super.onChanged,
    required super.onFocusLost,
    required super.resolvedOptions,
  });

  TimeOfDay? get _timeValue {
    if (value is DateTime) {
      final date = value as DateTime;
      return TimeOfDay(hour: date.hour, minute: date.minute);
    }
    return null;
  }

  String _formatTime(TimeOfDay time) {
    final pattern = schema.use24Hour ? 'HH:mm' : 'h:mm a';
    final date = DateTime(1970, 1, 1, time.hour, time.minute);
    return DateFormat(pattern).format(date);
  }

  Future<void> _pickTime(BuildContext context) async {
    final picked = await showTimePicker(
      context: context,
      initialTime: _timeValue ?? TimeOfDay.now(),
      builder: (context, child) {
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(
            alwaysUse24HourFormat: schema.use24Hour,
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      onChanged(DateTime(1970, 1, 1, picked.hour, picked.minute));
      onFocusLost();
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final time = _timeValue;
    final displayText = time != null ? _formatTime(time) : null;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        InkWell(
          onTap: enabled ? () => _pickTime(context) : null,
          child: InputDecorator(
            decoration: InputDecoration(
              labelText: schema.label,
              hintText: schema.hint ??
                  (schema.use24Hour ? 'HH:mm' : 'h:mm AM/PM'),
              errorText: error,
              suffixIcon: const Icon(Icons.access_time_outlined),
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
