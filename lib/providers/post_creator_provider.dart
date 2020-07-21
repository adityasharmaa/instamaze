import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:insta/models/creator.dart';

class PostCreatorProvider with ChangeNotifier{
  Map<String,Creator> _postCreators = {};

  Map<String,Creator> get postCreators{
    return {..._postCreators};
  }

  Future<void> getPostCreator(String accountId) async{
    final response = await Firestore.instance.collection("insta_users").document(accountId).get();

    _postCreators.putIfAbsent(accountId, () => Creator.fromDocumentSnapshot(response));
    notifyListeners();
  }

  void updateCurrentUserPosts(String userId, String username, String image){
    _postCreators.update(userId, (value) => Creator(
      image: image ?? value.image,
      username: username ?? value.username,
    ));
    notifyListeners();
  }
}