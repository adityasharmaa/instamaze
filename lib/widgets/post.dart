import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:insta/helpers/converter.dart';
import 'package:insta/models/post_model.dart';
import 'package:insta/providers/current_user_provider.dart';
import 'package:insta/providers/post_creator_provider.dart';
import 'package:insta/providers/posts_provider.dart';
import 'package:insta/screens/comments_screen.dart';
import 'package:insta/widgets/carousel_indicator.dart';
import 'package:insta/widgets/stories_list.dart';
import 'package:provider/provider.dart';

class Post extends StatelessWidget {
  final PostModel _post;
  Post(this._post);

  @override
  Widget build(BuildContext context) {
    final posts = Provider.of<PostCreatorProvider>(context);

    return Container(
      width: double.infinity,
      child: _post != null
          ? _post.status == PostStatus.FINISHED
              ? Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.all(5),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          CircleAvatar(
                            backgroundImage: posts
                                        .postCreators[_post.creatorId] ==
                                    null
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
                                      future:
                                          posts.getPostCreator(_post.creatorId),
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
                                      posts.postCreators[_post.creatorId]
                                          .username,
                                      style: TextStyle(
                                          fontWeight: FontWeight.w600),
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
                    Carousel(_post),
                  ],
                )
              : FinishingUpNewPost(_post)
          : StoriesList(),
    );
  }
}

class FinishingUpNewPost extends StatelessWidget {
  final PostModel _post;
  FinishingUpNewPost(this._post);

  @override
  Widget build(BuildContext context) {
    final _height = MediaQuery.of(context).size.longestSide;
    final _width = MediaQuery.of(context).size.shortestSide;

    return Container(
      margin: EdgeInsets.symmetric(
        horizontal: 5,
      ),
      height: _height * 0.07,
      width: _width,
      child: Column(
        children: <Widget>[
          Expanded(child: SizedBox()),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Container(
                height: _height * 0.05,
                width: _height * 0.05,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: FileImage(_post.newPostImages[0]),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              SizedBox(width: 10),
              Icon(
                _post.status == PostStatus.ERROR
                    ? Icons.error_outline
                    : _post.status == PostStatus.UPLOADING_IMAGES
                        ? Icons.timelapse
                        : Icons.done,
                color: Colors.grey,
              ),
              SizedBox(width: 10),
              Text(
                _post.status == PostStatus.UPLOADING_IMAGES
                    ? "Uploading... (${_post.images.length + 1} of ${_post.newPostImages.length})"
                    : _post.status == PostStatus.CREATING_POST
                        ? "Finishing up"
                        : "Error",
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
            ],
          ),
          Expanded(child: SizedBox()),
          Divider(height: 0),
        ],
      ),
    );
  }
}

class PostNumber extends StatelessWidget {
  final int current, total;
  PostNumber(this.current, this.total);
  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.longestSide * 0.03,
      padding: const EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
        color: Colors.black87,
      ),
      child: Center(
        child: Text(
          "$current/$total",
          style: TextStyle(
            color: Colors.white,
            fontSize: 13,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}

class Carousel extends StatefulWidget {
  final PostModel _post;
  Carousel(this._post);
  @override
  _CarouselState createState() => _CarouselState();
}

class _CarouselState extends State<Carousel> {
  int _currentIndex = 0;
  @override
  Widget build(BuildContext context) {
    final _height = MediaQuery.of(context).size.longestSide;
    final postsData = Provider.of<PostsProvider>(context, listen: false);
    final currentUser =
        Provider.of<CurrentUserProvider>(context, listen: false).account;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        InkWell(
          onDoubleTap: () {
            postsData.toggleLike(widget._post.id, currentUser.id);
          },
          child: Container(
            height: _height * 0.45,
            width: double.infinity,
            child: Stack(
              children: <Widget>[
                CarouselSlider(
                  height: _height * 0.45,
                  items: widget._post.images
                      .map((image) => Image.network(
                            image,
                            fit: BoxFit.cover,
                            width: double.infinity,
                          ))
                      .toList(),
                  enableInfiniteScroll: false,
                  viewportFraction: 1.0,
                  onPageChanged: (i) => setState(() {
                    _currentIndex = i;
                  }),
                ),
                if (widget._post.images.length > 1)
                  Positioned(
                    top: 15,
                    right: 15,
                    child: PostNumber(
                      _currentIndex + 1,
                      widget._post.images.length,
                    ),
                  ),
              ],
            ),
          ),
        ),
        BottomTray(widget._post, _currentIndex),
        Footer(widget._post),
      ],
    );
  }
}

class BottomTray extends StatelessWidget {
  final PostModel _post;
  final int _currentIndex;

  BottomTray(this._post, this._currentIndex);

  @override
  Widget build(BuildContext context) {
    final _height = MediaQuery.of(context).size.longestSide;
    final currentUser =
        Provider.of<CurrentUserProvider>(context, listen: false).account;
    final posts = Provider.of<PostCreatorProvider>(context, listen: false);

    return SizedBox(
      height: _height * 0.055,
      width: double.infinity,
      child: Stack(
        children: <Widget>[
          if (_post.images.length > 1)
            Positioned.fill(
              child: CarouselIndicator(
                currentIndex: _currentIndex,
                count: _post.images.length,
              ),
            ),
          Row(
            children: <Widget>[
              Consumer<PostsProvider>(
                builder: (_, postsData, __) => IconButton(
                  icon: Icon(
                    _post.isFavorite(currentUser.id)
                        ? Icons.favorite
                        : Icons.favorite_border,
                    color: _post.isFavorite(currentUser.id)
                        ? Colors.red
                        : Colors.black,
                  ),
                  onPressed: () {
                    postsData.toggleLike(_post.id, currentUser.id);
                  },
                ),
              ),
              IconButton(
                icon: Icon(
                  Icons.chat_bubble_outline,
                  color: Colors.black,
                ),
                onPressed: () {
                  Navigator.of(context).pushNamed(
                    CommentsScreen.route,
                    arguments: {
                      "post": _post,
                      "post_creator": posts.postCreators[_post.creatorId]
                    },
                  );
                },
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
        ],
      ),
    );
  }
}

class Footer extends StatelessWidget {
  final PostModel _post;
  Footer(this._post);
  @override
  Widget build(BuildContext context) {
    final posts = Provider.of<PostCreatorProvider>(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(left: 10.0),
          child: Consumer<PostsProvider>(
            builder: (_, __, ___) => Text(
              "${Converter.shortCount(_post.likedBy.length)} likes",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
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
                      : posts.postCreators[_post.creatorId].username + " ",
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
            onTap: () {
              Navigator.of(context).pushNamed(CommentsScreen.route, arguments: {
                "post": _post,
                "post_creator": posts.postCreators[_post.creatorId]
              });
            },
          ),
        ),
        Padding(
          padding: EdgeInsets.only(left: 10),
          child: InkWell(
            child: Text(
              Converter.timeSince(_post.time, isPost: true),
              style: TextStyle(
                color: Colors.grey[400],
                fontSize: 10,
              ),
            ),
          ),
        ),
        SizedBox(height: 20),
      ],
    );
  }
}
