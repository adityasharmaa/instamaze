import 'package:flutter/material.dart';
import 'package:insta/models/story_model.dart';
import 'package:insta/providers/current_user_provider.dart';
import 'package:insta/widgets/circular_profile_image.dart';
import 'package:provider/provider.dart';

class Story extends StatelessWidget {
  final StoryModel _storyModel;
  Story(this._storyModel);
  @override
  Widget build(BuildContext context) {
    final _height = MediaQuery.of(context).size.longestSide;
    final currentUserAccount =
        Provider.of<CurrentUserProvider>(context, listen: false).account;
    return Padding(
      padding: const EdgeInsets.all(5),
      child: Column(
        children: <Widget>[
          //TODO fetch image and name of user from database
          SizedBox(
            child: CircularProfileImage(
              image: _storyModel != null
                  ? "http://www.bestchinanews.com/url.php?p=http://p1.qhimg.com/t01b707addd03c0c434.jpg"
                  : currentUserAccount.image,
              radius: _height * 0.035,
              showLittleAddIcon: _storyModel == null,
            ),
          ),
          SizedBox(height: 3),
          Text(
            _storyModel != null ? "pan_xiaoting" : "Your Story",
            style: TextStyle(fontSize: 12),
          ),
        ],
      ),
    );
  }
}
