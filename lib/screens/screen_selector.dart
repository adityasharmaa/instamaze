import 'package:flutter/material.dart';
import 'package:insta/helpers/firebase_auth.dart';
import 'package:insta/providers/posts_provider.dart';
import 'package:insta/screens/home.dart';
import 'package:insta/screens/login_screen.dart';
import 'package:provider/provider.dart';
import 'package:insta/helpers/google_sign_in.dart' show googleSignIn;

class ScreenSelector extends StatefulWidget {
  static const route = "/screen_selector";
  @override
  _ScreenSelectorState createState() => _ScreenSelectorState();
}

class _ScreenSelectorState extends State<ScreenSelector> {
  int _currentIndex = 0;
  final _screensList = [Home()];
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: PostsProvider(),
      child: Scaffold(
        appBar: AppBar(
          title: Text("Instamaze"),
          leading: Icon(Icons.camera),
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.send),
              onPressed: (){},
            ),
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
        body: _screensList[0], //TODO implement multiple screens
        bottomNavigationBar: BottomNavigationBar(
          backgroundColor: Colors.white,
          currentIndex: _currentIndex,
          onTap: (index) => setState(() {
            _currentIndex = index;
          }),
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
      ),
    );
  }
}