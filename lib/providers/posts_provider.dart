import 'package:flutter/foundation.dart';
import 'package:insta/models/post_model.dart';

class PostsProvider with ChangeNotifier{

  List<PostModel> _homePosts = [
    PostModel(
      id: "id",
      creatorId: "creatorId",
      images: ["http://www.bestchinanews.com/url.php?p=http://p1.qhimg.com/t01b707addd03c0c434.jpg"],
      likes: 5,
      time: "1 hour ago",
      caption: "Played my first match against a great billiards player, Ronnie O' Sullivan. It was a great experience and learned a lot about how he plays. Looking forward to play many such matches and hopefully beat him in one of them.",
    ),
    PostModel(
      id: "id",
      creatorId: "creatorId",
      images: ["https://www.wallpapermania.eu/images/lthumbs/2013-07/5248_Beautiful-Selena-Gomez-natural-smile.jpg"],
      likes: 5,
      time: "2 hour ago",
      caption: "Just finished shooting of the last episode of Wizards of Waverly Place.... couldn't control tears at the farewell. It has been a wonderful journey... gonna miss u guys.",
    ),
  ];

  List<PostModel> get homePosts{
    return [..._homePosts];
  }

  Future<void> fetchPosts() async{
    
  }

}