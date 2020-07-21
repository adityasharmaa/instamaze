import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:insta/models/creator.dart';

class CommentCreatorProvider with ChangeNotifier{

  Map<String,Creator> _commentCreators = {};

  Map<String,Creator> get commentCreators{
    return {..._commentCreators};
  }

  Future<void> getCommentCreator(String accountId) async{
    final response = await Firestore.instance.collection("insta_users").document(accountId).get();

    _commentCreators.putIfAbsent(accountId, () => Creator.fromDocumentSnapshot(response));
    notifyListeners();
  }
}