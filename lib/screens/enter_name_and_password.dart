import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:insta/helpers/firebase_auth.dart';
import 'package:insta/providers/current_user_provider.dart';
import 'package:insta/screens/add_date_of_birth.dart';
import 'package:insta/widgets/blue_button.dart';
import 'package:insta/widgets/grey_text_field.dart';
import 'package:provider/provider.dart';

class EnterNameAndPassword extends StatefulWidget {
  static const route = "/enter_username_and_password";

  @override
  _EnterNameAndPasswordState createState() => _EnterNameAndPasswordState();
}

class _EnterNameAndPasswordState extends State<EnterNameAndPassword> {
  final _nameController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _savePassword = true;
  bool _isLoading = false;
  final _scaffold = GlobalKey<ScaffoldState>();

  void _createAccount() async {
    String name = _nameController.text;
    String password = _passwordController.text;

    if (name.isEmpty) {
      _showSnackBar("Enter your name");
      return;
    } else if (password.length < 6) {
      _showSnackBar("Enter password of minimum length 6");
      return;
    }

    setState(() {
      _isLoading = true;
    });

    String email = ModalRoute.of(context).settings.arguments;
    final userId = await Auth().signUp(email, password);

    try {
      if (userId.isNotEmpty) {
        await Provider.of<CurrentUserProvider>(context, listen: false)
            .createAccount(email, userId, name);
        Navigator.of(context).pushReplacementNamed(AddDateOfBirth.route);
      } else {
        _showSnackBar("Error registering user");
      }
    } catch (e) {
      _showSnackBar("Error creating account");
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
    final _height = MediaQuery.of(context).size.longestSide;
    return AbsorbPointer(
      absorbing: _isLoading,
      child: Scaffold(
        key: _scaffold,
        body: Stack(
          children: <Widget>[
            Column(
              children: <Widget>[
                Expanded(child: SizedBox()),
                Text(
                  "NAME AND PASSWORD",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: GreyTextField(
                    hint: "Name",
                    obscured: false,
                    controller: _nameController,
                    enabled: true,
                  ),
                ),
                SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: GreyTextField(
                    hint: "Password",
                    obscured: true,
                    controller: _passwordController,
                    enabled: true,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 5),
                  child: Row(
                    children: <Widget>[
                      Checkbox(
                        checkColor: Colors.white,
                        activeColor: Colors.blue,
                        value: _savePassword,
                        onChanged: (value) => setState(() {
                          _savePassword = value;
                        }),
                      ),
                      Text(
                        "Save Password",
                        style: TextStyle(fontSize: 12, color: Colors.grey[400]),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: BlueButton(
                    label: "Continue",
                    isLoading: _isLoading,
                    action: _createAccount,
                  ),
                ),
                Expanded(child: SizedBox()),
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
    );
  }
}
