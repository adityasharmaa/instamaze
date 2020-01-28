import 'package:flutter/foundation.dart';

class PostModel {
  final String id, creatorId, caption, commentsId, time;
  final List<String> images;
  final int likes;

  PostModel({
    @required this.id,
    @required this.creatorId,
    this.caption,
    this.commentsId,
    @required this.time,
    @required this.images,
    @required this.likes,
  });
}
