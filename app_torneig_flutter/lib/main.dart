import 'package:app_torneig/routes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:app_torneig/routes/app_pages.dart';
import 'package:responsive_framework/responsive_framework.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Torneig del Mort',
      builder: (context, child) => ResponsiveBreakpoints.builder(
        child: child!,
        breakpoints: [
          const Breakpoint(start: 0, end: 450, name: MOBILE),
          const Breakpoint(start: 451, end: 800, name: TABLET),
          const Breakpoint(start: 801, end: 1920, name: DESKTOP),
          const Breakpoint(start: 1921, end: double.infinity, name: '4K'),
        ],
      ),
      debugShowCheckedModeBanner: false,
      initialRoute: Routes.HOME,
      onGenerateRoute: Navegacio.generateRoute,
    );
  }
/*
  ThemeData buildThemeData() {
    ColorScheme colorScheme = const ColorScheme(
      primary: Colors.black, // Azul oscuro como color primario
      secondary: Color(0xFF69BFA0), // Verde menta como color secundario
      surface:
          Color(0xFFEBEBD3), // Color de la superficie de los elementos de la UI
      background: Color(0xFFF4F4F9), // Color de fondo general
      error: Colors.red, // Color para indicar errores
      onPrimary: Colors.white, // Color del texto/iconos sobre el primario
      onSecondary: Colors.white, // Color del texto/iconos sobre el secundario
      onSurface:
          Color(0xFF333333), // Color del texto/iconos sobre la superficie
      onBackground: Color(0xFF333333), // Color del texto/iconos sobre el fondo
      onError: Colors.white, // Color del texto/iconos sobre el error
      brightness: Brightness.light, // Luminosidad general del tema
    );

    return ThemeData.from(colorScheme: colorScheme).copyWith(
      textTheme: TextTheme(
        displayLarge: TextStyle(
            fontSize: 24.0,
            fontWeight: FontWeight.bold,
            color: colorScheme.onBackground),
        bodyLarge: TextStyle(fontSize: 14.0, color: colorScheme.onBackground),
      ),
      inputDecorationTheme: InputDecorationTheme(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
          borderSide: BorderSide(color: colorScheme.secondary),
        ),
      ),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
          backgroundColor: Color(0xFFF4A261)),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ButtonStyle(
          backgroundColor:
              MaterialStateProperty.all<Color>(colorScheme.primary),
          foregroundColor:
              MaterialStateProperty.all<Color>(colorScheme.onPrimary),
        ),
      ),
      appBarTheme: AppBarTheme(
        titleTextStyle: TextStyle(
            color: colorScheme.onPrimary,
            shadows: const <Shadow>[
              Shadow(
                offset: Offset(7.0, 7.0),
                blurRadius: 2.0,
                color: Colors.black,
              )
            ],
            fontFamily: 'FaceOffM54',
            fontWeight: FontWeight.w500),
      ),
    );
  }*/
}
