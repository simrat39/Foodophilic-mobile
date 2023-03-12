import 'package:flutter/material.dart';
import 'package:food_social_media/model/Post.dart';
import 'package:food_social_media/services/post_service.dart';

class GlobalPostProvider extends ChangeNotifier {
  List<Post> posts = [];

  void setPosts() async {
    posts = await PostService.getAllPosts();
    notifyListeners();
  }

  void setPostsWithTags(List<String> tags) async {
    posts = await PostService.getPostsWithTags(tags);
    notifyListeners();
  }
}
