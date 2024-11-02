import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:scooter_safety_application/authentication/loginPage.dart';
import 'package:scooter_safety_application/dashboard.dart';
import 'package:scooter_safety_application/firebase/authentication.dart';


class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    init();
  }

  Future<void> init() async {
    try{
      await Future.delayed(Duration(seconds: 2));
      bool isLoggedIn = await AuthenticationHelper().isLoggedIn();

      if(isLoggedIn)
      {
        Navigator.pushReplacement(context,
            MaterialPageRoute(
                builder: (BuildContext context) => Dashboard()));
      }
      else{
        Navigator.pushReplacement(context,
            MaterialPageRoute(
                builder: (BuildContext context) => LoginPage()));
      }

    }catch (e) {
      print('Error during initialization $e');
      Navigator.pushReplacement(context,
          MaterialPageRoute(
              builder: (BuildContext context) =>  LoginPage()));
    }
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Color(0xFF7cb995),
        body: Stack(
          alignment: Alignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 40.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Spacer(),
                  Text(
                    'TrackTrail',
                    style: GoogleFonts.raleway(
                        fontWeight: FontWeight.bold,
                        fontSize: 40,
                        color: Colors.white),
                  ),
                  const Spacer(),
                  Container(
                    height: 300,
                    width: 300,
                    decoration: const BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage('assets/logo.png'),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  const Spacer(),
                  const Column(
                    children: [
                      Text(
                        'Version',
                        style: TextStyle(color: Colors.white),
                      ),
                      Text(
                        '1.0.0',
                        style: TextStyle(
                            color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                    ],
                  )
                ],
              ),
            ),
            Container(
              height: 630,
            )
          ],
        ),
      ),
    );
  }
}