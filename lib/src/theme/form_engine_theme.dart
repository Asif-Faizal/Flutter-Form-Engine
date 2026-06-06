import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

/// Centralized visual configuration for all form-engine widgets.
///
/// Pass once via [FormEngineLocator.setup] — field widgets read it
/// automatically through the [Theme] applied by [FormEngineWidget].
class FormEngineTheme extends Equatable {
  const FormEngineTheme({
    required this.primaryColor,
    required this.secondaryColor,
    required this.errorColor,
    required this.surfaceColor,
    required this.onPrimaryColor,
    required this.onSecondaryColor,
    required this.onSurfaceColor,
    required this.labelColor,
    required this.hintColor,
    required this.borderColor,
    required this.focusColor,
    required this.successColor,
    this.disabledColor = const Color(0xFFC6C6C6),
    this.borderRadius = BorderRadius.zero,
    this.fontFamily,
    this.fontSizeBody = 14,
    this.fontSizeLabel = 12,
    this.fontSizeHint = 12,
  });

  final Color primaryColor;
  final Color secondaryColor;
  final Color errorColor;
  final Color surfaceColor;
  final Color onPrimaryColor;
  final Color onSecondaryColor;
  final Color onSurfaceColor;
  final Color labelColor;
  final Color hintColor;
  final Color borderColor;
  final Color focusColor;
  final Color successColor;
  final Color disabledColor;
  final BorderRadius borderRadius;
  final String? fontFamily;
  final double fontSizeBody;
  final double fontSizeLabel;
  final double fontSizeHint;

  /// IBM Carbon Design System defaults (light mode).
  factory FormEngineTheme.carbon({String? fontFamily}) {
    return FormEngineTheme(
      primaryColor: const Color(0xFF0F62FE),
      secondaryColor: const Color(0xFF393939),
      errorColor: const Color(0xFFDA1E28),
      surfaceColor: const Color(0xFFFFFFFF),
      onPrimaryColor: const Color(0xFFFFFFFF),
      onSecondaryColor: const Color(0xFFFFFFFF),
      onSurfaceColor: const Color(0xFF161616),
      labelColor: const Color(0xFF525252),
      hintColor: const Color(0xFF6F6F6F),
      borderColor: const Color(0xFF8D8D8D),
      focusColor: const Color(0xFF0F62FE),
      successColor: const Color(0xFF24A148),
      fontFamily: fontFamily,
    );
  }

  FormEngineTheme copyWith({
    Color? primaryColor,
    Color? secondaryColor,
    Color? errorColor,
    Color? surfaceColor,
    Color? onPrimaryColor,
    Color? onSecondaryColor,
    Color? onSurfaceColor,
    Color? labelColor,
    Color? hintColor,
    Color? borderColor,
    Color? focusColor,
    Color? successColor,
    Color? disabledColor,
    BorderRadius? borderRadius,
    String? fontFamily,
    double? fontSizeBody,
    double? fontSizeLabel,
    double? fontSizeHint,
  }) {
    return FormEngineTheme(
      primaryColor: primaryColor ?? this.primaryColor,
      secondaryColor: secondaryColor ?? this.secondaryColor,
      errorColor: errorColor ?? this.errorColor,
      surfaceColor: surfaceColor ?? this.surfaceColor,
      onPrimaryColor: onPrimaryColor ?? this.onPrimaryColor,
      onSecondaryColor: onSecondaryColor ?? this.onSecondaryColor,
      onSurfaceColor: onSurfaceColor ?? this.onSurfaceColor,
      labelColor: labelColor ?? this.labelColor,
      hintColor: hintColor ?? this.hintColor,
      borderColor: borderColor ?? this.borderColor,
      focusColor: focusColor ?? this.focusColor,
      successColor: successColor ?? this.successColor,
      disabledColor: disabledColor ?? this.disabledColor,
      borderRadius: borderRadius ?? this.borderRadius,
      fontFamily: fontFamily ?? this.fontFamily,
      fontSizeBody: fontSizeBody ?? this.fontSizeBody,
      fontSizeLabel: fontSizeLabel ?? this.fontSizeLabel,
      fontSizeHint: fontSizeHint ?? this.fontSizeHint,
    );
  }

  @override
  List<Object?> get props => [
        primaryColor,
        secondaryColor,
        errorColor,
        surfaceColor,
        borderRadius,
        fontFamily,
      ];
}
