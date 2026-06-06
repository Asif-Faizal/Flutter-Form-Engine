import 'package:flutter/widgets.dart';

import '../../models/field_option.dart';
import '../../models/field_schema.dart';

/// Every field widget receives exactly this contract.
abstract class BaseFieldWidget extends StatelessWidget {
  const BaseFieldWidget({
    super.key,
    required this.schema,
    required this.value,
    required this.error,
    required this.enabled,
    required this.onChanged,
    required this.onFocusLost,
    required this.resolvedOptions,
  });

  final FieldSchema schema;
  final dynamic value;
  final String? error;
  final bool enabled;
  final ValueChanged<dynamic> onChanged;
  final VoidCallback onFocusLost;

  /// Static options from schema merged with any dynamically loaded options.
  final List<FieldOption> resolvedOptions;
}
