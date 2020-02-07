import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:insta/models/post_model.dart';

class PostsProvider with ChangeNotifier{

  List<PostModel> _homePosts = [];

  List<PostModel> get homePosts{
    return [..._homePosts];
  }

  Future<void> fetchPosts(List<String> following) async{
    final response = await Firestore.instance.collection("posts").where("creator_id", whereIn: following).orderBy("time",descending: true).getDocuments();

    _homePosts = response.documents.map((snapshot) => PostModel.fromDocumentSnapshot(snapshot)).toList();
    notifyListeners();
  }
}