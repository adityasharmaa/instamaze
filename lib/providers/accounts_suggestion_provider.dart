import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:insta/models/account.dart';
import 'package:insta/models/post_model.dart';

class AccountsSuggestionProvider with ChangeNotifier {
  List<Account> _suggestedAccounts = [];

  List<Account> get suggestedAccounts {
    return [..._suggestedAccounts];
  }

  Future<void> getSuggestions() async{
    final response = await Firestore.instance
        .collection("insta_users")
        .where("suggest", isEqualTo: true)
        .getDocuments();

    _suggestedAccounts = response.documents
        .map((snapshot) => Account.fromDocumentSnapshot(snapshot))
        .toList();

    notifyListeners();
  }

  Stream<void> getPostsForAccount(String accountId) async*{
    final response = await Firestore.instance
        .collection("posts")
        .where("creator_id", isEqualTo: accountId)
        .getDocuments();

    int index = _suggestedAccounts.indexWhere((account) => account.id == accountId);

    _suggestedAccounts[index].posts = response.documents
        .map((snapshot) => PostModel.fromDocumentSnapshot(snapshot))
        .toList();

    notifyListeners();
  }

  void followAccount(String accountId, String currentAccountId){
    Firestore.instance.collection("insta_users").document(accountId).updateData({
      "followers": FieldValue.arrayUnion([currentAccountId]),
    });

    Firestore.instance.collection("insta_users").document(currentAccountId).updateData({
      "following": FieldValue.arrayUnion([accountId]),
    });
  }

  void unfollowAccount(String accountId, String currentAccountId){
    Firestore.instance.collection("insta_users").document(accountId).updateData({
      "followers": FieldValue.arrayRemove([currentAccountId]),
    });

    Firestore.instance.collection("insta_users").document(currentAccountId).updateData({
      "following": FieldValue.arrayRemove([accountId]),
    });
  }
}