import 'package:flutter/material.dart';
import 'package:insta/providers/current_user_provider.dart';
import 'package:insta/screens/enter_name_and_password.dart';
import 'package:insta/widgets/blue_button.dart';
import 'package:insta/widgets/grey_text_field.dart';
import 'package:insta/widgets/info_dialog.dart';
import 'package:insta/widgets/interactive_text.dart';
import 'package:provider/provider.dart';

class SignUpScreen extends StatefulWidget {
  static const route = "/sign_up_screen";

  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _emailController = TextEditingController();
  bool _isLoading = false;
  final _scaffold = GlobalKey<ScaffoldState>();

  void _showSnackBar(String message) {
    _scaffold.currentState.showSnackBar(
      SnackBar(
        duration: Duration(seconds: 1),
        content: Text(message),
      ),
    );
  }

  void _action() async {
    String email = _emailController.text;
    if (email.isEmpty) {
      _showSnackBar("Enter email!");
      return;
    } else if (!(email.contains("@") &&
        email.indexOf("@") > 0 &&
        email.contains(".") &&
        (email.indexOf(".") - email.indexOf("@")) > 1)) {
      _showSnackBar("Invalid email!");
      return;
    }

    setState(() {
      _isLoading = true;
    });

    bool emailExist = await Provider.of<CurrentUserProvider>(context, listen: false)
        .isEmailAlreadyUsed(email);

    setState(() {
      _isLoading = false;
    });

    if (emailExist)
      showDialog(
        context: context,
        builder: (_) => InfoDialog(
          heading: "This email address is on another account",
          details:
              "You can log in to the account with that email or you can use another email to sign up.",
          firstActionLabel: "Log in to existing account",
          secondActionLabel: "Use Other Email",
          firstAction: () {
            Navigator.of(context).pop();
            Navigator.of(context).pop();
          },
          secondAction: () {
            Navigator.of(context).pop();
          },
        ),
      );
    else{
      Navigator.of(context).pop();
      Navigator.of(context).pushReplacementNamed(EnterNameAndPassword.route, arguments: email);
    }
  }

  @override
  Widget build(BuildContext context) {
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
                  Image.asset(
                    "assets/images/sign_up_icon.png",
                    height: _height * 0.2,
                    width: _height * 0.2,
                  ),
                  SizedBox(height: 20),
                  Text(
                    "SIGN UP",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 10),
                  GreyTextField(
                    hint: "Email",
                    obscured: false,
                    controller: _emailController,
                    enabled: true,
                  ),
                  SizedBox(height: 10),
                  BlueButton(
                    label: "Next",
                    isLoading: _isLoading,
                    action: _action,
                  ),
                  Expanded(child: SizedBox()),
                  Divider(
                    height: 1,
                  ),
                  Divider(
                    height: 1,
                  ),
                  Container(
                    height: _height * 0.06,
                    width: double.infinity,
                    child: Center(
                      child: InteractiveText(
                        normalText: "Already have an account? ",
                        boldText: "Log in.",
                        action: () {
                          Navigator.of(context).pop();
                        },
                      ),
                    ),
                  ),
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
