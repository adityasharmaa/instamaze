import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:insta/models/account.dart';

class CurrentUserProvider with ChangeNotifier {
  Account _account;

  Account get account {
    return _account;
  }

  Future<void> getCurrentUser(String userId) async{
    final response = await Firestore.instance
          .collection("insta_users")
          .document(userId).get();

    _account = Account.fromDocumentSnapshot(response);
    notifyListeners();
  }

  Future<void> delete(String userId) async{
    await Firestore.instance
          .collection("insta_users")
          .document(userId).delete();
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

      _account = Account(
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
          .document(_account.id)
          .updateData({
        "dob": dob,
      });
      _account.dob = dob;
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
          .document(_account.id)
          .updateData({
        "username": username,
      });
      _account.username = username;
      notifyListeners();
    } catch (e) {
      throw e;
    }
    return "";
  }

  void followAccount(String accountId){
    if(_account.following == null)
      _account.following = [];
    _account.following.add(accountId);
    notifyListeners();
  }

  void unfollowAccount(String accountId){
    _account.following.remove(accountId);
    notifyListeners();
  }

}
