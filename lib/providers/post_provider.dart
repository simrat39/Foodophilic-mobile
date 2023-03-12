import 'package:flutter/material.dart';
import 'package:food_social_media/model/FirebaseImage.dart';

class PostProvider extends ChangeNotifier {
  late List<FirebaseImage> images;
  late String text;
  late String location;
  late List<String> tags;

  PostProvider() {
    images = [];
    text = "";
    location = '';
    tags = [];
  }

  void addTag(String tag) {
    tags.add(tag);
    notifyListeners();
  }

  void addImage(FirebaseImage image) {
    images.add(image);
    notifyListeners();
  }

  void setText(String t) {
    text = t;
    notifyListeners();
  }

  void setLocation(String l) {
    location = l;
    notifyListeners();
  }
}
