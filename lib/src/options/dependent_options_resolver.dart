import '../models/field_option.dart';
import '../models/field_schema.dart';
import '../models/form_schema.dart';

/// Resolves dropdown options for fields that depend on another field's value
/// via [FieldSchema.optionsSourceKey].
class DependentOptionsResolver {
  const DependentOptionsResolver();

  List<FieldOption> resolve({
    required FieldSchema field,
    required Map<String, dynamic> values,
    List<FieldOption>? remoteOptions,
  }) {
    if (remoteOptions != null && remoteOptions.isNotEmpty) {
      return remoteOptions;
    }

    final sourceKey = field.optionsSourceKey;
    if (sourceKey == null) {
      return field.options;
    }

    final sourceValue = values[sourceKey];
    if (sourceValue == null || sourceValue.toString().isEmpty) {
      return const [];
    }

    final sourceKeyString = sourceValue.toString();

    final optionsBySource = field.extra['optionsBySource'];
    if (optionsBySource is Map) {
      final grouped = optionsBySource[sourceKeyString];
      if (grouped is List) {
        return grouped
            .map((e) => FieldOption.fromMap(e as Map<String, dynamic>))
            .toList();
      }
    }

    return field.options
        .where(
          (option) =>
              option.when == null || option.when.toString() == sourceKeyString,
        )
        .toList();
  }

  /// Removes selections that are no longer valid after [changedKey] updates.
  Map<String, dynamic> clearStaleDependentValues(
    FormSchema schema,
    Map<String, dynamic> values,
    String changedKey,
  ) {
    final result = Map<String, dynamic>.from(values);
    final queue = <String>[changedKey];
    final visited = <String>{};

    while (queue.isNotEmpty) {
      final parentKey = queue.removeAt(0);
      if (!visited.add(parentKey)) continue;

      for (final field in schema.fields) {
        if (field.optionsSourceKey != parentKey) continue;

        final options = resolve(field: field, values: result);
        final current = result[field.key];

        if (current != null && !_containsValue(options, current)) {
          result.remove(field.key);
          queue.add(field.key);
        }
      }
    }

    return result;
  }

  bool _containsValue(List<FieldOption> options, dynamic value) {
    return options.any((option) => option.value == value);
  }
}
