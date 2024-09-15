import "package:flutter/material.dart";
import "package:google_fonts/google_fonts.dart";

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
                "Hello this is a test text",
                  style: GoogleFonts.montserrat(
                    fontSize: 24,
                    color: Colors.brown
                  )

            ),
            Card(),
            Text("Another text")
          ],
        ),
      ),
    );
  }
}
