import 'package:flutter/material.dart';
import 'package:insta/helpers/converter.dart';
import 'package:insta/models/comment_model.dart';
import 'package:insta/providers/comment_creator_provider.dart';
import 'package:insta/providers/comments_provider.dart';
import 'package:insta/providers/current_user_provider.dart';
import 'package:provider/provider.dart';

class Comment extends StatelessWidget {
  final String commentCollectionId;
  final CommentModel _comment;
  final String image, username, content, time;
  Comment(this._comment, {this.commentCollectionId, this.image, this.username, this.content, this.time});

  Widget get _info {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        Text(
          Converter.timeSince(_comment == null ? time : _comment.time),
          style: TextStyle(
            color: Colors.grey,
            fontSize: 13,
          ),
        ),
        SizedBox(width: 20),
        if (_comment != null && _comment.likedBy.length > 0)
          Text(
            Converter.likes(_comment.likedBy.length) + " likes",
            style: TextStyle(
              color: Colors.grey,
              fontSize: 13,
              fontWeight: FontWeight.bold,
            ),
          ),
      ],
    );
  }

  Color _errorColor(dynamic e) {
    print(e.toString());
    return Colors.orange;
  }

  String get _content{
    final comment = _comment == null ? content : _comment.content;
    return comment;
  }

  @override
  Widget build(BuildContext context) {
    final _height = MediaQuery.of(context).size.longestSide;
    final _width = MediaQuery.of(context).size.shortestSide;
    final commentCreatorData = Provider.of<CommentCreatorProvider>(context);
    final currentUser = Provider.of<CurrentUserProvider>(context,listen: false).account;

    return Container(
      width: double.infinity,
      constraints: BoxConstraints(
        minHeight: _height * 0.08,
      ),
      padding: const EdgeInsets.only(
        top: 15,
        left: 15,
        right: 15,
        bottom: 10,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          _comment == null
              ? CircleAvatar(
                  backgroundImage: NetworkImage(image),
                )
              : commentCreatorData.commentCreators[_comment.creatorId] == null
                  ? FutureBuilder(
                      future: commentCreatorData
                          .getCommentCreator(_comment.creatorId),
                      builder: (_, snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting)
                          return CircleAvatar(
                            backgroundImage: AssetImage("assets/images/user_icon.png"),
                          );
                        if (snapshot.hasError)
                          return CircleAvatar(
                            backgroundColor: _errorColor(snapshot.error),
                          );
                        return CircleAvatar(
                          backgroundImage: NetworkImage(commentCreatorData.commentCreators[_comment.creatorId].image),
                        );
                      },
                    )
                  : CircleAvatar(
                      backgroundImage: NetworkImage(commentCreatorData.commentCreators[_comment.creatorId].image),
                    ),
          SizedBox(width: 10),
          SizedBox(
            width: _comment == null ? _width * 0.8 : _width * 0.65,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                RichText(
                  text: TextSpan(
                    style: TextStyle(color: Colors.black),
                    children: <TextSpan>[
                      TextSpan(
                          text: _comment == null
                              ? username + " "
                              : commentCreatorData.commentCreators[_comment.creatorId] == null
                                  ? "        "
                                  : commentCreatorData
                                          .commentCreators[_comment.creatorId]
                                          .username +
                                      " ",
                          style: TextStyle(fontWeight: FontWeight.w600)),
                      TextSpan(
                        text: _content,
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 5),
                _comment != null
                    ? _comment.status == 1
                        ? _info
                        : Text(
                            _comment.status == 0 ? "Posting..." : "Error",
                            style: TextStyle(
                              color: _comment.status == 0
                                  ? Colors.grey
                                  : Colors.red,
                              fontWeight: _comment.status == 0
                                  ? FontWeight.bold
                                  : FontWeight.normal,
                            ),
                          )
                    : _info
              ],
            ),
          ),
          Expanded(child: SizedBox()),
          if (_comment != null)
            IconButton(
              icon: Icon(
                _comment.likedBy.contains(currentUser.id) ? Icons.favorite : Icons.favorite_border,
                color: _comment.likedBy.contains(currentUser.id) ? Colors.red : Colors.grey,
                size: 14,
              ),
              onPressed: () {
                Provider.of<CommentsProvider>(context, listen: false).toggleLike(commentCollectionId, _comment.id, currentUser.id);
              },
            ),
        ],
      ),
    );
  }
}
