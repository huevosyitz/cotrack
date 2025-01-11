import 'package:cotrack/themes/themes.dart';
import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

abstract final class AppTheme {
  // The defined light theme.
  static ThemeData light = FlexThemeData.light(
    scheme: FlexScheme.greenM3,
    subThemesData: const FlexSubThemesData(
      interactionEffects: true,
      tintedDisabledControls: true,
      useM2StyleDividerInM3: true,
      inputDecoratorSchemeColor: SchemeColor.primary,
      inputDecoratorIsFilled: true,
      inputDecoratorIsDense: true,
      inputDecoratorBackgroundAlpha: 10,
      inputDecoratorBorderSchemeColor: SchemeColor.primary,
      inputDecoratorRadius: 10.0,
      inputDecoratorUnfocusedHasBorder: false,
      inputDecoratorFocusedBorderWidth: 1.0,
      inputDecoratorPrefixIconSchemeColor: SchemeColor.onPrimaryFixedVariant,
      alignedDropdown: true,
      navigationRailUseIndicator: true,
      navigationRailLabelType: NavigationRailLabelType.all,
    ),
    visualDensity: FlexColorScheme.comfortablePlatformDensity,
    cupertinoOverrideTheme: const CupertinoThemeData(applyThemeToAll: true),
  );
  // The defined dark theme.
  static ThemeData dark = FlexThemeData.dark(
    scheme: FlexScheme.greenM3,
    subThemesData: const FlexSubThemesData(
      interactionEffects: true,
      tintedDisabledControls: true,
      blendOnColors: true,
      useM2StyleDividerInM3: true,
      inputDecoratorSchemeColor: SchemeColor.primary,
      inputDecoratorIsFilled: true,
      inputDecoratorIsDense: true,
      inputDecoratorBackgroundAlpha: 10,
      inputDecoratorBorderSchemeColor: SchemeColor.primary,
      inputDecoratorRadius: 10.0,
      inputDecoratorUnfocusedHasBorder: false,
      inputDecoratorFocusedBorderWidth: 1.0,
      inputDecoratorPrefixIconSchemeColor: SchemeColor.primaryFixed,
      alignedDropdown: true,
      navigationRailUseIndicator: true,
      navigationRailLabelType: NavigationRailLabelType.all,
    ),
    visualDensity: FlexColorScheme.comfortablePlatformDensity,
    cupertinoOverrideTheme: const CupertinoThemeData(applyThemeToAll: true),
  );
}

class yTheme {
  yTheme._();

  static ThemeData dark = ThemeData.dark(useMaterial3: true).copyWith(
    colorScheme: ColorScheme.fromSeed(
      seedColor: yColors.primary,
      surface: yColors.background,
      onSurface: yColors.primaryText,
      // onSurfaceVariant: yColors.primaryText,
      surfaceDim: yColors.background2,
      // // surfaceDim: Colors.red,
      // // scrim: Colors.red,
      // outlineVariant: yColors.background3
      // // surfaceContainer: Colors.red,
    ),
    primaryColor: yColors.primary,
    primaryColorDark: yColors.primary,
    scaffoldBackgroundColor: yColors.background,
    textTheme: GoogleFonts.latoTextTheme(ThemeData.dark().textTheme),
    splashFactory: NoSplash.splashFactory,
    appBarTheme:
        const AppBarTheme(backgroundColor: Colors.transparent, titleSpacing: 0),
    inputDecorationTheme: InputDecorationTheme(
      focusColor: yColors.primary,
      contentPadding: const EdgeInsets.all(16),
      focusedBorder: _buildBorder(yColors.primary),
      enabledBorder: _buildBorder(yColors.background3),
      fillColor: yColors.background2,
      filled: true,
      prefixIconColor: yColors.background4,
      hintStyle: const TextStyle(
        fontSize: 15,
        color: yColors.background4,
      ),
    ),
    listTileTheme: const ListTileThemeData(
      subtitleTextStyle: TextStyle(color: yColors.primaryTextFade1),
    ),
    dividerTheme: const DividerThemeData(
      color: yColors.background2,
      thickness: 1,
      space: 0,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: yColors.primary,
        foregroundColor: yColors.primaryText,
      ),
    ),
    progressIndicatorTheme: const ProgressIndicatorThemeData(
      color: yColors.primary,
    ),
  );

  static OutlineInputBorder _buildBorder(Color color) {
    return OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide(color: color));
  }
}
