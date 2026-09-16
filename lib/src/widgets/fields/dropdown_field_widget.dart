import 'package:flutter/material.dart';

import '../../di/form_engine_locator.dart';
import '../../models/field_option.dart';
import '../../models/field_schema.dart';
import 'form_engine_dropdown_overlay.dart';

class DropdownFieldWidget extends StatefulWidget {
  const DropdownFieldWidget({
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
  final List<FieldOption> resolvedOptions;

  @override
  State<DropdownFieldWidget> createState() => _DropdownFieldWidgetState();
}

class _DropdownFieldWidgetState extends State<DropdownFieldWidget> {
  final _anchorKey = GlobalKey();
  var _isOpen = false;

  List<FieldOption> get _options =>
      widget.resolvedOptions.isNotEmpty
          ? widget.resolvedOptions
          : widget.schema.options;

  dynamic get _selectedValue {
    final optionValues = _options.map((option) => option.value).toSet();
    return optionValues.contains(widget.value) ? widget.value : null;
  }

  String? get _displayLabel {
    if (_selectedValue == null) return null;
    for (final option in _options) {
      if (option.value == _selectedValue) return option.label;
    }
    return null;
  }

  InputDecoration _decoration(BuildContext context) {
    final base = InputDecoration(
      labelText: widget.schema.label,
      hintText: widget.schema.hint,
      errorText: widget.error,
    ).applyDefaults(Theme.of(context).inputDecorationTheme);

    return base;
  }

  Future<void> _openMenu() async {
    if (!widget.enabled || _options.isEmpty) return;

    setState(() => _isOpen = true);

    await FormEngineDropdownOverlay.show(
      anchorKey: _anchorKey,
      options: _options,
      selectedValue: _selectedValue,
      onSelected: (selected) {
        widget.onChanged(selected);
        widget.onFocusLost();
      },
      onDismissed: () {
        if (mounted) setState(() => _isOpen = false);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = FormEngineLocator.theme;
    final displayLabel = _displayLabel;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: [
        InputDecorator(
          key: _anchorKey,
          decoration: _decoration(context),
          isEmpty: displayLabel == null,
          child: InkWell(
            onTap: widget.enabled ? _openMenu : null,
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    displayLabel ?? widget.schema.hint ?? '',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: displayLabel == null
                              ? theme.hintColor
                              : theme.onSurfaceColor,
                        ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                AnimatedRotation(
                  turns: _isOpen ? 0.5 : 0,
                  duration: const Duration(milliseconds: 220),
                  curve: Curves.easeOutCubic,
                  child: Icon(
                    Icons.keyboard_arrow_down,
                    color: theme.onSurfaceColor,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}