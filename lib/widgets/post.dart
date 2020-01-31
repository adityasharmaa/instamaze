import 'package:flutter/material.dart';
import 'package:insta/models/post_model.dart';
import 'package:insta/widgets/stories_list.dart';

class Post extends StatelessWidget {
  final PostModel _post;
  Post(this._post);

  @override
  Widget build(BuildContext context) {
    final _height = MediaQuery.of(context).size.height;
    return Container(
      width: double.infinity,
      child: _post != null ? Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.all(5),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                CircleAvatar(
                  backgroundImage: NetworkImage(
                    _post.images[0], //TODO fetch image of creator from database
                  ),
                ),
                SizedBox(width: 5),
                Text(
                  "pan_xiaoting",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ), //TODO fetch name of creator from database
                Expanded(
                  child: SizedBox(),
                ),
                Icon(
                  Icons.more_vert,
                  color: Colors.black,
                ),
              ],
            ),
          ),
          Container(
            height: _height * 0.45,
            width: double.infinity,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: NetworkImage(
                  _post.images[0], //TODO implement a carousel
                ),
                fit: BoxFit.cover,
              ),
              color: Colors.white,
            ),
          ),
          Row(
            children: <Widget>[
              //TODO Implement on clicks
              IconButton(
                icon: Icon(
                  Icons.favorite_border,
                  color: Colors.black,
                ),
                onPressed: () {},
              ),
              IconButton(
                icon: Icon(
                  Icons.chat_bubble_outline,
                  color: Colors.black,
                ),
                onPressed: () {},
              ),
              IconButton(
                icon: Icon(
                  Icons.send,
                  color: Colors.black,
                ),
                onPressed: () {},
              ),
              Expanded(
                child: SizedBox(),
              ),
              IconButton(
                icon: Icon(
                  Icons.bookmark_border,
                  color: Colors.black,
                ),
                onPressed: () {},
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(left: 10.0),
            child: Text(
              "${_post.likes} likes",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
            child: RichText(
              text: TextSpan(
                style: TextStyle(color: Colors.black),
                children: <TextSpan>[
                  TextSpan(
                    text: "pan_xiaoting ", //TODO fetch from database
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  TextSpan(
                    text: _post.caption,
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(left: 10),
            child: InkWell(
              child: Text(
                "View Comments",
                style: TextStyle(color: Colors.grey[400]),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(left: 10),
            child: InkWell(
              child: Text(
                _post.time,
                style: TextStyle(
                  color: Colors.grey[400],
                  fontSize: 10,
                ),
              ),
            ),
          ),
          SizedBox(height: 20),
        ],
      ) : StoriesList(),
    );
  }
}
