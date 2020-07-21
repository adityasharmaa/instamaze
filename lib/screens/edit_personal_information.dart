import 'package:flutter/material.dart';
import 'package:insta/providers/current_user_provider.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

class EditPersonalInformation extends StatefulWidget {
  static final route = "/edit_personal_information";
  @override
  _EditPersonalInformationState createState() =>
      _EditPersonalInformationState();
}

class _EditPersonalInformationState extends State<EditPersonalInformation> {
  final _emailController = TextEditingController();
  final _genderController = TextEditingController();
  final _dobController = TextEditingController();
  final _border = UnderlineInputBorder(
    borderSide: BorderSide(
      color: Colors.grey[350],
    ),
  );

  @override
  void initState() {
    super.initState();
    Future.delayed(
      Duration(milliseconds: 0),
      _initFields,
    );
  }

  void _initFields() {
    final currentUser =
        Provider.of<CurrentUserProvider>(context, listen: false).account;
    _emailController.text = currentUser.email ?? "";
    _genderController.text = currentUser.gender ?? "";
    _dobController.text = currentUser.dob.isEmpty
        ? ""
        : DateFormat.yMMMd().format(DateTime.parse(currentUser.dob));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Personal Information"),
        elevation: 1,
      ),
      body: Container(
        padding: EdgeInsets.all(10),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Text(
                "Provide your personal information, even if the account is used for a business, a pet or something else. This won't be part of your public profile.",
                style: TextStyle(
                  color: Colors.grey,
                ),
              ),
              SizedBox(height: 10),
              TextField(
                decoration: InputDecoration(
                  labelText: "Email",
                  labelStyle: TextStyle(
                    color: Colors.grey,
                    fontWeight: FontWeight.w600,
                  ),
                  focusedBorder: _border,
                  enabledBorder: _border,
                ),
                controller: _emailController,
                style: TextStyle(fontSize: 14),
              ),
              SizedBox(height: 15),
              TextField(
                decoration: InputDecoration(
                  labelText: "Gender",
                  labelStyle: TextStyle(
                    color: Colors.grey,
                    fontWeight: FontWeight.w600,
                  ),
                  focusedBorder: _border,
                ),
                controller: _genderController,
                enabled: false,
                style: TextStyle(fontSize: 14),
              ),
              SizedBox(height: 15),
              TextField(
                decoration: InputDecoration(
                  labelText: "Birthday",
                  labelStyle: TextStyle(
                    color: Colors.grey,
                    fontWeight: FontWeight.w600,
                  ),
                  focusedBorder: _border,
                ),
                controller: _dobController,
                enabled: false,
                style: TextStyle(fontSize: 14),
              ),
              SizedBox(height: 10),
            ],
          ),
        ),
      ),
    );
  }
}
