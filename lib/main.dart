import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:scooter_safety_application/MapPage.dart';
import 'package:scooter_safety_application/SplashScreen.dart';
import 'package:scooter_safety_application/firebase_options.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());

}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  static final Color primaryColor = Color(0xFF254D32);
  static final Color secondaryColor = Color(0xFF69B578);
  static final Color surfaceColor = Color(0xFFF2F4E1);
  static final Color accentColor = Color(0xFF181D27);
  static final ColorScheme scheme = ColorScheme(
      brightness: Brightness.light,
      primary: primaryColor,
      onPrimary: surfaceColor,
      secondary: secondaryColor,
      onSecondary: accentColor,
      error: Colors.red,
      onError: Colors.white,
      surface: surfaceColor,
      onSurface: accentColor
  );

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: SplashScreen(),
    );
  }
}