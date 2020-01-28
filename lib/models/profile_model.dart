import 'package:flutter/foundation.dart';

class ProfileModel {
  final String name, userName, bio, gender, image;
  ProfileModel({
    @required this.name,
    @required this.userName,
    @required this.bio,
    @required this.gender,
    this.image,
  });
}
