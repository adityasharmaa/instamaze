import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:insta/models/post_model.dart';

class PostsProvider with ChangeNotifier {
  List<PostModel> _homePosts = [];

  List<PostModel> get homePosts {
    return [..._homePosts];
  }

  PostModel getPost(int index) {
    return _homePosts[index];
  }

  Future<void> fetchPosts(List<String> following) async {
    final response = await Firestore.instance
        .collection("posts")
        .where("creator_id", whereIn: following)
        .orderBy("time", descending: true)
        .getDocuments();

    _homePosts = response.documents
        .map((snapshot) => PostModel.fromDocumentSnapshot(snapshot))
        .toList();
    notifyListeners();
  }

  Future<void> toggleLike(String postId, String userId) async {
    int index = _homePosts.indexWhere((post) => post.id == postId);

    bool liked = _homePosts[index].likedBy.contains(userId);

    if (!liked)
      _homePosts[index].likedBy.add(userId);
    else
      _homePosts[index].likedBy.remove(userId);
    notifyListeners();

    try {
      await Firestore.instance.collection("posts").document(postId).updateData({
        "liked_by": liked
            ? FieldValue.arrayRemove([userId])
            : FieldValue.arrayUnion([userId]),
      });
    } catch (e) {
      if (liked)
        _homePosts[index].likedBy.add(userId);
      else
        _homePosts[index].likedBy.remove(userId);
      notifyListeners();
      throw e;
    }
  }

  Future<String> _uploadImage(PostModel post, int imageIndex) async {
    try {
      StorageTaskSnapshot storageTaskSnapshot;

      storageTaskSnapshot = await FirebaseStorage.instance
          .ref()
          .child("insta_posts_images")
          .child(post.creatorId)
          .child(post.id+"_$imageIndex")
          .putFile(post.newPostImages[imageIndex])
          .onComplete;

      if (storageTaskSnapshot.error == null) {
        final downloadUrl = await storageTaskSnapshot.ref.getDownloadURL();
        return downloadUrl;
      }
    } catch (e) {
      print(e.toString());
    }
    return "";
  }

  void _deleteResidualFiles(List<File> files){
    for(File file in files)
      file.delete();
  }

  Future<void> createPost(PostModel post) async {
    _homePosts.insert(0, post);
    notifyListeners();

    try {
      for(int i=0 ; i<post.newPostImages.length ; i++){
        final imageUrl = await _uploadImage(post,i);
        post.images.add(imageUrl);
        if(i < post.newPostImages.length - 1)
          notifyListeners();
      }

      post.status = PostStatus.CREATING_POST;
      notifyListeners();

      await Firestore.instance.collection("posts").document(post.id).setData({
        "caption": post.caption,
        "creator_id": post.creatorId,
        "images": post.images,
        "liked_by": post.likedBy,
        "place": post.place,
        "time": post.time,
      });

      post.status = PostStatus.FINISHED;
      notifyListeners();

    } catch (e) {
      print("PostCreationError" + e.toString());
      post.status = PostStatus.ERROR;
      notifyListeners();
    }
    _deleteResidualFiles(post.newPostImages);
  }
}