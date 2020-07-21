import 'dart:io';

import 'package:flutter/material.dart';
import 'package:insta/models/post_model.dart';
import 'package:insta/providers/current_user_provider.dart';
import 'package:insta/providers/posts_provider.dart';
import 'package:provider/provider.dart';

class PreparePost extends StatefulWidget {
  static const route = "/prepare_post";
  @override
  _PreparePostState createState() => _PreparePostState();
}

class _PreparePostState extends State<PreparePost> {
  final _captionController = TextEditingController();
  final _locationController = TextEditingController();
  bool _commenting = true;

  void createNewPost(List<File> images) {
    final currentUser =
        Provider.of<CurrentUserProvider>(context, listen: false).account;
    final time = DateTime.now().toIso8601String();
    final newPost = PostModel(
      id: time,
      creatorId: currentUser.id,
      time: time,
      images: [],
      caption: _captionController.text,
      place: _locationController.text,
      newPostImages: images,
      status: PostStatus.UPLOADING_IMAGES,
      likedBy: [],
    );
    Provider.of<PostsProvider>(context, listen: false).createPost(newPost);
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final _height = MediaQuery.of(context).size.longestSide;
    final _width = MediaQuery.of(context).size.shortestSide;

    final List<File> _images = ModalRoute.of(context).settings.arguments;

    return Scaffold(
      appBar: AppBar(
        elevation: 1.5,
        leading: InkWell(
          onTap: () => Navigator.of(context).pop(),
          child: InkWell(
            child: Icon(Icons.chevron_left),
            onTap: () {
              Navigator.of(context).pop();
            },
          ),
        ),
        title: Text("New Post"),
        actions: <Widget>[
          Center(
            child: InkWell(
              child: Text(
                "Share",
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  color: Colors.blue,
                  fontSize: 18,
                ),
              ),
              onTap: () => createNewPost(_images),
            ),
          ),
          SizedBox(
            width: 20,
          ),
        ],
      ),
      body: Column(
        children: <Widget>[
          Container(
            margin: EdgeInsets.symmetric(
              horizontal: 10,
              vertical: 10,
            ),
            width: _width,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(
                  height: _height * 0.1 * (5 / 7),
                  width: _height * 0.1 * (5 / 7),
                  child: Image.file(
                    _images[0],
                    fit: BoxFit.cover,
                  ),
                ),
                SizedBox(width: 10),
                Expanded(
                  child: TextField(
                    decoration: InputDecoration.collapsed(
                      hintText: "Write a caption...",
                    ),
                    controller: _captionController,
                    keyboardType: TextInputType.multiline,
                    maxLines: null,
                  ),
                ),
              ],
            ),
          ),
          Divider(height: 0),
          Container(
            constraints: BoxConstraints(
              minHeight: _height * 0.06,
            ),
            margin: EdgeInsets.symmetric(
              horizontal: 10,
            ),
            child: Align(
              alignment: Alignment.center,
              child: TextField(
                decoration: InputDecoration.collapsed(
                  hintText: "Add Location...",
                ),
                controller: _locationController,
                keyboardType: TextInputType.multiline,
                maxLines: null,
              ),
            ),
          ),
          Divider(height: 0),
          SizedBox(
            height: _height * 0.06,
            width: _width,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                SizedBox(width: 10),
                Text("Commenting"),
                Expanded(child: SizedBox()),
                Switch(
                  value: _commenting,
                  onChanged: (status) {
                    setState(() {
                      _commenting = status;
                    });
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
