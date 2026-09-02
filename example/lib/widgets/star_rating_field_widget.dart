import 'package:flutter/material.dart';
import 'package:flutter_form_engine/flutter_form_engine.dart';

/// Example custom field: star rating widget driven by `extra.widgetId`.
class StarRatingFieldWidget extends BaseFieldWidget {
  const StarRatingFieldWidget({
    super.key,
    required super.schema,
    required super.value,
    required super.error,
    required super.enabled,
    required super.onChanged,
    required super.onFocusLost,
    required super.resolvedOptions,
  });

  int get _maxStars => (schema.extra['maxStars'] as int?) ?? 5;
  int get _rating => value is int ? value as int : 0;

  @override
  Widget build(BuildContext context) {
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
        const SizedBox(height: 8),
        Row(
          children: List.generate(_maxStars, (index) {
            final star = index + 1;
            final filled = star <= _rating;
            return IconButton(
              onPressed: enabled
                  ? () {
                      onChanged(star);
                      onFocusLost();
                    }
                  : null,
              icon: Icon(
                filled ? Icons.star : Icons.star_border,
                color: filled
                    ? FormEngineLocator.theme.primaryColor
                    : theme.disabledColor,
              ),
            );
          }),
        ),
        if (error != null)
          Text(
            error!,
            style: theme.inputDecorationTheme.errorStyle,
          ),
      ],
    );
  }
}
