import 'package:flutter/material.dart';
import 'package:insta/models/story_model.dart';

class Story extends StatelessWidget {
  final StoryModel _storyModel;
  Story(this._storyModel);
  @override
  Widget build(BuildContext context) {
    final _height = MediaQuery.of(context).size.longestSide;
    return Padding(
      padding: const EdgeInsets.all(5),
      child: Column(
        children: <Widget>[
          //TODO fetch image and name of user from database
          SizedBox(
            child: Stack(
              children: <Widget>[
                CircleAvatar(
                  backgroundImage: _storyModel != null
                      ? NetworkImage(
                          "http://www.bestchinanews.com/url.php?p=http://p1.qhimg.com/t01b707addd03c0c434.jpg",
                        )
                      : AssetImage("assets/images/user_icon.png"),
                  radius: _height * 0.035,
                ),
                if (_storyModel == null)
                  Positioned(
                    right: 0,
                    bottom: 0,
                    child: Icon(
                      Icons.add_circle,
                      color: Colors.blue,
                      size: 15,
                    ),
                  ),
              ],
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
