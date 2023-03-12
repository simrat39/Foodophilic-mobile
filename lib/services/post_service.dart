import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:food_social_media/model/Post.dart';
import 'package:food_social_media/model/User.dart';

class PostService {
  static List<Post> parsePosts(QuerySnapshot<Map<String, dynamic>> cols) {
    return cols.docs.map(
      (doc) {
        var data = doc.data();
        var md = data['metadata'];
        var usr = data['user'];

        return Post(
          location: data['location'] ?? "",
          images:
              (md['images'] as List<dynamic>).map((e) => e.toString()).toList(),
          text: md['text'] ?? "",
          tags:
              (data['tags'] as List<dynamic>).map((e) => e.toString()).toList(),
          user: User(firstName: usr['firstName'], userName: usr['userName']),
          postDate: (data['postDate'] as Timestamp).toDate(),
          userID: data['userID'] ?? "",
        );
      },
    ).toList();
  }

  static Future<List<Post>> getPostsForUser(String uid) async {
    var fr = FirebaseFirestore.instance;

    var cols =
        await fr.collection("posts").where('userID', isEqualTo: uid).get();

    return parsePosts(cols);
  }

  static Future<List<Post>> getPostsWithTags(List<String> tags) async {
    var fr = FirebaseFirestore.instance;

    var cols = await fr
        .collection("posts")
        .where(
          'tags',
          arrayContainsAny: tags,
        )
        .get();

    return parsePosts(cols);
  }

  static Future<List<Post>> getAllPosts() async {
    var fr = FirebaseFirestore.instance;

    var cols = await fr
        .collection("posts")
        .orderBy(
          'postDate',
          descending: true,
        )
        .get();

    return parsePosts(cols);
  }
}
