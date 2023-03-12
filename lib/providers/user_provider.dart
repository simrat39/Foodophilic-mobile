import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:food_social_media/model/User.dart';

class UserProvider extends ChangeNotifier {
  bool logged_in = false;
  late String uid;
  late User user;

  Future<bool> login(String name, String pw) async {
    var fr = FirebaseFirestore.instance;

    var lol = await fr
        .collection("users")
        .where('username', isEqualTo: name)
        .where('password', isEqualTo: pw)
        .get();

    if (lol.size == 0) {
      logged_in = false;
    } else {
      logged_in = true;
      uid = lol.docs.first.id;
      user = User(
        userName: lol.docs.first.get('username'),
        firstName: lol.docs.first.get('firstName'),
      );
    }

    notifyListeners();
    return logged_in;
  }
}
