import 'package:flutter/material.dart';
import 'package:insta/providers/current_user_provider.dart';
import 'package:insta/screens/change_username_screen.dart';
import 'package:insta/screens/screen_selector.dart';
import 'package:insta/widgets/blue_button.dart';
import 'package:provider/provider.dart';

class WelcomeScreen extends StatefulWidget {
  static const route = "/welcome_screen";
  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  bool _isLoading = false;
  final _scaffold = GlobalKey<ScaffoldState>();

  String _userName(String email) {
    return email.substring(0, email.indexOf("@"));
  }

  void _setUsername(String username) async {
    setState(() {
      _isLoading = true;
    });
    try {
      final response =
          await Provider.of<CurrentUserProvider>(context, listen: false)
              .setUsername(username);
      if (response.isEmpty)
        Navigator.of(context).pushReplacementNamed(ScreenSelector.route);
      else
        _showSnackBar(response);
    } catch (e) {
      _showSnackBar("Error setting username!");
      print(e.toString());
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

  @override
  Widget build(BuildContext context) {
    final username = _userName(
        Provider.of<CurrentUserProvider>(context, listen: false).user.email);
    final _height = MediaQuery.of(context).size.longestSide;

    return AbsorbPointer(
      absorbing: _isLoading,
      child: Scaffold(
        key: _scaffold,
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Stack(
            children: <Widget>[
              Column(
                children: <Widget>[
                  Expanded(child: SizedBox()),
                  Text(
                    "WELCOME TO INSTAMAZE,\n$username",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text(
                    "Find people to follow and start sharing photos. You can change your username at any time.",
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.grey),
                  ),
                  SizedBox(height: 20),
                  BlueButton(
                    label: "Next",
                    isLoading: _isLoading,
                    action: () {
                      _setUsername(username);
                    },
                  ),
                  InkWell(
                    onTap: () {
                      Navigator.of(context)
                          .pushNamed(ChangeUsernameScreen.route);
                    },
                    child: SizedBox(
                      height: _height * 0.05,
                      child: Center(
                        child: Text(
                          "Change username",
                          style: TextStyle(
                            color: Colors.blue,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Expanded(child: SizedBox()),
                  RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: "By clicking Next, you agree to our ",
                          style: TextStyle(
                            color: Colors.grey,
                            fontSize: 12,
                          ),
                        ),
                        TextSpan(
                          text: "Terms",
                          style: TextStyle(
                            color: Colors.indigo,
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        ),
                        TextSpan(
                          text: ", ",
                          style: TextStyle(
                            color: Colors.grey,
                            fontSize: 12,
                          ),
                        ),
                        TextSpan(
                          text: "Data Policy ",
                          style: TextStyle(
                            color: Colors.indigo,
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        ),
                        TextSpan(
                          text: "and ",
                          style: TextStyle(
                            color: Colors.grey,
                            fontSize: 12,
                          ),
                        ),
                        TextSpan(
                          text: "Cookie Policy",
                          style: TextStyle(
                            color: Colors.indigo,
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 25),
                ],
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
