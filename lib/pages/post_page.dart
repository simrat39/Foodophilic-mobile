import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:food_social_media/main.dart';
import 'package:food_social_media/model/FirebaseImage.dart';
import 'package:food_social_media/providers/post_provider.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uuid/uuid.dart';

class PostPage extends ConsumerStatefulWidget {
  const PostPage({super.key});

  @override
  ConsumerState<PostPage> createState() => _PostPageState();
}

class _PostPageState extends ConsumerState<PostPage> {
  final ImagePicker _picker = ImagePicker();
  late ChangeNotifierProvider<PostProvider> postProvider;
  late String tagTextBox;

  void uploadPost(PostProvider pp) async {
    await FirebaseFirestore.instance.collection('posts').add({
      'postType': 'review',
      'location': pp.location,
      'tags': pp.tags,
      'postDate': DateTime.now(),
      'metadata': {
        'text': pp.text,
        'images': pp.images.map((e) => e.name),
      },
      'userID': ref.read(userProvider).uid,
      'user': {},
    });
  }

  @override
  void initState() {
    super.initState();

    postProvider = ChangeNotifierProvider((ref) {
      return PostProvider();
    });
    tagTextBox = "";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
        child: Consumer(
          builder: (BuildContext context, WidgetRef ref, Widget? child) {
            var pp = ref.watch(postProvider);

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Transform.translate(
                      offset: const Offset(-10, 0),
                      child: IconButton(
                        icon: const Icon(
                          Icons.close,
                          size: 26,
                        ),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      ),
                    ),
                    FilledButton(
                      onPressed: () {
                        ref.read(globalPostNotifer).setPosts();
                        uploadPost(pp);
                        Navigator.of(context).pop();
                      },
                      child: const Text(
                        "Post",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Consumer(
                  builder:
                      (BuildContext context, WidgetRef ref, Widget? child) {
                    var pp = ref.watch(postProvider);

                    Widget uploadButton = Padding(
                      padding: const EdgeInsets.only(right: 20.0, bottom: 20),
                      child: OutlinedButton(
                        onPressed: () async {
                          final XFile? image = await _picker.pickImage(
                              source: ImageSource.gallery);

                          var uuid = const Uuid().v4();

                          var ref = FirebaseStorage.instance.ref().child(uuid);
                          await ref.putFile(File(image!.path));

                          pp.addImage(
                              FirebaseImage(name: uuid, path: image.path));
                        },
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: const [
                            Icon(Icons.add),
                            SizedBox(width: 8),
                            Text("Upload Image"),
                          ],
                        ),
                      ),
                    );

                    if (pp.images.isEmpty) {
                      return DottedBorder(
                        borderType: BorderType.RRect,
                        color: Colors.grey,
                        strokeWidth: 1,
                        dashPattern: const [15],
                        radius: const Radius.circular(12),
                        child: SizedBox(
                          width: double.infinity,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              const SizedBox(
                                height: 100,
                              ),
                              uploadButton,
                            ],
                          ),
                        ),
                      );
                    } else {
                      return DottedBorder(
                        borderType: BorderType.RRect,
                        color: Colors.transparent,
                        strokeWidth: 1,
                        radius: const Radius.circular(12),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: SizedBox(
                            width: double.infinity,
                            child: Stack(
                              children: [
                                ColorFiltered(
                                  colorFilter: ColorFilter.mode(
                                    Colors.black.withOpacity(0.4),
                                    BlendMode.dstATop,
                                  ),
                                  child: Image.file(
                                    File(pp.images.last.path),
                                    height: 200,
                                    width: double.infinity,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                Positioned(
                                  bottom: 0,
                                  right: 0,
                                  child: uploadButton,
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    }
                  },
                ),
                const SizedBox(height: 8),
                Wrap(
                  alignment: WrapAlignment.start,
                  children: [
                    ...pp.tags
                        .map(
                          (e) => Padding(
                            padding: const EdgeInsets.only(right: 8),
                            child: Chip(
                              label: Text(e),
                            ),
                          ),
                        )
                        .toList(),
                    ActionChip(
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              title: const Text("Tags"),
                              content: TextField(
                                onChanged: (value) {
                                  tagTextBox = value;
                                },
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    pp.addTag(tagTextBox);
                                    tagTextBox = "";
                                    Navigator.of(context).pop();
                                  },
                                  child: const Text("Done"),
                                ),
                              ],
                            );
                          },
                        );
                      },
                      avatar: const Icon(Icons.add),
                      label: const Text('Add Tags'),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Expanded(
                  child: Card(
                    margin: EdgeInsets.zero,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 16, horizontal: 16),
                      child: SingleChildScrollView(
                        child: TextField(
                          keyboardType: TextInputType.multiline,
                          onChanged: (t) {
                            pp.setText(t);
                          },
                          maxLines: null,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Align(
                  alignment: Alignment.bottomLeft,
                  child: Card(
                    margin: EdgeInsets.zero,
                    child: IconButton(
                      onPressed: () => {},
                      padding: const EdgeInsets.all(16),
                      icon: const Icon(
                        Icons.location_pin,
                      ),
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
