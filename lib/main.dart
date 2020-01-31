import 'package:flutter/material.dart';
import 'package:insta/providers/current_user_provider.dart';
import 'package:insta/screens/change_username_screen.dart';
import 'package:insta/screens/welcome_screen.dart';
import 'package:provider/provider.dart';

import 'screens/enter_name_and_password.dart';
import 'providers/posts_provider.dart';
import 'providers/stories_provider.dart';
import 'screens/add_date_of_birth.dart';
import 'screens/edit_profile.dart';
import 'screens/login_screen.dart';
import 'screens/screen_selector.dart';
import 'screens/sign_up_screen.dart';
import 'screens/splash_screen.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(
          value: PostsProvider(),
        ),
        ChangeNotifierProvider.value(
          value: StoriesProvider(),
        ),
        ChangeNotifierProvider.value(
          value: CurrentUserProvider(),
        ),
      ],
      child: MaterialApp(
        title: 'Instamaze',
        theme: ThemeData(
          primaryColor: Colors.white,
          accentColor: Colors.black,
        ),
        home: SplashScreen(),
        routes: {
          ScreenSelector.route: (_) => ScreenSelector(),
          LoginScreen.route: (_) => LoginScreen(),
          EditProfile.route: (_) => EditProfile(),
          SignUpScreen.route: (_) => SignUpScreen(),
          EnterNameAndPassword.route: (_) => EnterNameAndPassword(),
          AddDateOfBirth.route: (_) => AddDateOfBirth(),
          WelcomeScreen.route: (_) => WelcomeScreen(),
          ChangeUsernameScreen.route: (_) => ChangeUsernameScreen(),
        },
      ),
    );
  }
}
