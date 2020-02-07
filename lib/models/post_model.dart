import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

class PostModel {
  final String id, creatorId, caption, time, place;
  final List<String> images;
  final int likes;

  PostModel({
    @required this.id,
    @required this.creatorId,
    this.caption,
    @required this.time,
    @required this.images,
    @required this.likes,
    this.place,
  });

  factory PostModel.fromDocumentSnapshot(DocumentSnapshot snapshot){
    return PostModel(
      id: snapshot.documentID,
      creatorId: snapshot.data["creator_id"],
      likes: snapshot.data["likes"],
      time: snapshot.data["time"],
      images: snapshot.data["images"] != null ? (snapshot.data["images"] as List<dynamic>).map((follower) => follower.toString()).toList() : null,
      caption: snapshot.data["caption"],
      place: snapshot.data["place"],
    );
  }
}