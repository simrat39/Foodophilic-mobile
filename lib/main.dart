import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:food_social_media/firebase_options.dart';
import 'package:food_social_media/pages/post_page.dart';
import 'package:food_social_media/pages/profile.dart';
import 'package:food_social_media/post_card.dart';

void main() async {
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData.dark(useMaterial3: true).copyWith(
        useMaterial3: true,
        cardTheme: CardTheme(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
      debugShowCheckedModeBanner: false,
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
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
                      foregroundImage: Image.asset(
                        'assets/pfp.png',
                      ).image,
                    ),
                    onTap: () => {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) {
                            return const Profile();
                          },
                        ),
                      ),
                    },
                  ),
                  Text(widget.title),
                  IconButton(
                      onPressed: () => {}, icon: const Icon(Icons.search)),
                ],
              ),
            ],
          ),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.only(bottom: 8, left: 16, right: 16, top: 8),
        children: [
          for (var i = 0; i < 4; i++) const PostCard(),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showModalBottomSheet(
            context: context,
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
