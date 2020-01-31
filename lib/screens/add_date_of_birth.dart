import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:insta/providers/current_user_provider.dart';
import 'package:insta/screens/welcome_screen.dart';
import 'package:insta/widgets/blue_button.dart';
import 'package:insta/widgets/grey_text_field.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class AddDateOfBirth extends StatefulWidget {
  static const route = "/add_date_of_birth";
  @override
  _AddDateOfBirthState createState() => _AddDateOfBirthState();
}

class _AddDateOfBirthState extends State<AddDateOfBirth> {
  bool _isLoading = false;
  double _years = 0;
  DateTime dob = DateTime.now();
  final _scaffold = GlobalKey<ScaffoldState>();

  final _dobController = TextEditingController(
    text: DateFormat.yMMMMd().format(DateTime.now()),
  );

  void _setDOB() async {
    if (_years.toInt() <= 12) {
      _showSnackBar("You seem younger than age limit!");
      return;
    }
    setState(() {
      _isLoading = true;
    });
    try {
      await Provider.of<CurrentUserProvider>(context, listen: false)
          .setDOB(dob.toIso8601String());
      Navigator.of(context).pushReplacementNamed(WelcomeScreen.route);
    } catch (e) {
      _showSnackBar("Error setting DOB!");
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
      child: SafeArea(
        child: Scaffold(
          key: _scaffold,
          backgroundColor: Colors.white,
          body: Stack(
            children: <Widget>[
              Column(
                children: <Widget>[
                  SizedBox(height: 20),
                  Image.asset(
                    "assets/images/cake.png",
                    height: _height * 0.1,
                    width: _height * 0.1,
                  ),
                  SizedBox(height: 15),
                  Text(
                    "Add your date of birth",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 15),
                  Text(
                    "This won't be a part of your public profile.",
                  ),
                  Text(
                    "Why do I need to provide my date of birth?",
                    style: TextStyle(
                      color: Colors.indigo,
                    ),
                  ),
                  SizedBox(height: 20),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                    ),
                    child: GreyTextField(
                      hint: "Date of birth",
                      controller: _dobController,
                      obscured: false,
                      enabled: false,
                    ),
                  ),
                  Row(
                    children: <Widget>[
                      Expanded(child: SizedBox()),
                      Padding(
                        padding: const EdgeInsets.only(right: 20),
                        child: Text("${_years.toInt()} years",
                            style: TextStyle(
                                color: _years.toInt() > 12
                                    ? Colors.grey
                                    : Colors.red)),
                      ),
                    ],
                  ),
                  Expanded(child: SizedBox()),
                  Divider(),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 15,
                    ),
                    child: BlueButton(
                      label: "Next",
                      isLoading: _isLoading,
                      action: _setDOB,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    child: SizedBox(
                      height: _height * 0.2,
                      child: CupertinoDatePicker(
                        initialDateTime: DateTime.now(),
                        maximumDate: DateTime.now(),
                        onDateTimeChanged: (date) {
                          setState(() {
                            _dobController.value = TextEditingValue(
                              text: DateFormat.yMMMMd().format(date),
                            );
                            _years =
                                (DateTime.now().difference(date).inDays / 365);
                            dob = date;
                          });
                        },
                        mode: CupertinoDatePickerMode.date,
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
