enum FieldType {
  text,
  number,
  email,
  phone,
  password,
  dropdown,
  searchableDropdown,
  multiSelect,
  radio,
  checkbox,
  date,
  time,
  custom;

  static FieldType fromString(String value) {
    return FieldType.values.firstWhere(
      (e) => e.name == value,
      orElse: () => throw ArgumentError('Unknown FieldType: "$value"'),
    );
  }
}
