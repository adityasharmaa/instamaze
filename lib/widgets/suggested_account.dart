import 'package:flutter/material.dart';
import 'package:insta/helpers/converter.dart';
import 'package:insta/models/account.dart';
import 'package:insta/providers/accounts_suggestion_provider.dart';
import 'package:insta/providers/current_user_provider.dart';
import 'package:insta/widgets/small_button.dart';
import 'package:provider/provider.dart';

class SuggestedAccount extends StatelessWidget {
  final Account _account;
  SuggestedAccount(this._account);

  bool following(CurrentUserProvider currentUser) {
    if (currentUser.account.following == null) return false;
    return currentUser.account.following.contains(_account.id);
  }

  Widget _postsQueue() {
    return Row(
      children: <Widget>[
        Flexible(
          child: SuggestedAccountImage(
            isLeftEnd: true,
            image: _account.posts[0].images[0],
          ),
        ),
        SizedBox(width: 1),
        Flexible(
          child: SuggestedAccountImage(
            image: _account.posts[1].images[0],
          ),
        ),
        SizedBox(width: 1),
        Flexible(
          child: SuggestedAccountImage(
            isRightEnd: true,
            image: _account.posts[2].images[0],
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final _height = MediaQuery.of(context).size.longestSide;
    final _width = MediaQuery.of(context).size.shortestSide;
    final suggestions =
        Provider.of<AccountsSuggestionProvider>(context, listen: false);
    final currentUser = Provider.of<CurrentUserProvider>(context);

    return Container(
      height: _account != null ? _height * 0.25 : _height * 0.2,
      width: double.infinity,
      child: _account == null
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    "Choose accounts to follow",
                    style: TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: 15),
                  Text(
                    "You can follow or unfollow accounts at any time.",
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            )
          : Column(
              children: <Widget>[
                Row(
                  children: <Widget>[
                    CircleAvatar(
                      backgroundImage: NetworkImage(_account.image),
                      radius: _height * 0.0375,
                    ),
                    SizedBox(width: 10),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(_account.username),
                        Text(
                          _account.name,
                          style: TextStyle(color: Colors.grey),
                        ),
                        Text(
                          "${Converter.shortCount(_account.followers.length)} Followers",
                          style: TextStyle(
                            color: Colors.grey,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                    Expanded(child: SizedBox()),
                    SmallButton(
                      width: _width * 0.17,
                      label: following(currentUser) ? "Following" : "Follow",
                      action: () {
                        if (following(currentUser)) {
                          currentUser.unfollowAccount(_account.id);
                          suggestions.unfollowAccount(
                              _account.id, currentUser.account.id);
                        } else {
                          currentUser.followAccount(_account.id);
                          suggestions.followAccount(
                              _account.id, currentUser.account.id);
                        }
                      },
                      isBoundary: following(currentUser),
                    ),
                  ],
                ),
                SizedBox(height: 10),
                suggestions.suggestedAccounts[0].posts != null
                    ? _postsQueue()
                    : StreamBuilder(
                        stream: suggestions.getPostsForAccount(_account.id),
                        builder: (_, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting)
                            return Container(
                              height: _height * 0.15,
                              width: double.infinity,
                              child: Center(child: Text("Loading...")),
                            );
                          if (snapshot.error != null)
                            return Container(
                              height: _height * 0.15,
                              width: double.infinity,
                              child: Center(child: Text("Error")),
                            );
                          return _postsQueue();
                        },
                      ),
              ],
            ),
    );
  }
}

class SuggestedAccountImage extends StatelessWidget {
  final bool isLeftEnd;
  final bool isRightEnd;
  final String image;

  SuggestedAccountImage({
    this.isLeftEnd = false,
    this.isRightEnd = false,
    @required this.image,
  });

  @override
  Widget build(BuildContext context) {
    final _height = MediaQuery.of(context).size.longestSide;
    return Container(
      height: _height * 0.15,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: NetworkImage(
            image,
          ),
          fit: BoxFit.cover,
        ),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(isLeftEnd ? 5 : 0),
          bottomLeft: Radius.circular(isLeftEnd ? 5 : 0),
          bottomRight: Radius.circular(isRightEnd ? 5 : 0),
          topRight: Radius.circular(isRightEnd ? 5 : 0),
        ),
      ),
    );
  }
}
