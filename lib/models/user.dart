import 'package:flutter/cupertino.dart';

class User {
  final String id, name, email;
  String username, image, bio, dob, gender;

  User({
    @required this.id,
    @required this.email,
    @required this.name,
    this.username,
    this.image,
    this.bio,
    this.dob,
    this.gender,
  });
}
