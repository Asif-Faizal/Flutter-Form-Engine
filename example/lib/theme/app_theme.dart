import 'package:flutter/material.dart';
import 'package:flutter_form_engine/flutter_form_engine.dart';

/// IBM Carbon Design System theme — single source of truth for the example app
/// and the form engine package.
abstract final class AppTheme {
  /// Shared form-engine theme passed once via [FormEngineLocator.setup].
  static const formEngineTheme = FormEngineTheme(
    primaryColor: Color(0xFF0F62FE),
    secondaryColor: Color(0xFF393939),
    errorColor: Color(0xFFDA1E28),
    surfaceColor: Color(0xFFFFFFFF),
    onPrimaryColor: Color(0xFFFFFFFF),
    onSecondaryColor: Color(0xFFFFFFFF),
    onSurfaceColor: Color(0xFF161616),
    labelColor: Color(0xFF525252),
    hintColor: Color(0xFF6F6F6F),
    borderColor: Color(0xFF8D8D8D),
    focusColor: Color(0xFF0F62FE),
    successColor: Color(0xFF24A148),
    disabledColor: Color(0xFFC6C6C6),
    borderRadius: BorderRadius.zero,
    fontFamily: 'IBMPlexSans',
    fontSizeBody: 14,
    fontSizeLabel: 12,
    fontSizeHint: 12,
  );

  /// Material theme for the host app — derived from the same Carbon tokens.
  static ThemeData get materialTheme =>
      FormEngineThemeApplicator.applyForApp(formEngineTheme);
}
