import 'package:ecommerce_app/misc/shop_user.dart';
import 'package:ecommerce_app/redux/store.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'sign_up.dart'; // Assure-toi que ce fichier est correctement créé

class SignInPage extends StatelessWidget {
  SignInPage({super.key});

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  static const Color mainColor = Colors.teal;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sign In'),
        backgroundColor: mainColor,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back), // Go to home page
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Container(
        color: Colors.black,
        padding: const EdgeInsets.all(20.0),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'Welcome Back!',
                  style: TextStyle(fontSize: 24, color: Colors.white),
                ),
                const SizedBox(height: 40),
                TextField(
                  controller: emailController,
                  style: const TextStyle(color: Colors.white),
                  cursorColor: mainColor,
                  decoration: const InputDecoration(
                    labelText: 'Email',
                    labelStyle: TextStyle(color: Colors.white),
                    border: OutlineInputBorder(),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: mainColor),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.white),
                    ),
                    prefixIcon: Icon(Icons.email, color: Colors.white),
                  ),
                  keyboardType: TextInputType.emailAddress,
                ),
                const SizedBox(height: 20),
                TextField(
                  controller: passwordController,
                  style: const TextStyle(color: Colors.white),
                  cursorColor: mainColor,
                  decoration: const InputDecoration(
                    labelText: 'Password',
                    labelStyle: TextStyle(color: Colors.white),
                    border: OutlineInputBorder(),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: mainColor),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.white),
                    ),
                    prefixIcon: Icon(Icons.lock, color: Colors.white),
                  ),
                  obscureText: true,
                ),
                const SizedBox(height: 30),
                ElevatedButton(
                  onPressed: () {
                    FirebaseAuth.instance
                        .signInWithEmailAndPassword(
                          email: emailController.text.trim(),
                          password: passwordController.text.trim(),
                        )
                        .then((userCredential) {
                      SharedPreferences.getInstance().then((prefs) {
                        prefs.setString('userID', userCredential.user!.uid);
                        ShopUser.getFromId(userCredential.user!.uid).then((user) {
                          StoreProvider.of<ShopState>(context).dispatch(SetUserAction(user));
                          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                            content: Text('Sign in successful. Redirecting...'),
                            backgroundColor: Colors.green,
                          ));

                          // Redirection vers la page d'accueil
                          Navigator.of(context).popUntil((route) => route.isFirst);
                        });
                      });
                    }).catchError((e) {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Text(e.message ?? 'An error occurred'),
                        backgroundColor: Colors.red,
                      ));
                    });
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: mainColor,
                    padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                  ),
                  child: const Text('Sign In', style: TextStyle(color: Colors.white)),
                ),
                const SizedBox(height: 20),
                TextButton(
                  onPressed: () {
                    Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => SignUpPage(),
                    ));
                  },
                  child: const Text('Don\'t have an account? Sign Up', style: TextStyle(color: Colors.white)),
                ),
                const SizedBox(height: 5),
                Divider(color: Colors.white, thickness: 2, endIndent: MediaQuery.of(context).size.width * 0.2, indent: MediaQuery.of(context).size.width * 0.2),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
