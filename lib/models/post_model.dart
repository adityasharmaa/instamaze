import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

class PostModel {
  final String id, creatorId, caption, time, place;
  final List<String> images;
  final List<String> likedBy;
  List<File> newPostImages;
  PostStatus status;

  PostModel({
    @required this.id,
    @required this.creatorId,
    this.caption,
    @required this.time,
    @required this.images,
    this.likedBy,
    this.place,
    this.newPostImages,
    this.status = PostStatus.FINISHED,
  });

  bool isFavorite(String userId) => likedBy.contains(userId);

  factory PostModel.fromDocumentSnapshot(DocumentSnapshot snapshot){
    return PostModel(
      id: snapshot.documentID,
      creatorId: snapshot.data["creator_id"],
      likedBy: snapshot.data["liked_by"] != null ? (snapshot.data["liked_by"] as List<dynamic>).map((user) => user.toString()).toList() : [],
      time: snapshot.data["time"],
      images: snapshot.data["images"] != null ? (snapshot.data["images"] as List<dynamic>).map((follower) => follower.toString()).toList() : [],
      caption: snapshot.data["caption"],
      place: snapshot.data["place"],
      newPostImages: null,
      status: PostStatus.FINISHED,
    );
  }
}

enum PostStatus{
  UPLOADING_IMAGES,
  CREATING_POST,
  ERROR,
  FINISHED,
}