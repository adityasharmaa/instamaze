import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_auth_buttons/flutter_auth_buttons.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:insta/helpers/firebase_auth.dart';
import 'package:insta/screens/edit_profile.dart';
import 'package:insta/helpers/google_sign_in.dart' show googleSignIn;
import 'package:insta/screens/sign_up_screen.dart';

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
  bool _isLoading = true;
  bool _emailVerificationRequired = false;
  Timer _timer;

  /////////// Google Sigin code
  @override
  void initState() {
    super.initState();

    _setUpGoogleSignInListener();

    _checkEmailVerification();
  }

  void _setUpGoogleSignInListener() {
    googleSignIn.onCurrentUserChanged.listen((GoogleSignInAccount account) {
      if (account != null) //_signInWithFirebaseAuthUsingGoogle(account);
        Navigator.of(context).pushReplacementNamed(EditProfile.route);
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

  Future<void> _checkEmailVerification() async {
    _currentUser = await _auth.getCurrentUser();
    if (_currentUser != null) {
      if (!_currentUser.isEmailVerified)
        setState(() {
          _isLoading = false;
          _emailVerificationRequired = true;
        });
      else
        Navigator.of(context).pushReplacementNamed(EditProfile.route);
    } else
      setState(() {
        _isLoading = false;
        _emailVerificationRequired = false;
      });
  }

  final _border = OutlineInputBorder(
    borderRadius: BorderRadius.all(Radius.circular(5)),
    borderSide: BorderSide(color: Colors.grey[300]),
  );

  Widget _textField(
      String hint, bool obscured, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: 5,
        horizontal: 20,
      ),
      child: TextField(
        decoration: InputDecoration(
          disabledBorder: _border,
          border: _border,
          focusedBorder: _border,
          enabledBorder: _border,
          filled: true,
          fillColor: Colors.grey[100],
          hintText: hint,
        ),
        obscureText: obscured,
        controller: controller,
      ),
    );
  }

  Row _interactiveText(String normalText, String boldText, Function action) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text(
          normalText,
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey,
          ),
        ),
        InkWell(
          onTap: action,
          child: SizedBox(
            //SizedBox provides bigger area to click
            height: MediaQuery.of(context).size.longestSide * 0.03,
            child: Center(
              child: Text(
                boldText,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: Colors.indigo[900],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

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

    try {
      setState(() {
        _isLoading = true;
      });
      _currentUser = await _auth.signIn(email, password);
      if (_currentUser.uid.length > 0)
        Navigator.of(context).pushReplacementNamed(LoginScreen.route);
      else
        setState(() {
          _isLoading = false;
          _emailVerificationRequired = true;
        });

      setState(() {
        _isLoading = false;
      });
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

      setState(() {
        _isLoading = false;
      });
    }
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
          color: Theme.of(ctx).errorColor,
        ),
        content: Text(
          message,
          textAlign: TextAlign.center,
        ),
      ),
    );
  }

  void _setTimer() {
    _timer = Timer.periodic(Duration(seconds: 5), (timer) async {
      print("Checking ${timer.tick}");
      final currentUser = await _auth.getCurrentUser();
      await currentUser.reload();
      if (currentUser.isEmailVerified) {
        _timer.cancel();
        Navigator.of(context).pushReplacementNamed(EditProfile.route);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final _height = MediaQuery.of(context).size.longestSide;
    return AbsorbPointer(
      absorbing: _isLoading,
      child: Scaffold(
        appBar: _emailVerificationRequired
            ? AppBar(
                title: Text("Verify"),
                actions: <Widget>[
                  IconButton(
                    icon: Icon(Icons.power_settings_new),
                    onPressed: () async {
                      final currentUser = await Auth().getCurrentUser();
                      if (currentUser != null)
                        await Auth().signOut();
                      else
                        await googleSignIn.signOut();
                      Navigator.of(context)
                          .pushReplacementNamed(LoginScreen.route);
                    },
                  ),
                ],
              )
            : null,
        key: _scaffold,
        body: SizedBox(
          height: _height,
          width: double.infinity,
          child: Stack(
            children: <Widget>[
              Center(
                child:
                    /*_emailVerificationRequired
                    ? Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 30),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Icon(
                              Icons.verified_user,
                              size: 40,
                              color: Theme.of(context).accentColor,
                            ),
                            SizedBox(height: 20),
                            Text(
                              "We have sent a verification link to your email. Please verify to complete your Instamaze profile. We're listening for your response.\n",
                              textAlign: TextAlign.center,
                            ),
                            SizedBox(height: 20),
                            RaisedButton(
                              child: Text("Resend verification link"),
                              onPressed: () async {
                                setState(() {
                                  _isLoading = true;
                                });
                                await _currentUser.sendEmailVerification();
                                setState(() {
                                  _isLoading = false;
                                });
                                if (_timer == null)
                                  _setTimer();
                                else if (!_timer.isActive) _setTimer();
                              },
                            ),
                          ],
                        ),
                      )
                    : */
                    SingleChildScrollView(
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
                      _textField(
                        "Email",
                        false,
                        _emailController,
                      ),
                      _textField(
                        "Password",
                        true,
                        _passwordController,
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 5,
                        ),
                        child: InkWell(
                          child: Container(
                            height: _height * 0.06,
                            width: double.infinity,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5),
                              color: Colors.blue,
                            ),
                            child: Center(
                              child: Text(
                                "Log In",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                          onTap: _action,
                        ),
                      ),
                      SizedBox(height: 5),
                      _interactiveText(
                        "Forgot password? ",
                        "Reset password.",
                        () {},
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
                      _interactiveText(
                        "Don't have an account? ",
                        "Sign up.",
                        (){
                          Navigator.of(context).pushNamed(SignUpScreen.route);
                        },
                      ),
                    ],
                  ),
                ),
              ),
              Positioned(
                child: _isLoading
                    ? Container(
                        child: Center(
                          child: CircularProgressIndicator(),
                        ),
                        color: Colors.white.withOpacity(0.8),
                      )
                    : Container(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
