import 'package:flutter/material.dart';
import 'package:insta/providers/current_user_provider.dart';
import 'package:insta/screens/accounts_suggestion.dart';
import 'package:insta/screens/screen_selector.dart';
import 'package:insta/screens/welcome_screen.dart';
import 'package:provider/provider.dart';
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
      if (user?.uid != null) {
        final cUser = Provider.of<CurrentUserProvider>(context, listen: false);
        await cUser.getCurrentUser(user.uid);

        if (cUser.account.dob != null) {
          if (cUser.account.username != null){
            if(cUser.account.following != null){
              if(cUser.account.following.isNotEmpty)
                Navigator.of(context).pushReplacementNamed(ScreenSelector.route);
              else
                Navigator.of(context).pushReplacementNamed(AccountsSuggestionScreen.route);
            }
            else
              Navigator.of(context).pushReplacementNamed(AccountsSuggestionScreen.route);
          }
          else
            Navigator.of(context).pushReplacementNamed(WelcomeScreen.route);
        } else {
          await cUser.delete(user.uid);
          await user.delete();
          Navigator.of(context).pushReplacementNamed(LoginScreen.route);
        }
      } else
        Navigator.of(context).pushReplacementNamed(LoginScreen.route);
    } else
      Navigator.of(context).pushReplacementNamed(LoginScreen.route);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Text(
          "Instamaze",
          style: TextStyle(
            fontSize: 40,
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
