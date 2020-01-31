import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:insta/models/user.dart';

class CurrentUserProvider with ChangeNotifier {
  User _user;

  User get user {
    return _user;
  }

  set setUser(User user) {
    _user = user;
  }

  Future<bool> isEmailAlreadyUsed(String email) async {
    final response = await Firestore.instance
        .collection("insta_users")
        .where("email", isEqualTo: email)
        .getDocuments();

    if (response.documents.isEmpty)
      return false;
    else
      return true;
  }

  Future<void> createAccount(String email, String userId, String name) async {
    try {
      await Firestore.instance
          .collection("insta_users")
          .document(userId)
          .setData({
        "name": name,
        "email": email,
      });

      _user = User(
        id: userId,
        name: name,
        email: email,
      );

      notifyListeners();
    } catch (e) {
      throw e;
    }
  }

  Future<void> setDOB(String dob) async{
    try {
      await Firestore.instance
          .collection("insta_users")
          .document(_user.id)
          .updateData({
        "dob": dob,
      });
      _user.dob = dob;
      notifyListeners();
    } catch (e) {
      throw e;
    }
  }

  Future<String> setUsername(String username) async {
    try {
      final response = await Firestore.instance
          .collection("insta_users")
          .where("username", isEqualTo: username)
          .getDocuments();

      if(response.documents.isNotEmpty)
        return "Username already exists";
        
      await Firestore.instance
          .collection("insta_users")
          .document(_user.id)
          .updateData({
        "username": username,
      });
      _user.username = username;
      notifyListeners();
    } catch (e) {
      throw e;
    }
    return "";
  }
}
