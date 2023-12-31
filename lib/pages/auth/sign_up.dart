import 'package:ecommerce_app/misc/shop_user.dart';
import 'package:ecommerce_app/redux/store.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../home.dart';
import 'sign_up_details.dart';
import 'sign_in.dart';

class SignUpPage extends StatelessWidget {
  SignUpPage({super.key});

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();
  static const Color mainColor = Colors.grey;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sign Up'),
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => const HomePage()),
          ),
        ),
      ),
      body: Container(
        color: Colors.white, // Fond changé en blanc
        padding: const EdgeInsets.all(20.0),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'Join Us!',
                  style: TextStyle(fontSize: 27, color: Colors.black, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 40),
                // Email field
                TextField(
                  controller: emailController,
                  style: const TextStyle(color: Colors.black),
                  cursorColor: mainColor,
                  decoration: InputDecoration(
                    labelText: 'Email',
                    labelStyle: TextStyle(color: Colors.black),
                    border: const OutlineInputBorder(),
                    enabledBorder: const OutlineInputBorder(
                      borderSide: BorderSide(color: mainColor),
                    ),
                    focusedBorder: const OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.black),
                    ),
                    prefixIcon: const Icon(Icons.email, color: Colors.black),
                  ),
                  keyboardType: TextInputType.emailAddress,
                ),
                // Password field
                const SizedBox(height: 20),
                TextField(
                  controller: passwordController,
                  style: const TextStyle(color: Colors.black),
                  cursorColor: mainColor,
                  decoration: InputDecoration(
                    labelText: 'Password',
                    labelStyle: TextStyle(color: Colors.black),
                    border: const OutlineInputBorder(),
                    enabledBorder: const OutlineInputBorder(
                      borderSide: BorderSide(color: mainColor),
                    ),
                    focusedBorder: const OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.black),
                    ),
                    prefixIcon: const Icon(Icons.lock, color: Colors.black),
                  ),
                  obscureText: true,
                ),
                // Confirm password field
                const SizedBox(height: 20),
                TextField(
                  controller: confirmPasswordController,
                  style: const TextStyle(color: Colors.black),
                  cursorColor: mainColor,
                  decoration: InputDecoration(
                    labelText: 'Confirm Password',
                    labelStyle: TextStyle(color: Colors.black),
                    border: const OutlineInputBorder(),
                    enabledBorder: const OutlineInputBorder(
                      borderSide: BorderSide(color: mainColor),
                    ),
                    focusedBorder: const OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.black),
                    ),
                    prefixIcon: const Icon(Icons.lock, color: Colors.black),
                  ),
                  obscureText: true,
                ),
                // Sign up button
                const SizedBox(height: 30),
                ElevatedButton(
                  onPressed: () {
                    if (passwordController.text.trim() != confirmPasswordController.text.trim()) {
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                        content: Text('Passwords do not match'),
                        backgroundColor: Colors.red,
                      ));
                      return;
                    }

                    if (passwordController.text.trim() == confirmPasswordController.text.trim()) {
                      FirebaseAuth.instance.createUserWithEmailAndPassword(
                        email: emailController.text.trim(),
                        password: passwordController.text.trim(),
                      ).then((userCredential) {
                        SharedPreferences.getInstance().then((prefs) {
                          prefs.setString('userID', userCredential.user!.uid).then((_) {
                            prefs.setBool('signUpEditingMode', true).then((_) {
                              ShopUser.getFromId(userCredential.user!.uid).then((user) {
                                StoreProvider.of<ShopState>(context).dispatch(SetUserAction(user));

                                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                                  content: Text('Account created successfully.'),
                                  backgroundColor: Colors.green,
                                ));

                                Navigator.of(context).pushReplacement(
                                  MaterialPageRoute(builder: (context) => const SignupDetails()),
                                );
                              });
                            });
                          });
                        });
                      }).catchError((e) {
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Text(e.message ?? 'An error occurred'),
                          backgroundColor: Colors.red,
                        ));
                      });
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                    padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 22),
                  ),
                  child: const Text('Sign Up', style: TextStyle(color: Colors.white)),
                ),
                // Sign in button
                const SizedBox(height: 20),
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pushReplacement(MaterialPageRoute(
                      builder: (context) => SignInPage(),
                    ));
                  },
                  child: const Text('Already have an account? Sign In', style: TextStyle(color: Colors.black)),
                ),
                // Divider
                const SizedBox(height: 5),
                Divider(color: Colors.grey, thickness: 2, endIndent: MediaQuery.of(context).size.width * 0.2, indent: MediaQuery.of(context).size.width * 0.2),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
