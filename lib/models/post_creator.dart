import 'package:cloud_firestore/cloud_firestore.dart';

class PostCreator{
  final String username, image;

  PostCreator({
    this.image,
    this.username,
  });

  factory PostCreator.fromDocumentSnapshot(DocumentSnapshot snapshot){
    return PostCreator(
      username: snapshot.data["username"],
      image: snapshot.data["image"],
    );
  }
}