import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_auth_buttons/flutter_auth_buttons.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:insta/helpers/firebase_auth.dart';
import 'package:insta/providers/current_user_provider.dart';
import 'package:insta/helpers/google_sign_in.dart' show googleSignIn;
import 'package:insta/screens/screen_selector.dart';
import 'package:insta/screens/sign_up_screen.dart';
import 'package:insta/widgets/blue_button.dart';
import 'package:insta/widgets/grey_text_field.dart';
import 'package:insta/widgets/interactive_text.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatefulWidget {
  static const route = "/login_screen";
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _auth = Auth();
  final _scaffold = GlobalKey<ScaffoldState>();

  FirebaseUser _currentUser;
  bool _isLoading = false;

  /////////// Google Sigin code
  @override
  void initState() {
    super.initState();

    _setUpGoogleSignInListener();
  }

  void _setUpGoogleSignInListener() {
    googleSignIn.onCurrentUserChanged.listen((GoogleSignInAccount account) {
      if (account != null) //_signInWithFirebaseAuthUsingGoogle(account);
        Navigator.of(context).pushReplacementNamed(ScreenSelector.route);
    });
  }

  Future<void> _handleSignIn() async {
    try {
      await googleSignIn.signIn();
    } catch (error) {
      print(error);
    }
  }

  /////////// Google signin code ends

  void _action() async {
    String email = _emailController.value.text;
    String password = _passwordController.value.text;

    if (email.isEmpty) {
      _showSnackBar("Enter email");
      return;
    } else if (password.isEmpty) {
      _showSnackBar("Enter password");
      return;
    } else if (password.length < 6) {
      _showDialog("Password length must be atleast 6");
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      _currentUser = await _auth.signIn(email, password);
      final cUser = Provider.of<CurrentUserProvider>(context, listen: false);
      await cUser.getCurrentUser(_currentUser.uid);
      if (_currentUser.uid.length > 0)
        Navigator.of(context).pushReplacementNamed(ScreenSelector.route);
      else
        _showDialog("Error signing in");
    } catch (error) {
      PlatformException e = error;

      String message = "Something went wrong";
      print(e.code);
      switch (e.code) {
        case "ERROR_INVALID_EMAIL":
          message = "Invalid email.";
          break;

        case "ERROR_USER_NOT_FOUND":
          message = "Please sign up first.";
          break;

        case "ERROR_WEAK_PASSWORD":
          message = "Password length must be atleast 6.";
          break;

        case "ERROR_EMAIL_ALREADY_IN_USE":
          message = "Account already exists with this email. Try signing in.";
          break;

        case "ERROR_WRONG_PASSWORD":
          message = "Wrong password.";
          break;
      }

      _showDialog(message);
    }

    setState(() {
      _isLoading = false;
    });
  }

  void _showSnackBar(String message) {
    _scaffold.currentState.showSnackBar(
      SnackBar(
        duration: Duration(seconds: 1),
        content: Text(message),
      ),
    );
  }

  void _showDialog(String message) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Icon(
          Icons.error,
        ),
        content: Text(
          message,
          textAlign: TextAlign.center,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final _height = MediaQuery.of(context).size.longestSide;
    return AbsorbPointer(
      absorbing: _isLoading,
      child: Scaffold(
        key: _scaffold,
        body: SizedBox(
          height: _height,
          width: double.infinity,
          child: Stack(
            children: <Widget>[
              Center(
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      children: <Widget>[
                        Text(
                          "Instamaze",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 35,
                          ),
                        ),
                        SizedBox(height: 30),
                        GreyTextField(
                          hint: "Email",
                          obscured: false,
                          controller: _emailController,
                          enabled: true,
                        ),
                        SizedBox(height: 10),
                        GreyTextField(
                          hint: "Password",
                          obscured: true,
                          controller: _passwordController,
                          enabled: true,
                        ),
                        SizedBox(height: 10),
                        BlueButton(
                            label: "Log In",
                            isLoading: _isLoading,
                            action: _action),
                        SizedBox(height: 5),
                        InteractiveText(
                          normalText: "Forgot password? ",
                          boldText: "Reset password.",
                          action: () {},
                        ),
                        SizedBox(height: 20),
                        GoogleSignInButton(
                          onPressed: _handleSignIn,
                        ),
                        SizedBox(height: 10),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: Row(
                            children: <Widget>[
                              Expanded(child: Divider()),
                              Text(
                                " OR ",
                                style: TextStyle(color: Colors.grey),
                              ),
                              Expanded(child: Divider()),
                            ],
                          ),
                        ),
                        SizedBox(height: 10),
                        InteractiveText(
                          normalText: "Don't have an account? ",
                          boldText: "Sign up.",
                          action: () {
                            Navigator.of(context).pushNamed(SignUpScreen.route);
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Positioned(
                child: Container(
                  height: _isLoading ? _height : 0,
                  color: _isLoading
                      ? Colors.white.withOpacity(0.5)
                      : Colors.transparent,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
