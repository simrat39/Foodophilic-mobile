import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:food_social_media/main.dart';
import 'package:food_social_media/pages/post_page.dart';
import 'package:food_social_media/pages/profile.dart';
import 'package:food_social_media/post_card.dart';
import 'package:food_social_media/services/avatar_factory.dart';

class MyHomePage extends ConsumerStatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  ConsumerState<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends ConsumerState<MyHomePage> {
  late String _tagTextBox;
  late List<String> _tags;

  @override
  void initState() {
    ref.read(globalPostNotifer).setPosts();

    _tagTextBox = "";
    _tags = [];

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Padding(
          padding: const EdgeInsets.symmetric(vertical: 16.0),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  InkWell(
                    child: CircleAvatar(
                      child: SvgPicture.string(
                        AvatarFactory.getAvatar(
                        ref.read(userProvider).uid,
                        ),
                      ),
                    ),
                    onTap: () => {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) {
                            var uP = ref.read(userProvider);
                            return Profile(
                              uid: uP.uid,
                              user: uP.user,
                              isOwner: true,
                            );
                          },
                        ),
                      ),
                    },
                  ),
                  Text(widget.title),
                  IconButton(
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            title: const Text("Tags"),
                            content: TextField(
                              onChanged: (value) {
                                _tagTextBox = value;
                              },
                            ),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  _tags.add(_tagTextBox);
                                  _tagTextBox = "";
                                  setState(() {});
                                  ref
                                      .read(globalPostNotifer)
                                      .setPostsWithTags(_tags);
                                  Navigator.of(context).pop();
                                },
                                child: const Text("Done"),
                              ),
                            ],
                          );
                        },
                      );
                    },
                    icon: const Icon(Icons.filter_list),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      body: Consumer(
        builder: (BuildContext context, WidgetRef ref, Widget? child) {
          var posts = ref.watch(globalPostNotifer).posts;

          return Builder(
            builder: (BuildContext context) {
              return ListView(
                padding: const EdgeInsets.only(
                  bottom: 8,
                  left: 16,
                  right: 16,
                  top: 8,
                ),
                children: [
                  Builder(builder: (context) {
                    if (_tags.isEmpty) {
                      return const SizedBox.shrink();
                    }

                    return Wrap(alignment: WrapAlignment.start, children: [
                      ..._tags
                          .map(
                            (e) => Padding(
                              padding: const EdgeInsets.only(right: 8),
                              child: FilterChip(
                                label: Text(e),
                                selected: true,
                                onSelected: (bool value) {
                                  setState(() {
                                    _tags.remove(e);

                                    if (_tags.isNotEmpty) {
                                      ref
                                          .read(globalPostNotifer)
                                          .setPostsWithTags(_tags);
                                    } else {
                                      ref.read(globalPostNotifer).setPosts();
                                    }
                                  });
                                },
                              ),
                            ),
                          )
                          .toList()
                    ]);
                  }),
                  ...posts
                      .map(
                        (e) => PostCard(post: e),
                      )
                      .toList()
                ],
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showModalBottomSheet(
            context: context,
            useSafeArea: true,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
            isScrollControlled: true,
            builder: (context) {
              return const PostPage();
            },
          );
        },
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: 0,
        destinations: const [
          NavigationDestination(
            icon: Icon(
              Icons.home,
            ),
            label: "Home",
          ),
          NavigationDestination(
            icon: Icon(
              Icons.emoji_food_beverage,
            ),
            label: "Restaurants",
          ),
          NavigationDestination(
            icon: Icon(
              Icons.book,
            ),
            label: "Recipes",
          ),
        ],
      ),
    );
  }
}
