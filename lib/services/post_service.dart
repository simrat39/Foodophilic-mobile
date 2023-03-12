import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:food_social_media/model/Post.dart';

class PostService {
  static Future<List<Post>> getPostsForUser(String uid) async {
    var fr = FirebaseFirestore.instance;

    var cols =
        await fr.collection("posts").where('userID', isEqualTo: uid).get();

    return cols.docs.map(
      (doc) {
        var data = doc.data();
        var md = data['metadata'];

        return Post(
          location: data['location'] ?? "",
          images:
              (md['images'] as List<dynamic>).map((e) => e.toString()).toList(),
          text: md['text'] ?? "",
          tags:
              (data['tags'] as List<dynamic>).map((e) => e.toString()).toList(),
        );
      },
    ).toList();
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

    return cols.docs.map(
      (doc) {
        var data = doc.data();
        var md = data['metadata'];

        return Post(
          location: data['location'] ?? "",
          images:
              (md['images'] as List<dynamic>).map((e) => e.toString()).toList(),
          text: md['text'] ?? "",
          tags:
              (data['tags'] as List<dynamic>).map((e) => e.toString()).toList(),
        );
      },
    ).toList();
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

    return cols.docs.map(
      (doc) {
        var data = doc.data();
        var md = data['metadata'];

        return Post(
          location: data['location'] ?? "",
          images:
              (md['images'] as List<dynamic>).map((e) => e.toString()).toList(),
          text: md['text'] ?? "",
          tags:
              (data['tags'] as List<dynamic>).map((e) => e.toString()).toList(),
        );
      },
    ).toList();
  }
}
