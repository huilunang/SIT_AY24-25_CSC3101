import "package:flutter/material.dart";

class MaterialTheme {
  final TextTheme textTheme;

  const MaterialTheme(this.textTheme);

  static ColorScheme lightScheme() {
    return const ColorScheme(
      brightness: Brightness.light,
      primary: Color(0xff31628d),
      surfaceTint: Color(0xff31628d),
      onPrimary: Color(0xffffffff),
      primaryContainer: Color(0xffcfe5ff),
      onPrimaryContainer: Color(0xff001d34),
      secondary: Color(0xff526070),
      onSecondary: Color(0xffffffff),
      secondaryContainer: Color(0xffd5e4f7),
      onSecondaryContainer: Color(0xff0e1d2a),
      tertiary: Color(0xff435e91),
      onTertiary: Color(0xffffffff),
      tertiaryContainer: Color(0xffd8e2ff),
      onTertiaryContainer: Color(0xff001a41),
      error: Color(0xffba1a1a),
      onError: Color(0xffffffff),
      errorContainer: Color(0xffffdad6),
      onErrorContainer: Color(0xff410002),
      surface: Color(0xfff7f9ff),
      onSurface: Color(0xff181c20),
      onSurfaceVariant: Color(0xff42474e),
      outline: Color(0xff72777f),
      outlineVariant: Color(0xffc2c7cf),
      shadow: Color(0xff000000),
      scrim: Color(0xff000000),
      inverseSurface: Color(0xff2d3135),
      inversePrimary: Color(0xff9dcbfb),
      primaryFixed: Color(0xffcfe5ff),
      onPrimaryFixed: Color(0xff001d34),
      primaryFixedDim: Color(0xff9dcbfb),
      onPrimaryFixedVariant: Color(0xff124a73),
      secondaryFixed: Color(0xffd5e4f7),
      onSecondaryFixed: Color(0xff0e1d2a),
      secondaryFixedDim: Color(0xffb9c8da),
      onSecondaryFixedVariant: Color(0xff3a4857),
      tertiaryFixed: Color(0xffd8e2ff),
      onTertiaryFixed: Color(0xff001a41),
      tertiaryFixedDim: Color(0xffadc7ff),
      onTertiaryFixedVariant: Color(0xff2a4678),
      surfaceDim: Color(0xffd8dae0),
      surfaceBright: Color(0xfff7f9ff),
      surfaceContainerLowest: Color(0xffffffff),
      surfaceContainerLow: Color(0xfff2f3f9),
      surfaceContainer: Color(0xffeceef4),
      surfaceContainerHigh: Color(0xffe6e8ee),
      surfaceContainerHighest: Color(0xffe0e2e8),
    );
  }

  ThemeData light() {
    return theme(lightScheme());
  }

  static ColorScheme lightMediumContrastScheme() {
    return const ColorScheme(
      brightness: Brightness.light,
      primary: Color(0xff0a466f),
      surfaceTint: Color(0xff31628d),
      onPrimary: Color(0xffffffff),
      primaryContainer: Color(0xff4978a4),
      onPrimaryContainer: Color(0xffffffff),
      secondary: Color(0xff364453),
      onSecondary: Color(0xffffffff),
      secondaryContainer: Color(0xff687686),
      onSecondaryContainer: Color(0xffffffff),
      tertiary: Color(0xff264273),
      onTertiary: Color(0xffffffff),
      tertiaryContainer: Color(0xff5a74a9),
      onTertiaryContainer: Color(0xffffffff),
      error: Color(0xff8c0009),
      onError: Color(0xffffffff),
      errorContainer: Color(0xffda342e),
      onErrorContainer: Color(0xffffffff),
      surface: Color(0xfff7f9ff),
      onSurface: Color(0xff181c20),
      onSurfaceVariant: Color(0xff3e434a),
      outline: Color(0xff5a5f66),
      outlineVariant: Color(0xff767b82),
      shadow: Color(0xff000000),
      scrim: Color(0xff000000),
      inverseSurface: Color(0xff2d3135),
      inversePrimary: Color(0xff9dcbfb),
      primaryFixed: Color(0xff4978a4),
      onPrimaryFixed: Color(0xffffffff),
      primaryFixedDim: Color(0xff2e5f8a),
      onPrimaryFixedVariant: Color(0xffffffff),
      secondaryFixed: Color(0xff687686),
      onSecondaryFixed: Color(0xffffffff),
      secondaryFixedDim: Color(0xff4f5d6d),
      onSecondaryFixedVariant: Color(0xffffffff),
      tertiaryFixed: Color(0xff5a74a9),
      onTertiaryFixed: Color(0xffffffff),
      tertiaryFixedDim: Color(0xff415c8e),
      onTertiaryFixedVariant: Color(0xffffffff),
      surfaceDim: Color(0xffd8dae0),
      surfaceBright: Color(0xfff7f9ff),
      surfaceContainerLowest: Color(0xffffffff),
      surfaceContainerLow: Color(0xfff2f3f9),
      surfaceContainer: Color(0xffeceef4),
      surfaceContainerHigh: Color(0xffe6e8ee),
      surfaceContainerHighest: Color(0xffe0e2e8),
    );
  }

  ThemeData lightMediumContrast() {
    return theme(lightMediumContrastScheme());
  }

  static ColorScheme lightHighContrastScheme() {
    return const ColorScheme(
      brightness: Brightness.light,
      primary: Color(0xff00243e),
      surfaceTint: Color(0xff31628d),
      onPrimary: Color(0xffffffff),
      primaryContainer: Color(0xff0a466f),
      onPrimaryContainer: Color(0xffffffff),
      secondary: Color(0xff152331),
      onSecondary: Color(0xffffffff),
      secondaryContainer: Color(0xff364453),
      onSecondaryContainer: Color(0xffffffff),
      tertiary: Color(0xff00214d),
      onTertiary: Color(0xffffffff),
      tertiaryContainer: Color(0xff264273),
      onTertiaryContainer: Color(0xffffffff),
      error: Color(0xff4e0002),
      onError: Color(0xffffffff),
      errorContainer: Color(0xff8c0009),
      onErrorContainer: Color(0xffffffff),
      surface: Color(0xfff7f9ff),
      onSurface: Color(0xff000000),
      onSurfaceVariant: Color(0xff1f242a),
      outline: Color(0xff3e434a),
      outlineVariant: Color(0xff3e434a),
      shadow: Color(0xff000000),
      scrim: Color(0xff000000),
      inverseSurface: Color(0xff2d3135),
      inversePrimary: Color(0xffe0edff),
      primaryFixed: Color(0xff0a466f),
      onPrimaryFixed: Color(0xffffffff),
      primaryFixedDim: Color(0xff002f4f),
      onPrimaryFixedVariant: Color(0xffffffff),
      secondaryFixed: Color(0xff364453),
      onSecondaryFixed: Color(0xffffffff),
      secondaryFixedDim: Color(0xff202e3c),
      onSecondaryFixedVariant: Color(0xffffffff),
      tertiaryFixed: Color(0xff264273),
      onTertiaryFixed: Color(0xffffffff),
      tertiaryFixedDim: Color(0xff092b5c),
      onTertiaryFixedVariant: Color(0xffffffff),
      surfaceDim: Color(0xffd8dae0),
      surfaceBright: Color(0xfff7f9ff),
      surfaceContainerLowest: Color(0xffffffff),
      surfaceContainerLow: Color(0xfff2f3f9),
      surfaceContainer: Color(0xffeceef4),
      surfaceContainerHigh: Color(0xffe6e8ee),
      surfaceContainerHighest: Color(0xffe0e2e8),
    );
  }

  ThemeData lightHighContrast() {
    return theme(lightHighContrastScheme());
  }

  static ColorScheme darkScheme() {
    return const ColorScheme(
      brightness: Brightness.dark,
      primary: Color(0xff9dcbfb),
      surfaceTint: Color(0xff9dcbfb),
      onPrimary: Color(0xff003355),
      primaryContainer: Color(0xff124a73),
      onPrimaryContainer: Color(0xffcfe5ff),
      secondary: Color(0xffb9c8da),
      onSecondary: Color(0xff243240),
      secondaryContainer: Color(0xff3a4857),
      onSecondaryContainer: Color(0xffd5e4f7),
      tertiary: Color(0xffadc7ff),
      onTertiary: Color(0xff0f2f60),
      tertiaryContainer: Color(0xff2a4678),
      onTertiaryContainer: Color(0xffd8e2ff),
      error: Color(0xffffb4ab),
      onError: Color(0xff690005),
      errorContainer: Color(0xff93000a),
      onErrorContainer: Color(0xffffdad6),
      surface: Color(0xff101418),
      onSurface: Color(0xffe0e2e8),
      onSurfaceVariant: Color(0xffc2c7cf),
      outline: Color(0xff8c9199),
      outlineVariant: Color(0xff42474e),
      shadow: Color(0xff000000),
      scrim: Color(0xff000000),
      inverseSurface: Color(0xffe0e2e8),
      inversePrimary: Color(0xff31628d),
      primaryFixed: Color(0xffcfe5ff),
      onPrimaryFixed: Color(0xff001d34),
      primaryFixedDim: Color(0xff9dcbfb),
      onPrimaryFixedVariant: Color(0xff124a73),
      secondaryFixed: Color(0xffd5e4f7),
      onSecondaryFixed: Color(0xff0e1d2a),
      secondaryFixedDim: Color(0xffb9c8da),
      onSecondaryFixedVariant: Color(0xff3a4857),
      tertiaryFixed: Color(0xffd8e2ff),
      onTertiaryFixed: Color(0xff001a41),
      tertiaryFixedDim: Color(0xffadc7ff),
      onTertiaryFixedVariant: Color(0xff2a4678),
      surfaceDim: Color(0xff101418),
      surfaceBright: Color(0xff36393e),
      surfaceContainerLowest: Color(0xff0b0e12),
      surfaceContainerLow: Color(0xff181c20),
      surfaceContainer: Color(0xff1d2024),
      surfaceContainerHigh: Color(0xff272a2f),
      surfaceContainerHighest: Color(0xff32353a),
    );
  }

  ThemeData dark() {
    return theme(darkScheme());
  }

  static ColorScheme darkMediumContrastScheme() {
    return const ColorScheme(
      brightness: Brightness.dark,
      primary: Color(0xffa2cfff),
      surfaceTint: Color(0xff9dcbfb),
      onPrimary: Color(0xff00182b),
      primaryContainer: Color(0xff6795c2),
      onPrimaryContainer: Color(0xff000000),
      secondary: Color(0xffbeccdf),
      onSecondary: Color(0xff091725),
      secondaryContainer: Color(0xff8492a3),
      onSecondaryContainer: Color(0xff000000),
      tertiary: Color(0xffb3cbff),
      onTertiary: Color(0xff001537),
      tertiaryContainer: Color(0xff7691c7),
      onTertiaryContainer: Color(0xff000000),
      error: Color(0xffffbab1),
      onError: Color(0xff370001),
      errorContainer: Color(0xffff5449),
      onErrorContainer: Color(0xff000000),
      surface: Color(0xff101418),
      onSurface: Color(0xfffafaff),
      onSurfaceVariant: Color(0xffc6cbd3),
      outline: Color(0xff9ea3ab),
      outlineVariant: Color(0xff7f838b),
      shadow: Color(0xff000000),
      scrim: Color(0xff000000),
      inverseSurface: Color(0xffe0e2e8),
      inversePrimary: Color(0xff144b75),
      primaryFixed: Color(0xffcfe5ff),
      onPrimaryFixed: Color(0xff001223),
      primaryFixedDim: Color(0xff9dcbfb),
      onPrimaryFixedVariant: Color(0xff00395e),
      secondaryFixed: Color(0xffd5e4f7),
      onSecondaryFixed: Color(0xff04121f),
      secondaryFixedDim: Color(0xffb9c8da),
      onSecondaryFixedVariant: Color(0xff2a3746),
      tertiaryFixed: Color(0xffd8e2ff),
      onTertiaryFixed: Color(0xff00102d),
      tertiaryFixedDim: Color(0xffadc7ff),
      onTertiaryFixedVariant: Color(0xff173566),
      surfaceDim: Color(0xff101418),
      surfaceBright: Color(0xff36393e),
      surfaceContainerLowest: Color(0xff0b0e12),
      surfaceContainerLow: Color(0xff181c20),
      surfaceContainer: Color(0xff1d2024),
      surfaceContainerHigh: Color(0xff272a2f),
      surfaceContainerHighest: Color(0xff32353a),
    );
  }

  ThemeData darkMediumContrast() {
    return theme(darkMediumContrastScheme());
  }

  static ColorScheme darkHighContrastScheme() {
    return const ColorScheme(
      brightness: Brightness.dark,
      primary: Color(0xfffafaff),
      surfaceTint: Color(0xff9dcbfb),
      onPrimary: Color(0xff000000),
      primaryContainer: Color(0xffa2cfff),
      onPrimaryContainer: Color(0xff000000),
      secondary: Color(0xfffafaff),
      onSecondary: Color(0xff000000),
      secondaryContainer: Color(0xffbeccdf),
      onSecondaryContainer: Color(0xff000000),
      tertiary: Color(0xfffbfaff),
      onTertiary: Color(0xff000000),
      tertiaryContainer: Color(0xffb3cbff),
      onTertiaryContainer: Color(0xff000000),
      error: Color(0xfffff9f9),
      onError: Color(0xff000000),
      errorContainer: Color(0xffffbab1),
      onErrorContainer: Color(0xff000000),
      surface: Color(0xff101418),
      onSurface: Color(0xffffffff),
      onSurfaceVariant: Color(0xfffafaff),
      outline: Color(0xffc6cbd3),
      outlineVariant: Color(0xffc6cbd3),
      shadow: Color(0xff000000),
      scrim: Color(0xff000000),
      inverseSurface: Color(0xffe0e2e8),
      inversePrimary: Color(0xff002c4a),
      primaryFixed: Color(0xffd7e9ff),
      onPrimaryFixed: Color(0xff000000),
      primaryFixedDim: Color(0xffa2cfff),
      onPrimaryFixedVariant: Color(0xff00182b),
      secondaryFixed: Color(0xffdae8fb),
      onSecondaryFixed: Color(0xff000000),
      secondaryFixedDim: Color(0xffbeccdf),
      onSecondaryFixedVariant: Color(0xff091725),
      tertiaryFixed: Color(0xffdee7ff),
      onTertiaryFixed: Color(0xff000000),
      tertiaryFixedDim: Color(0xffb3cbff),
      onTertiaryFixedVariant: Color(0xff001537),
      surfaceDim: Color(0xff101418),
      surfaceBright: Color(0xff36393e),
      surfaceContainerLowest: Color(0xff0b0e12),
      surfaceContainerLow: Color(0xff181c20),
      surfaceContainer: Color(0xff1d2024),
      surfaceContainerHigh: Color(0xff272a2f),
      surfaceContainerHighest: Color(0xff32353a),
    );
  }

  ThemeData darkHighContrast() {
    return theme(darkHighContrastScheme());
  }

  ThemeData theme(ColorScheme colorScheme) => ThemeData(
        useMaterial3: true,
        brightness: colorScheme.brightness,
        colorScheme: colorScheme,
        textTheme: textTheme.apply(
          bodyColor: colorScheme.onSurface,
          displayColor: colorScheme.onSurface,
        ),
        scaffoldBackgroundColor: colorScheme.surface,
        canvasColor: colorScheme.surface,
      );

  /// Parent Background
  static const parentBackground = ExtendedColor(
    seed: Color(0xfff7f9ff),
    value: Color(0xfff7f9ff),
    light: ColorFamily(
      color: Color(0xff30628c),
      onColor: Color(0xffffffff),
      colorContainer: Color(0xffcfe5ff),
      onColorContainer: Color(0xff001d33),
    ),
    lightMediumContrast: ColorFamily(
      color: Color(0xff30628c),
      onColor: Color(0xffffffff),
      colorContainer: Color(0xffcfe5ff),
      onColorContainer: Color(0xff001d33),
    ),
    lightHighContrast: ColorFamily(
      color: Color(0xff30628c),
      onColor: Color(0xffffffff),
      colorContainer: Color(0xffcfe5ff),
      onColorContainer: Color(0xff001d33),
    ),
    dark: ColorFamily(
      color: Color(0xff9ccbfb),
      onColor: Color(0xff003354),
      colorContainer: Color(0xff114a73),
      onColorContainer: Color(0xffcfe5ff),
    ),
    darkMediumContrast: ColorFamily(
      color: Color(0xff9ccbfb),
      onColor: Color(0xff003354),
      colorContainer: Color(0xff114a73),
      onColorContainer: Color(0xffcfe5ff),
    ),
    darkHighContrast: ColorFamily(
      color: Color(0xff9ccbfb),
      onColor: Color(0xff003354),
      colorContainer: Color(0xff114a73),
      onColorContainer: Color(0xffcfe5ff),
    ),
  );

  List<ExtendedColor> get extendedColors => [
        parentBackground,
      ];
}

class ExtendedColor {
  final Color seed, value;
  final ColorFamily light;
  final ColorFamily lightHighContrast;
  final ColorFamily lightMediumContrast;
  final ColorFamily dark;
  final ColorFamily darkHighContrast;
  final ColorFamily darkMediumContrast;

  const ExtendedColor({
    required this.seed,
    required this.value,
    required this.light,
    required this.lightHighContrast,
    required this.lightMediumContrast,
    required this.dark,
    required this.darkHighContrast,
    required this.darkMediumContrast,
  });
}

class ColorFamily {
  const ColorFamily({
    required this.color,
    required this.onColor,
    required this.colorContainer,
    required this.onColorContainer,
  });

  final Color color;
  final Color onColor;
  final Color colorContainer;
  final Color onColorContainer;
}

extension CustomColorScheme on ColorScheme {
  Color get sectionContainerLightScheme => const Color(0xffe3f2fd);
  Color get onSectionContainerLightScheme => const Color(0xff0d47a1);
  Color get sectionContainerLightMCScheme => const Color(0xffc8e6ff);
  Color get onSectionContainerLightMCScheme => const Color(0xff073b7c);
  Color get sectionContainerLightHCScheme => const Color(0xffa3d1ff);
  Color get onSectionContainerLightHCScheme => const Color(0xff042c5b);
  Color get sectionContainerDarkScheme => const Color(0xff0a1f30);
  Color get onSectionContainerDarkScheme => const Color(0xffe3f2fd);
  Color get sectionContainerDarkMCScheme => const Color(0xff082432);
  Color get onSectionContainerDarkMCScheme => const Color(0xffbce8ff);
  Color get sectionContainerDarkHCScheme => const Color(0xff041922);
  Color get onSectionContainerDarkHCScheme => const Color(0xffffffff);
}
