import 'package:flutter/material.dart';
import 'package:insta/providers/current_user_provider.dart';
import 'package:insta/providers/posts_provider.dart';
import 'package:insta/widgets/post.dart';
import 'package:provider/provider.dart';

class Home extends StatelessWidget {
  Widget _postsList(PostsProvider postsData) {
    return ListView.builder(
      itemCount: postsData.homePosts.length + 1,
      itemBuilder: (_, index) => Column(
        children: [
          Post(index == 0 ? null : postsData.homePosts[index - 1]),
          if (index == 0) Divider(height: 5)
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final postsData = Provider.of<PostsProvider>(context);
    final currentUser =
        Provider.of<CurrentUserProvider>(context, listen: false);

    return postsData.homePosts.isEmpty
        ? FutureBuilder(
            future: postsData.fetchPosts(currentUser.account.following),
            builder: (_, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting)
                return Center(
                  child: CircularProgressIndicator(),
                );
              if (snapshot.error != null)
                return Center(
                  child: Text("Error"),
                );
              return _postsList(postsData);
            },
          )
        : _postsList(postsData);
  }
}
