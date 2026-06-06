import 'package:equatable/equatable.dart';

class FieldOption extends Equatable {
  const FieldOption({
    required this.label,
    required this.value,
    this.when,
  });

  final String label;
  final dynamic value;

  /// When set, this option is only shown if [FieldSchema.optionsSourceKey]
  /// field equals this value.
  final dynamic when;

  factory FieldOption.fromMap(Map<String, dynamic> map) {
    return FieldOption(
      label: map['label'] as String,
      value: map['value'],
      when: map['when'],
    );
  }

  Map<String, dynamic> toMap() => {
        'label': label,
        'value': value,
        if (when != null) 'when': when,
      };

  @override
  List<Object?> get props => [label, value, when];
}
