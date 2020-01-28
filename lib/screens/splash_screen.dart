import 'package:flutter/material.dart';
import 'package:insta/screens/home.dart';
import 'login_screen.dart';
import '../helpers/firebase_auth.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _checkLogInStatus();
  }

  void _checkLogInStatus() async {
    final auth = Auth();
    final user = await auth.getCurrentUser();

    if (user != null) {
      await user.reload();
      /*await Provider.of<CurrentUserProvider>(context, listen: false)
          .getCurrentUser();*/

      if (user?.uid != null)
        Navigator.of(context).pushReplacementNamed(Home.route);
      else
        Navigator.of(context).pushReplacementNamed(LoginScreen.route);
    } else
      Navigator.of(context).pushReplacementNamed(LoginScreen.route);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        color: Theme.of(context).primaryColor,
        child: Center(
          child: Text(
            "Instamaze",
            style: TextStyle(
              fontSize: 40,
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}
