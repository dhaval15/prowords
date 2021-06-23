import 'package:flutter/material.dart';

typedef SchemeBuilder = Widget Function(BuildContext context, Scheme scheme);

class SchemeProvider extends StatefulWidget {
  final Scheme scheme;
  final SchemeBuilder builder;

  static _SchemeProviderState of(BuildContext context) =>
      context.findAncestorStateOfType<_SchemeProviderState>()!;

  SchemeProvider({
    required this.scheme,
    required this.builder,
  });

  @override
  _SchemeProviderState createState() => _SchemeProviderState();
}

class _SchemeProviderState extends State<SchemeProvider> {
  late Scheme _scheme;
  @override
  void initState() {
    super.initState();
    _scheme = widget.scheme;
  }

  Scheme get scheme => _scheme;

  set scheme(Scheme value) {
    setState(() {
      _scheme = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return widget.builder(context, _scheme);
  }
}

class Schemes {
  static List<Scheme> get all => [
        radiant,
        radiantLight,
        gruvboxLight,
        gruvboxDark,
      ];

  static Scheme withName(String name) =>
      all.firstWhere((element) => element.name == name);

  static Scheme radiant = Scheme(
    name: 'Radiant Dark',
    light: Colors.white,
    dark: Color(0xFF222222),
    borderRadius: BorderRadius.circular(0),
    primaryAppBar: false,
    centerTitle: false,
    colorScheme: ColorScheme(
      primary: Colors.indigo,
      primaryVariant: Colors.indigo,
      secondary: Colors.yellow,
      onSecondary: Color(0xFF222222),
      secondaryVariant: Colors.yellow,
      surface: Color(0xFF282828),
      background: Color(0xFF222222),
      error: Colors.red,
      onPrimary: Colors.white,
      onSurface: Colors.white,
      onBackground: Colors.white,
      onError: Colors.white,
      brightness: Brightness.dark,
    ),
  );
  static Scheme radiantLight = Scheme(
    name: 'Radiant Light',
    dark: Colors.black87,
    light: Colors.white,
    borderRadius: BorderRadius.circular(0),
    primaryAppBar: false,
    centerTitle: false,
    colorScheme: ColorScheme(
      primary: Colors.deepOrange,
      primaryVariant: Colors.deepOrange,
      secondary: Colors.indigo,
      onSecondary: Colors.white,
      secondaryVariant: Colors.indigo,
      surface: Colors.white,
      background: Colors.white,
      error: Colors.red,
      onPrimary: Colors.white,
      onSurface: Colors.black87,
      onBackground: Colors.black87,
      onError: Colors.white,
      brightness: Brightness.light,
    ),
  );

  static const _GRUV_BOX_LIGHT_BACKGROUND = Color(0xFFFFEECC);

  static Scheme gruvboxLight = Scheme(
    name: 'Gruvbox Light',
    dark: Colors.black87,
    light: _GRUV_BOX_LIGHT_BACKGROUND,
    borderRadius: BorderRadius.circular(0),
    primaryAppBar: false,
    centerTitle: false,
    colorScheme: ColorScheme(
      primary: Colors.deepOrange,
      primaryVariant: Colors.deepOrange,
      secondary: Colors.indigo,
      onSecondary: _GRUV_BOX_LIGHT_BACKGROUND,
      secondaryVariant: Colors.indigo,
      surface: _GRUV_BOX_LIGHT_BACKGROUND,
      background: _GRUV_BOX_LIGHT_BACKGROUND,
      error: Colors.red,
      onPrimary: _GRUV_BOX_LIGHT_BACKGROUND,
      onSurface: Colors.black87,
      onBackground: Colors.black87,
      onError: _GRUV_BOX_LIGHT_BACKGROUND,
      brightness: Brightness.light,
    ),
  );

  static Scheme gruvboxDark = Scheme(
    name: 'Gruvbox Dark',
    borderRadius: BorderRadius.circular(0),
    dark: Color(0xFF222222),
    light: _GRUV_BOX_LIGHT_BACKGROUND,
    primaryAppBar: false,
    centerTitle: false,
    colorScheme: ColorScheme(
      primary: Colors.indigo,
      primaryVariant: Colors.indigo,
      secondary: Colors.yellow,
      onSecondary: Color(0xFF222222),
      secondaryVariant: Colors.yellow,
      surface: Color(0xFF282828),
      background: Color(0xFF222222),
      error: Colors.red,
      onPrimary: _GRUV_BOX_LIGHT_BACKGROUND,
      onSurface: _GRUV_BOX_LIGHT_BACKGROUND,
      onBackground: _GRUV_BOX_LIGHT_BACKGROUND,
      onError: _GRUV_BOX_LIGHT_BACKGROUND,
      brightness: Brightness.dark,
    ),
  );
}

class Scheme extends ColorScheme {
  final BorderRadius borderRadius;
  final bool primaryAppBar;
  final String name;
  final Color light;
  final Color dark;
  final bool centerTitle;

  Scheme({
    required this.name,
    required ColorScheme colorScheme,
    required this.borderRadius,
    required this.primaryAppBar,
    required this.dark,
    required this.light,
    this.centerTitle = true,
  }) : super(
          primary: colorScheme.primary,
          primaryVariant: colorScheme.primaryVariant,
          secondary: colorScheme.secondary,
          secondaryVariant: colorScheme.secondaryVariant,
          surface: colorScheme.surface,
          background: colorScheme.background,
          error: colorScheme.error,
          onPrimary: colorScheme.onPrimary,
          onSecondary: colorScheme.onSecondary,
          onSurface: colorScheme.onSurface,
          onBackground: colorScheme.onBackground,
          onError: colorScheme.onError,
          brightness: colorScheme.brightness,
        );

  factory Scheme.of(BuildContext context) => SchemeProvider.of(context).scheme;

  ThemeData get theme => ThemeData(
        primaryColor: primary,
        colorScheme: this,
        accentColor: primary,
        toggleableActiveColor: primary,
        backgroundColor: background,
        scaffoldBackgroundColor: background,
        textTheme: textTheme,
        buttonColor: onBackground,
        dialogTheme: DialogTheme(
          contentTextStyle: TextStyle(color: onBackground),
        ),
        appBarTheme: primaryAppBar
            ? AppBarTheme(
                foregroundColor: onPrimary,
                backgroundColor: primary,
                elevation: 0,
                centerTitle: centerTitle,
                brightness: brightness,
                titleTextStyle: TextStyle(color: onPrimary),
                backwardsCompatibility: false,
              )
            : AppBarTheme(
                elevation: 0,
                backgroundColor: background,
                foregroundColor: onBackground,
                centerTitle: centerTitle,
                brightness: brightness,
                toolbarTextStyle: TextStyle(color: onBackground),
                titleTextStyle: TextStyle(
                    color: onBackground, fontSize: 18, letterSpacing: 2),
                backwardsCompatibility: false,
              ),
        cardColor: onBackground.withOpacity(0.1),
        buttonTheme: ButtonThemeData(
          shape: RoundedRectangleBorder(borderRadius: borderRadius),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ButtonStyle(
              shape: SingleMaterialStateProperty(
                  RoundedRectangleBorder(borderRadius: borderRadius))),
        ),
        outlinedButtonTheme: OutlinedButtonThemeData(
          style: ButtonStyle(
              shape: SingleMaterialStateProperty(
                  RoundedRectangleBorder(borderRadius: borderRadius))),
        ),
        inputDecorationTheme: InputDecorationTheme(
          border: OutlineInputBorder(borderRadius: borderRadius),
        ),
        popupMenuTheme: PopupMenuThemeData(
          color: background,
        ),
        textButtonTheme: TextButtonThemeData(
          style: ButtonStyle(
            foregroundColor: SingleMaterialStateProperty(onBackground),
          ),
        ),
      );

  TextTheme get textTheme => TextTheme(
        headline1: TextStyle(color: onBackground),
        headline2: TextStyle(color: onBackground),
        headline3: TextStyle(color: onBackground),
        headline4: TextStyle(color: onBackground),
        headline5: TextStyle(color: onBackground),
        headline6: TextStyle(color: onBackground),
        bodyText1: TextStyle(color: onBackground),
        bodyText2: TextStyle(color: onBackground),
        subtitle1: TextStyle(color: onBackground),
        subtitle2: TextStyle(color: onBackground),
        caption: TextStyle(color: onBackground),
        overline: TextStyle(color: onBackground),
        button: TextStyle(color: onBackground),
      );
}

class SingleMaterialStateProperty<T> implements MaterialStateProperty<T> {
  final T value;

  const SingleMaterialStateProperty(this.value);
  @override
  T resolve(Set<MaterialState> states) {
    return value;
  }
}
