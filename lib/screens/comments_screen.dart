import 'package:flutter/material.dart';
import 'package:insta/models/creator.dart';
import 'package:insta/models/post_model.dart';
import 'package:insta/providers/comments_provider.dart';
import 'package:insta/providers/current_user_provider.dart';
import 'package:insta/widgets/comment.dart';
import 'package:provider/provider.dart';

class CommentsScreen extends StatefulWidget {
  static const route = "/comments_screen";

  @override
  _CommentsScreenState createState() => _CommentsScreenState();
}

class _CommentsScreenState extends State<CommentsScreen> {
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _init();
  }

  void _init() {
    Future.delayed(Duration(milliseconds: 0), () async {
      final PostModel post = (ModalRoute.of(context).settings.arguments as Map<String, dynamic>)["post"];
      await Provider.of<CommentsProvider>(context, listen: false).fetchComments(post.id);
      setState(() {
        _isLoading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final Creator postCreator = (ModalRoute.of(context).settings.arguments as Map<String, dynamic>)["post_creator"];
    final PostModel post = (ModalRoute.of(context).settings.arguments as Map<String, dynamic>)["post"];
    final comments = Provider.of<CommentsProvider>(context).comments;

    return Scaffold(
      appBar: AppBar(
        title: Text("Comments"),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.send),
            onPressed: () {},
          ),
        ],
        elevation: 1.5,
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: ListView.builder(
              itemCount: _isLoading ? 2 : comments.length + 1,
              itemBuilder: (_, i) {
                if (i == 0)
                  return Column(
                    children: <Widget>[
                      Comment(
                        null,
                        image: postCreator.image,
                        username: postCreator.username,
                        content: post.caption,
                        time: post.time,
                      ),
                      Divider(height: 0),
                    ],
                  );
                return _isLoading
                    ? Center(
                        child: Padding(
                          padding: const EdgeInsets.only(top: 20),
                          child: CircularProgressIndicator(),
                        ),
                      )
                    : Comment(comments[i - 1], commentCollectionId: post.id);
              },
            ),
          ),
          AddCommentField(post.id),
        ],
      ),
    );
  }
}

class AddCommentField extends StatefulWidget {
  final String _postId;
  AddCommentField(this._postId);
  @override
  _AddCommentFieldState createState() => _AddCommentFieldState();
}

class _AddCommentFieldState extends State<AddCommentField> {
  bool _isEmpty = true;
  final _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final currentUser =
        Provider.of<CurrentUserProvider>(context).account;
    final _width = MediaQuery.of(context).size.shortestSide;
    return Container(
      width: _width,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Divider(height: 0),
          Padding(
            padding: const EdgeInsets.symmetric(
              vertical: 5,
              horizontal: 10,
            ),
            child: Row(
              children: <Widget>[
                CircleAvatar(
                  backgroundImage: currentUser.image != null
                      ? NetworkImage(currentUser.image)
                      : AssetImage("assets/images/user_icon.png"),
                ),
                SizedBox(width: 10),
                Expanded(
                  child: TextFormField(
                    decoration: InputDecoration.collapsed(
                      hintText: "Add a comment...",
                    ),
                    keyboardType: TextInputType.multiline,
                    onChanged: (value) {
                      setState(() {
                        _isEmpty = value.trim().isEmpty;
                      });
                    },
                    controller: _controller,
                  ),
                ),
                InkWell(
                  onTap: _isEmpty
                      ? null
                      : () {
                          Provider.of<CommentsProvider>(context, listen: false)
                              .addComment(widget._postId, {
                            "creator_id": currentUser.id,
                            "content": _controller.text,
                            "time": DateTime.now().toIso8601String(),
                          });

                          setState(() {
                            _controller.clear();
                            _isEmpty = true;
                          });
                        },
                  child: SizedBox(
                    height: 30,
                    child: Center(
                      child: Text(
                        "Post",
                        style: TextStyle(
                            color: _isEmpty ? Colors.blue[100] : Colors.blue),
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 5),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
