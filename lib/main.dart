import 'package:flutter/material.dart';
import 'package:scooter_safety_application/SplashScreen.dart';

void main() {
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
        // This is the theme of your application.
        //
        // TRY THIS: Try running your application with "flutter run". You'll see
        // the application has a purple toolbar. Then, without quitting the app,
        // try changing the seedColor in the colorScheme below to Colors.green
        // and then invoke "hot reload" (save your changes or press the "hot
        // reload" button in a Flutter-supported IDE, or press "r" if you used
        // the command line to start the app).
        //
        // Notice that the counter didn't reset back to zero; the application
        // state is not lost during the reload. To reset the state, use hot
        // restart instead.
        //
        // This works for code too, not just values: Most code changes can be
        // tested with just a hot reload.
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: SplashScreen(),
    );
  }
}