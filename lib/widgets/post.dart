import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:insta/helpers/converter.dart';
import 'package:insta/models/post_model.dart';
import 'package:insta/providers/post_creator_provider.dart';
import 'package:insta/widgets/stories_list.dart';
import 'package:provider/provider.dart';

class Post extends StatelessWidget {
  final PostModel _post;
  Post(this._post);

  @override
  Widget build(BuildContext context) {
    final _height = MediaQuery.of(context).size.height;
    final posts = Provider.of<PostCreatorProvider>(context);
    return Container(
      width: double.infinity,
      child: _post != null
          ? Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.all(5),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      CircleAvatar(
                        backgroundImage:
                            posts.postCreators[_post.creatorId] == null
                                ? null
                                : NetworkImage(
                                    posts.postCreators[_post.creatorId].image),
                      ),
                      SizedBox(width: 5),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          posts.postCreators[_post.creatorId] == null
                              ? FutureBuilder(
                                  future: posts.getPostCreator(_post.creatorId),
                                  builder: (_, snapshot) {
                                    if (snapshot.connectionState ==
                                        ConnectionState.waiting)
                                      return Text(
                                        "CREATOR",
                                        style: TextStyle(
                                            fontStyle: FontStyle.italic),
                                      );
                                    if (snapshot.hasError)
                                      return Text(
                                        "ERROR",
                                        style: TextStyle(
                                          fontStyle: FontStyle.italic,
                                          color: Colors.red,
                                        ),
                                      );
                                    return Text(
                                      posts.postCreators[_post.creatorId]
                                          .username,
                                      style: TextStyle(
                                          fontWeight: FontWeight.w600),
                                    );
                                  },
                                )
                              : Text(
                                  posts.postCreators[_post.creatorId].username,
                                  style: TextStyle(fontWeight: FontWeight.w600),
                                ),
                          if (_post.place != null)
                            Text(
                              _post.place,
                              style: TextStyle(fontSize: 12),
                            ),
                        ],
                      ),
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
                  child: CarouselSlider(
                    height: _height * 0.45,
                    items: _post.images
                        .map((image) => Image.network(
                              image,
                              fit: BoxFit.cover,
                              width: double.infinity,
                            ))
                        .toList(),
                    enableInfiniteScroll: false,
                    viewportFraction: 1.0,
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
                    "${Converter.shortCount(_post.likes)} likes",
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
                          text: posts.postCreators[_post.creatorId] == null
                              ? "CREATOR "
                              : posts.postCreators[_post.creatorId].username +
                                  " ", //TODO fetch from database
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
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
                    onTap: () {},
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(left: 10),
                  child: InkWell(
                    child: Text(
                      Converter.timeSince(_post.time),
                      style: TextStyle(
                        color: Colors.grey[400],
                        fontSize: 10,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 20),
              ],
            )
          : StoriesList(),
    );
  }
}
