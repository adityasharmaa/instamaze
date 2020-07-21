import 'package:flutter/material.dart';
import 'package:insta/models/post_model.dart';
import 'package:insta/providers/current_user_provider.dart';
import 'package:insta/providers/posts_provider.dart';
import 'package:insta/screens/edit_profile.dart';
import 'package:insta/widgets/circular_profile_image.dart';
import 'package:provider/provider.dart';

class ProfileScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return SafeArea(
      child: Container(
        color: Colors.grey[50],
        height: size.height,
        width: size.width,
        child: Column(
          children: [
            TopBar(),
            Header(),
            Divider(height: 1),
            Expanded(child: Posts()),
          ],
        ),
      ),
    );
  }
}

class TopBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final currentUser =
        Provider.of<CurrentUserProvider>(context).account;
    final size = MediaQuery.of(context).size;
    return Container(
      height: size.width / 8,
      width: size.width,
      child: Row(
        children: [
          SizedBox(width: 20),
          Text(
            currentUser.username,
            style: TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: 20,
            ),
          ),
          Icon(Icons.keyboard_arrow_down),
          Expanded(child: SizedBox()),
          IconButton(
            icon: Icon(
              Icons.menu,
              color: Colors.black,
            ),
            onPressed: null,
          ),
        ],
      ),
    );
  }
}

class Header extends StatelessWidget {
  Widget _count(String subject, int count, double width) {
    return Container(
      width: width,
      child: Center(
        child: Column(
          children: [
            Text(
              "$count",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
            SizedBox(height: 10),
            Text(subject),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final countWidth = (size.width - 40 - size.height * 0.12) / 3;
    final currentUser = Provider.of<CurrentUserProvider>(context).account;
    return Container(
      height: currentUser.bio.isEmpty ? size.height * 0.25 : size.height * 0.25 + 20,
      width: size.width,
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Column(
                children: [
                  CircularProfileImage(
                    image: currentUser.image,
                    radius: size.height * 0.06,
                    showLittleAddIcon: true,
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  SizedBox(
                    width: size.height * 0.12,
                    child: FittedBox(
                      fit: BoxFit.contain,
                      child: Text(
                        currentUser.name,
                        style: TextStyle(fontWeight: FontWeight.w500),
                      ),
                    ),
                  ),
                ],
              ),
              _count(
                "Posts",
                currentUser.posts.length, //currentUserAccount.posts.length,
                countWidth,
              ),
              _count(
                "Followers",
                currentUser.followers.length,
                countWidth,
              ),
              _count(
                "Following",
                currentUser.following.length,
                countWidth,
              ),
            ],
          ),
          if(currentUser.bio.isNotEmpty)
            Text(currentUser.bio),
          Expanded(child: SizedBox()),
          GestureDetector(
            onTap: () {
              Navigator.of(context).pushNamed(EditProfile.route);
            },
            child: Container(
              height: 30,
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(
                  width: 1,
                  color: Colors.grey[300],
                ),
                borderRadius: BorderRadius.circular(5),
              ),
              child: Center(
                child: Text(
                  "Edit Profile",
                  style: TextStyle(fontWeight: FontWeight.w500),
                ),
              ),
            ),
          ),
          Expanded(child: SizedBox()),
        ],
      ),
    );
  }
}

class Posts extends StatelessWidget {
  Widget _postsInGridView(BuildContext context, List<PostModel> posts) {
    final currentUser =
        Provider.of<CurrentUserProvider>(context, listen: false);
    Future.delayed(Duration(milliseconds: 0), () {
      currentUser.updatePosts(posts);
    });

    return GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        childAspectRatio: 1,
      ),
      itemCount: posts.length,
      itemBuilder: (context, i) => Container(
        color: Colors.white,
        padding: EdgeInsets.all(1),
        child: Stack(
          children: [
            Image.network(
              posts[i].images[0],
              fit: BoxFit.cover,
              height: double.maxFinite,
              width: double.maxFinite,
            ),
            if (posts[i].images.length > 1)
              Positioned(
                right: 10,
                top: 10,
                child: Icon(
                  Icons.collections,
                  color: Colors.white70,
                  size: 15,
                ),
              ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final currentUser =
        Provider.of<CurrentUserProvider>(context, listen: false).account;
    final posts = Provider.of<PostsProvider>(context).homePosts;
    return Container(
      width: size.width,
      constraints: BoxConstraints(
        minHeight: size.height * 0.3,
      ),
      child: posts.isEmpty
          ? Center(
              child: CircularProgressIndicator(),
            )
          : _postsInGridView(
              context,
              posts
                  .where((post) =>
                      post.creatorId == currentUser.id &&
                      post.status == PostStatus.FINISHED)
                  .toList(),
            ),
    );
  }
}
