import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:food_social_media/model/Post.dart';
import 'package:food_social_media/pages/profile.dart';

class PostCard extends StatelessWidget {
  final Post post;

  const PostCard({super.key, required this.post});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 6),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                InkWell(
                  onTap: () => {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) {
                          return Profile(
                            uid: post.userID,
                            user: post.user,
                            isOwner: false,
                          );
                        },
                      ),
                    ),
                  },
                  child: CircleAvatar(
                    foregroundImage: Image.asset(
                      'assets/pfp.png',
                    ).image,
                  ),
                ),
                const SizedBox(
                  width: 15,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      post.user.userName,
                      style: Theme.of(context)
                          .textTheme
                          .titleSmall!
                          .copyWith(fontSize: 17, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      "${DateTime.now().difference(post.postDate).inMinutes}m ago",
                      style: Theme.of(context)
                          .textTheme
                          .labelSmall!
                          .copyWith(fontSize: 12, fontWeight: FontWeight.w300),
                    ),
                  ],
                )
              ],
            ),
            const SizedBox(
              height: 15,
            ),
            Builder(builder: (context) {
              if (post.images.isEmpty) {
                return const SizedBox.shrink();
              }
              return ClipRRect(
                borderRadius: BorderRadius.circular(6),
                child: FutureBuilder(
                  future: FirebaseStorage.instance
                      .ref(post.images.first)
                      .getDownloadURL(),
                  builder:
                      (BuildContext context, AsyncSnapshot<String> snapshot) {
                    if (snapshot.hasData) {
                      return Image.network(
                        snapshot.data!,
                        height: 200,
                        width: double.infinity,
                        fit: BoxFit.cover,
                      );
                    }
                    return const SizedBox(
                      height: 200,
                      child: Center(
                        child: CircularProgressIndicator(),
                      ),
                    );
                  },
                ),
              );
            }),
            const SizedBox(
              height: 13,
            ),
            Text(
              post.text,
              style: Theme.of(context)
                  .textTheme
                  .bodySmall!
                  .copyWith(fontSize: 14, fontWeight: FontWeight.normal),
            ),
            const SizedBox(
              height: 13,
            ),
            Wrap(
              direction: Axis.horizontal,
              children: post.tags
                  .map(
                    (e) => Padding(
                      padding: const EdgeInsets.only(right: 12.0),
                      child: Chip(
                        label: Text(e),
                      ),
                    ),
                  )
                  .toList(),
              // [
              // ],
            )
          ],
        ),
      ),
    );
  }
}
