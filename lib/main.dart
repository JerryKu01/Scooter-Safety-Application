import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:scooter_safety_application/MapPage.dart';
import 'package:scooter_safety_application/SplashScreen.dart';
import 'package:scooter_safety_application/firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // Define your custom colors
  static final Color primaryColor = Color(0xFF254D32);
  static final Color secondaryColor = Color(0xFF69B578);
  static final Color surfaceColor = Color(0xFFF2F4E1);
  static final Color accentColor = Color(0xFF181D27);

  // Create a custom ColorScheme
  static final ColorScheme scheme = ColorScheme(
    brightness: Brightness.light,
    primary: primaryColor,
    onPrimary: surfaceColor,
    secondary: secondaryColor,
    onSecondary: accentColor,
    error: Colors.red,
    onError: Colors.white,
    background: surfaceColor,
    onBackground: accentColor,
    surface: surfaceColor,
    onSurface: accentColor,
  );

  // Build the MaterialApp with the custom ThemeData
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Scooter Safety Application',
      theme: ThemeData(
        colorScheme: scheme,
        // Optionally, set other theme properties
        // that use the color scheme
        useMaterial3: true,
        appBarTheme: AppBarTheme(
          backgroundColor: scheme.primary,
          foregroundColor: scheme.onPrimary,
        ),
        scaffoldBackgroundColor: scheme.background,

        textTheme: TextTheme(
          bodyMedium: TextStyle(color: scheme.onBackground),
          bodySmall: TextStyle(color: scheme.onBackground),
        ),
        // You can define more theme properties as needed
      ),
      home: SplashScreen(),
    );
  }
}
