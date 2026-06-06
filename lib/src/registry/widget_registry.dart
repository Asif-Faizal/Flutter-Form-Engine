import 'package:flutter/widgets.dart';

import '../models/field_option.dart';
import '../models/field_schema.dart';
import '../models/field_type.dart';

/// Function signature every field widget builder must match.
typedef FieldWidgetBuilder = Widget Function({
  required FieldSchema schema,
  required dynamic value,
  required String? error,
  required bool enabled,
  required ValueChanged<dynamic> onChanged,
  required VoidCallback onFocusLost,
  required List<FieldOption> resolvedOptions,
});

/// Central registry mapping [FieldType] → [FieldWidgetBuilder].
///
/// Built-in types are registered by [FormEngineLocator].
/// Consumers can override built-ins or register new types by calling
/// [register] before mounting the first [FormEngineWidget].
class WidgetRegistry {
  WidgetRegistry();

  final Map<FieldType, FieldWidgetBuilder> _builders = {};

  void register(FieldType type, FieldWidgetBuilder builder) {
    _builders[type] = builder;
  }

  void registerAll(Map<FieldType, FieldWidgetBuilder> builders) {
    builders.forEach(register);
  }

  void unregister(FieldType type) {
    _builders.remove(type);
  }

  Widget build({
    required FieldSchema schema,
    required dynamic value,
    required String? error,
    required bool enabled,
    required ValueChanged<dynamic> onChanged,
    required VoidCallback onFocusLost,
    required List<FieldOption> resolvedOptions,
  }) {
    final builder = _builders[schema.type];
    assert(
      builder != null,
      'No widget registered for FieldType.${schema.type}. '
      'Call WidgetRegistry.register() before using this type.',
    );
    return builder!(
      schema: schema,
      value: value,
      error: error,
      enabled: enabled,
      onChanged: onChanged,
      onFocusLost: onFocusLost,
      resolvedOptions: resolvedOptions,
    );
  }

  bool isRegistered(FieldType type) => _builders.containsKey(type);
}
