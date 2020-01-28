import 'package:flutter/material.dart';
import 'package:insta/helpers/firebase_auth.dart';
import 'package:insta/helpers/google_sign_in.dart';
import 'package:insta/models/profile_model.dart';
import 'package:insta/screens/login_screen.dart';

class EditProfile extends StatefulWidget {
  static const route = "/edit_profile";
  @override
  _EditProfileState createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  final _form = GlobalKey<FormState>();
  final _profile = ProfileModel(
    name: "",
    userName: "",
    bio: "",
    gender: "",
  );

  @override
  Widget build(BuildContext context) {
    final _width = MediaQuery.of(context).size.shortestSide;
    return Scaffold(
      appBar: AppBar(
        title: Text("Edit Profile"),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.power_settings_new),
            onPressed: () async {
              final currentUser = await Auth().getCurrentUser();
              if (currentUser != null)
                await Auth().signOut();
              else
                await googleSignIn.signOut();
              Navigator.of(context).pushReplacementNamed(LoginScreen.route);
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Form(
          key: _form,
          child: Column(
            children: <Widget>[
              CircleAvatar(
                backgroundImage: NetworkImage(
                  "http://www.bestchinanews.com/url.php?p=http://p1.qhimg.com/t01b707addd03c0c434.jpg",
                ),
                radius: _width * 0.2,
              ),
              Text("Change Profile Photo"),
              TextFormField(
                decoration: InputDecoration(
                  hintText: "Name"
                ),
                textInputAction: TextInputAction.next,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
