import 'dart:io';

import 'package:flutter/material.dart';
import 'package:insta/helpers/firebase_auth.dart';
import 'package:insta/screens/pick_images_screen.dart';
import 'package:insta/screens/home.dart';
import 'package:insta/screens/login_screen.dart';
import 'package:insta/helpers/google_sign_in.dart' show googleSignIn;
import 'package:insta/screens/prepare_post.dart';
import 'package:insta/screens/profile_screen.dart';

class ScreenSelector extends StatefulWidget {
  static const route = "/screen_selector";
  @override
  _ScreenSelectorState createState() => _ScreenSelectorState();
}

class _ScreenSelectorState extends State<ScreenSelector> {
  int _currentIndex = 0;
  final _screensList = [
    Home(),
    SizedBox(),
    SizedBox(),
    SizedBox(),
    ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _currentIndex != 4
          ? AppBar(
              title: Text("Instamaze"),
              elevation: 1.5,
              leading: Icon(Icons.camera),
              actions: <Widget>[
                IconButton(
                  icon: Icon(Icons.send),
                  onPressed: () {},
                ),
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
      body: _screensList[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.white,
        currentIndex: _currentIndex,
        onTap: (index) async {
          if (index == 2) {
            List<File> images;
            await Navigator.of(context)
                .pushNamed(PickImagesScreen.route, arguments: 10)
                .then((value) => images = value);
            if (images != null)
              Navigator.of(context).pushNamed(
                PreparePost.route,
                arguments: images,
              );
          } else if (index == 0 || index == 4)
            setState(() {
              _currentIndex = index;
            });
        },
        items: [
          BottomNavigationBarItem(
            icon: Icon(
              Icons.home,
              color: Colors.black,
            ),
            title: Text(""),
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.search,
              color: Colors.black,
            ),
            title: Text(""),
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.add_circle_outline,
              color: Colors.black,
            ),
            title: Text(""),
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.favorite_border,
              color: Colors.black,
            ),
            title: Text(""),
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.person_outline,
              color: Colors.black,
            ),
            title: Text(""),
          ),
        ],
      ),
    );
  }
}
