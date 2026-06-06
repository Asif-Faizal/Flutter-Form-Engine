import 'package:flutter/material.dart';

import 'form_engine_theme.dart';

/// Converts a [FormEngineTheme] into a [ThemeData] subtree for form widgets.
abstract final class FormEngineThemeApplicator {
  static ThemeData apply(FormEngineTheme theme) {
    final colorScheme = ColorScheme.light(
      primary: theme.primaryColor,
      onPrimary: theme.onPrimaryColor,
      secondary: theme.secondaryColor,
      onSecondary: theme.onSecondaryColor,
      error: theme.errorColor,
      onError: theme.onPrimaryColor,
      surface: theme.surfaceColor,
      onSurface: theme.onSurfaceColor,
    );

    final borderSide = BorderSide(color: theme.borderColor);
    final focusedBorderSide = BorderSide(color: theme.focusColor, width: 2);
    final errorBorderSide = BorderSide(color: theme.errorColor, width: 2);

    OutlineInputBorder outlineBorder({BorderSide? side}) {
      return OutlineInputBorder(
        borderRadius: theme.borderRadius,
        borderSide: side ?? borderSide,
      );
    }

    final textStyleBase = TextStyle(
      fontFamily: theme.fontFamily,
      color: theme.onSurfaceColor,
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      fontFamily: theme.fontFamily,
      textTheme: TextTheme(
        bodyMedium: textStyleBase.copyWith(fontSize: theme.fontSizeBody),
        bodySmall: textStyleBase.copyWith(fontSize: theme.fontSizeHint),
        labelLarge: textStyleBase.copyWith(
          fontSize: theme.fontSizeLabel,
          fontWeight: FontWeight.w400,
          color: theme.labelColor,
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: theme.surfaceColor,
        labelStyle: TextStyle(
          fontFamily: theme.fontFamily,
          fontSize: theme.fontSizeLabel,
          color: theme.labelColor,
        ),
        hintStyle: TextStyle(
          fontFamily: theme.fontFamily,
          fontSize: theme.fontSizeHint,
          color: theme.hintColor,
        ),
        errorStyle: TextStyle(
          fontFamily: theme.fontFamily,
          fontSize: theme.fontSizeHint,
          color: theme.errorColor,
        ),
        floatingLabelStyle: TextStyle(
          fontFamily: theme.fontFamily,
          fontSize: theme.fontSizeLabel,
          color: theme.labelColor,
        ),
        border: outlineBorder(),
        enabledBorder: outlineBorder(),
        focusedBorder: outlineBorder(side: focusedBorderSide),
        errorBorder: outlineBorder(side: errorBorderSide),
        focusedErrorBorder: outlineBorder(side: errorBorderSide),
        disabledBorder: outlineBorder(
          side: BorderSide(color: theme.disabledColor),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 14,
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: theme.primaryColor,
          foregroundColor: theme.onPrimaryColor,
          disabledBackgroundColor: theme.disabledColor,
          disabledForegroundColor: theme.onPrimaryColor,
          shape: RoundedRectangleBorder(borderRadius: theme.borderRadius),
          textStyle: TextStyle(
            fontFamily: theme.fontFamily,
            fontSize: theme.fontSizeBody,
            fontWeight: FontWeight.w400,
          ),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: theme.primaryColor,
          side: BorderSide(color: theme.primaryColor),
          shape: RoundedRectangleBorder(borderRadius: theme.borderRadius),
          textStyle: TextStyle(
            fontFamily: theme.fontFamily,
            fontSize: theme.fontSizeBody,
            fontWeight: FontWeight.w400,
          ),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        ),
      ),
      dropdownMenuTheme: DropdownMenuThemeData(
        textStyle: textStyleBase.copyWith(fontSize: theme.fontSizeBody),
      ),
      progressIndicatorTheme: ProgressIndicatorThemeData(
        color: theme.primaryColor,
      ),
    );
  }

  /// Builds a full [ThemeData] for the host app from the same [FormEngineTheme].
  static ThemeData applyForApp(FormEngineTheme theme) {
    final formTheme = apply(theme);

    return formTheme.copyWith(
      scaffoldBackgroundColor: theme.surfaceColor,
      appBarTheme: AppBarTheme(
        backgroundColor: theme.surfaceColor,
        foregroundColor: theme.onSurfaceColor,
        elevation: 0,
        scrolledUnderElevation: 0,
        titleTextStyle: TextStyle(
          fontFamily: theme.fontFamily,
          fontSize: 16,
          fontWeight: FontWeight.w400,
          color: theme.onSurfaceColor,
        ),
        shape: RoundedRectangleBorder(borderRadius: theme.borderRadius),
      ),
      cardTheme: CardThemeData(
        color: theme.surfaceColor,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: theme.borderRadius,
          side: BorderSide(color: theme.borderColor),
        ),
        margin: EdgeInsets.zero,
      ),
      listTileTheme: ListTileThemeData(
        titleTextStyle: TextStyle(
          fontFamily: theme.fontFamily,
          fontSize: theme.fontSizeBody,
          color: theme.onSurfaceColor,
        ),
        subtitleTextStyle: TextStyle(
          fontFamily: theme.fontFamily,
          fontSize: theme.fontSizeHint,
          color: theme.labelColor,
        ),
        shape: RoundedRectangleBorder(borderRadius: theme.borderRadius),
      ),
    );
  }
}
