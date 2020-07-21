import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:insta/models/comment_model.dart';

class CommentsProvider with ChangeNotifier {
  List<CommentModel> _comments = [];

  List<CommentModel> get comments {
    return [..._comments];
  }

  Future<void> fetchComments(String postId) async {
    final response = await Firestore.instance
        .collection("insta_comments")
        .document(postId)
        .collection("comments")
        .orderBy("time",descending: true)
        .getDocuments();

    _comments = response.documents
        .map((documentSnapshot) =>
            CommentModel.fromDocumentSnapshot(documentSnapshot))
        .toList();
    notifyListeners();
  }

  Future<void> addComment(String postId, Map<String, String> data) async {
    final commentId = DateTime.now().toIso8601String();
    final comment = CommentModel(
      id: commentId,
      creatorId: data["creator_id"],
      content: data["content"],
      time: data["time"],
      status: 0,
      likedBy: [],
    );

    _comments.insert(0, comment);
    notifyListeners();

    try {
      await Firestore.instance
          .collection("insta_comments")
          .document(postId)
          .collection("comments")
          .document(commentId)
          .setData(data);
      _comments[0].status = 1;
      notifyListeners();
    } catch (e) {
      _comments[0].status = -1;
      notifyListeners();
      print(e.toString());
      throw e;
    }
  }

  Future<void> toggleLike(String commentCollectionId, String commentId, String userId) async{
    int index = _comments.indexWhere((comment) => comment.id == commentId);

    bool liked = _comments[index].likedBy.contains(userId);

    if(!liked)
      _comments[index].likedBy.add(userId);
    else
      _comments[index].likedBy.remove(userId);
    notifyListeners();

    try{
      await Firestore.instance.collection("insta_comments").document(commentCollectionId).collection("comments").document(commentId).updateData({
        "liked_by": liked ? FieldValue.arrayRemove([userId]) : FieldValue.arrayUnion([userId]),
      });
    }
    catch(e){
      if(liked)
        _comments[index].likedBy.add(userId);
      else
        _comments[index].likedBy.remove(userId);
      notifyListeners();
      throw e;
    }
  }

}