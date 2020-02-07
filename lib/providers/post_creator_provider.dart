import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:insta/models/post_creator.dart';

class PostCreatorProvider with ChangeNotifier{
  Map<String,PostCreator> _postCreators = {};

  Map<String,PostCreator> get postCreators{
    return {..._postCreators};
  }

  Future<void> getPostCreator(String accountId) async{
    final response = await Firestore.instance.collection("insta_users").document(accountId).get();

    _postCreators.putIfAbsent(accountId, () => PostCreator.fromDocumentSnapshot(response));
    notifyListeners();
  }
}