import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

import 'post_model.dart';

class Account {
  final String id, name, email;
  List<String> followers, following;
  String username, image, bio, dob, gender;
  List<PostModel> posts;

  Account({
    @required this.id,
    @required this.email,
    @required this.name,
    this.username,
    this.image,
    this.bio,
    this.dob,
    this.gender,
    this.followers,
    this.following,
    this.posts,
  });

  factory Account.fromDocumentSnapshot(DocumentSnapshot snapshot){
    return Account(
      name: snapshot.data["name"],
      username: snapshot.data["username"],
      email: snapshot.data["email"],
      id: snapshot.documentID,
      dob: snapshot.data["dob"],
      bio: snapshot.data["bio"],
      followers: snapshot.data["followers"] !=null ? (snapshot.data["followers"] as List<dynamic>).map((follower) => follower.toString()).toList() : null,
      following: snapshot.data["following"] != null ? (snapshot.data["following"] as List<dynamic>).map((follower) => follower.toString()).toList() : null,
      gender: snapshot.data["gender"],
      image: snapshot.data["image"],
    );
  }
}
