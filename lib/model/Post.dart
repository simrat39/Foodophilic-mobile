import 'package:food_social_media/model/User.dart';

class Post {
  String location;
  List<String> images;
  String text;
  List<String> tags;
  String userID;
  User user;
  DateTime postDate;

  Post({
    required this.location,
    required this.images,
    required this.text,
    required this.tags,
    required this.user,
    required this.postDate,
    required this.userID,
  });
}
