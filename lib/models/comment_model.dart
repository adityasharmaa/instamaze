import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

class CommentModel {
  final String id, creatorId, content, time;
  final List<String> likedBy;
  int status;

  CommentModel({
    @required this.id,
    @required this.creatorId,
    @required this.content,
    @required this.time,
    this.likedBy,
    this.status,
  });

  factory CommentModel.fromDocumentSnapshot(DocumentSnapshot documentSnapshot) {
    return CommentModel(
      id: documentSnapshot.documentID,
      creatorId: documentSnapshot.data["creator_id"],
      content: documentSnapshot.data["content"],
      time: documentSnapshot.data["time"],
      likedBy: documentSnapshot.data["liked_by"] != null ? (documentSnapshot.data["liked_by"] as List<dynamic>).map((accountId) => accountId.toString()).toList() : [],
      status: 1,
    );
  }
}
