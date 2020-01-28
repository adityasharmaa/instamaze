import 'package:flutter/material.dart';
import 'package:insta/screens/edit_profile.dart';
import 'package:insta/screens/home.dart';
import 'package:insta/screens/login_screen.dart';
import 'package:insta/screens/screen_selector.dart';
import 'package:insta/screens/sign_up_screen.dart';
import 'package:insta/screens/splash_screen.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Instamaze',
      theme: ThemeData(
        primaryColor: Colors.white,
        accentColor: Colors.black,
      ),
      home: SplashScreen(),
      routes: {
        ScreenSelector.route: (_) => ScreenSelector(),
        LoginScreen.route: (_) => LoginScreen(),
        EditProfile.route: (_) => EditProfile(),
        Home.route: (_) => Home(),
        SignUpScreen.route: (_) => SignUpScreen(),
      },
    );
  }
}
