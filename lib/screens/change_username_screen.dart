import 'package:flutter/material.dart';
import 'package:insta/providers/current_user_provider.dart';
import 'package:insta/widgets/blue_button.dart';
import 'package:insta/widgets/grey_text_field.dart';
import 'package:provider/provider.dart';

import 'accounts_suggestion.dart';

class ChangeUsernameScreen extends StatefulWidget {
  static const route = "/change_username_screen";

  @override
  _ChangeUsernameScreenState createState() => _ChangeUsernameScreenState();
}

class _ChangeUsernameScreenState extends State<ChangeUsernameScreen> {
  bool _isLoading = false;
  final _usernameController = TextEditingController();
  final _scaffold = GlobalKey<ScaffoldState>();

  void _setUsername() async {
    String username = _usernameController.text;
    if (username.isEmpty) {
      _showSnackBar("Enter username!");
      return;
    }
    setState(() {
      _isLoading = true;
    });
    try {
      final response =
          await Provider.of<CurrentUserProvider>(context, listen: false)
              .setUsername(username);
      if (response.isEmpty) {
        Navigator.of(context).pop();
        Navigator.of(context).pushReplacementNamed(AccountsSuggestionScreen.route);
      } else
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
                    "CHANGE USERNAME",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 10),
                  Text(
                    "Choose a username for your account. You can always change it later.",
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.grey),
                  ),
                  SizedBox(height: 20),
                  GreyTextField(
                    hint: "Username",
                    enabled: true,
                    obscured: false,
                    controller: _usernameController,
                  ),
                  SizedBox(height: 10),
                  BlueButton(
                    label: "Next",
                    isLoading: _isLoading,
                    action: _setUsername,
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
      ),
    );
  }
}
