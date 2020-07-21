import 'package:flutter/material.dart';
import 'package:insta/providers/comments_provider.dart';
import 'package:insta/providers/post_creator_provider.dart';
import 'package:insta/screens/edit_personal_information.dart';
import 'package:insta/screens/pick_images_screen.dart';
import 'package:insta/screens/comments_screen.dart';
import 'package:insta/screens/multi_image_picker_example.dart';
import 'package:insta/screens/prepare_post.dart';
import 'package:provider/provider.dart';

import 'providers/comment_creator_provider.dart';
import 'screens/enter_name_and_password.dart';
import 'providers/posts_provider.dart';
import 'providers/stories_provider.dart';
import 'screens/add_date_of_birth.dart';
import 'screens/edit_profile.dart';
import 'screens/login_screen.dart';
import 'screens/screen_selector.dart';
import 'screens/sign_up_screen.dart';
import 'screens/splash_screen.dart';
import 'providers/accounts_suggestion_provider.dart';
import 'providers/current_user_provider.dart';
import 'screens/accounts_suggestion.dart';
import 'screens/change_username_screen.dart';
import 'screens/welcome_screen.dart';

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
        ChangeNotifierProvider.value(
          value: AccountsSuggestionProvider(),
        ),
        ChangeNotifierProvider.value(
          value: PostCreatorProvider(),
        ),
        ChangeNotifierProvider.value(
          value: CommentsProvider(),
        ),
        ChangeNotifierProvider.value(
          value: CommentCreatorProvider(),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
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
          AccountsSuggestionScreen.route: (_) => AccountsSuggestionScreen(),
          CommentsScreen.route: (_) => CommentsScreen(),
          PickImagesScreen.route: (_) => PickImagesScreen(),
          PreparePost.route: (_) => PreparePost(),
          MultipleImagePicker.route: (_) => MultipleImagePicker(),
          EditPersonalInformation.route: (_) => EditPersonalInformation(),
        },
      ),
    );
  }
}
