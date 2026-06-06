import 'package:equatable/equatable.dart';

class FieldOption extends Equatable {
  const FieldOption({required this.label, required this.value});

  final String label;
  final dynamic value;

  factory FieldOption.fromMap(Map<String, dynamic> map) {
    return FieldOption(
      label: map['label'] as String,
      value: map['value'],
    );
  }

  Map<String, dynamic> toMap() => {'label': label, 'value': value};

  @override
  List<Object?> get props => [label, value];
}
