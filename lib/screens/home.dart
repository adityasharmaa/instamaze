import 'package:flutter/material.dart';
import 'package:insta/providers/posts_provider.dart';
import 'package:insta/widgets/post.dart';
import 'package:provider/provider.dart';

class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final postsData = Provider.of<PostsProvider>(context, listen: false);
    return FutureBuilder(
      future: postsData.fetchPosts(),
      builder: (_, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting)
          return Center(
            child: CircularProgressIndicator(),
          );
        if (snapshot.error != null)
          return Center(
            child: Text("Error"),
          );
        return ListView.builder(
          itemCount: postsData.homePosts.length + 1,
          itemBuilder: (_, index) => Column(children: [
            Post(index == 0 ? null : postsData.homePosts[index - 1]),
            if (index == 0)
              Divider(height: 5,),
          ]),
        );
      },
    );
  }
}
