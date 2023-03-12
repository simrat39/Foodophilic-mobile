import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:food_social_media/firebase_options.dart';
import 'package:food_social_media/login.dart';
import 'package:food_social_media/providers/global_post_created_notifer.dart';
import 'package:food_social_media/providers/user_provider.dart';

var globalPostNotifer = ChangeNotifierProvider((ref) => GlobalPostProvider());
var userProvider = ChangeNotifierProvider((ref) => UserProvider());

void main() async {
  runApp(const MyApp());
}

void initializeFirebase() async {
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late Future _firebaseInitFuture;

  @override
  void initState() {
    _firebaseInitFuture = Future(initializeFirebase);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ProviderScope(
      child: FutureBuilder(
        future: _firebaseInitFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
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
              home: LoginPage(),
            );
          }
          return Container();
        },
      ),
    );
  }
}
