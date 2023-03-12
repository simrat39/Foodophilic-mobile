import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:food_social_media/main.dart';
import 'package:food_social_media/pages/home.dart';

class LoginPage extends ConsumerStatefulWidget {
  const LoginPage({super.key});

  @override
  ConsumerState<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage> {
  late String _name;
  late String _pw;

  @override
  void initState() {
    _name = "";
    _pw = "";

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: double.infinity,
        margin: const EdgeInsets.symmetric(
          horizontal: 16.0,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(200),
              child: SizedBox(
                width: 200,
                height: 200,
                child: Image.asset(
                  "assets/logo.png",
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                TextField(
                  decoration: const InputDecoration(
                    filled: true,
                    labelText: "Email",
                    focusedBorder: OutlineInputBorder(),
                  ),
                  onChanged: (v) => _name = v,
                ),
                const SizedBox(height: 50),
                TextField(
                  obscureText: true,
                  decoration: const InputDecoration(
                    filled: true,
                    labelText: "Password",
                    focusedBorder: OutlineInputBorder(),
                  ),
                  onChanged: (v) => _pw = v,
                ),
                const SizedBox(height: 25),
                Builder(builder: (context) {
                  return ElevatedButton(
                    onPressed: () {
                      ref.read(userProvider).login(_name, _pw).then(
                        (loggedIn) {
                          if (loggedIn) {
                            Navigator.of(context).pop();
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) =>
                                    const MyHomePage(title: "FoodApp"),
                              ),
                            );
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text("Incorrect login details"),
                              ),
                            );
                          }
                        },
                      );
                    },
                    child: const Text("Login"),
                  );
                }),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
