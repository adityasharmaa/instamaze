import 'package:cloud_firestore/cloud_firestore.dart';

class Creator{
  final String username, image;

  Creator({
    this.image,
    this.username,
  });

  factory Creator.fromDocumentSnapshot(DocumentSnapshot snapshot){
    return Creator(
      username: snapshot.data["username"],
      image: snapshot.data["image"],
    );
  }
}