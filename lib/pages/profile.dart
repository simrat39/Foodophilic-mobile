import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:food_social_media/model/Post.dart';
import 'package:food_social_media/model/User.dart';
import 'package:food_social_media/post_card.dart';
import 'package:food_social_media/services/post_service.dart';

class Profile extends ConsumerStatefulWidget {
  final String uid;
  final User user;
  final bool isOwner;

  const Profile({
    super.key,
    required this.uid,
    required this.user,
    required this.isOwner,
  });

  @override
  ConsumerState<Profile> createState() => _ProfileState();
}

class _ProfileState extends ConsumerState<Profile> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
        future: PostService.getPostsForUser(widget.uid),
        builder: (BuildContext context, AsyncSnapshot<List<Post>> snapshot) {
          if (snapshot.hasData) {
            return ListView(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Stack(
                      fit: StackFit.loose,
                      clipBehavior: Clip.none,
                      children: [
                        Column(
                          children: [
                            ColorFiltered(
                              colorFilter: ColorFilter.mode(
                                  Colors.black.withOpacity(0.4),
                                  BlendMode.dstATop),
                              child: Image.asset(
                                'assets/pasta.jpeg',
                                height: 130,
                                width: double.infinity,
                                fit: BoxFit.cover,
                              ),
                            ),
                            const SizedBox(
                              width: double.infinity,
                              height: (120 / 2),
                            ),
                          ],
                        ),
                        Positioned(
                          top: 6,
                          left: 6,
                          child: IconButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            icon: const Icon(Icons.arrow_back),
                          ),
                        ),
                        Positioned(
                          bottom: 0,
                          left: 16,
                          right: 16,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              SizedBox(
                                height: 120,
                                width: 120,
                                child: CircleAvatar(
                                  foregroundImage: Image.asset(
                                    'assets/pfp.png',
                                  ).image,
                                ),
                              ),
                              if (widget.isOwner)
                              OutlinedButton(
                                onPressed: () {
                                  debugPrint("ha");
                                },
                                child: Text(
                                  "Edit Profile",
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleSmall!
                                      .copyWith(
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                      ),
                                ),
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                        left: 18,
                        top: 6,
                      ),
                      child: Text(
                        widget.user.firstName,
                        style: Theme.of(context).textTheme.titleSmall!.copyWith(
                            fontSize: 30, fontWeight: FontWeight.bold),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                        left: 18,
                      ),
                      child: Text(
                        "@${widget.user.userName}",
                        style: Theme.of(context).textTheme.titleSmall!.copyWith(
                            fontSize: 14, fontWeight: FontWeight.w300),
                      ),
                    ),
                    const SizedBox(
                      height: 14,
                    ),
                    const Divider(),
                    ...snapshot.data!
                        .map((e) => Padding(
                              padding: const EdgeInsets.only(
                                left: 16,
                                right: 16,
                              ),
                              child: PostCard(
                                post: e,
                              ),
                            ))
                        .toList(),
                  ],
                ),
              ],
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }
}
