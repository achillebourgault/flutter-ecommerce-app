import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../home.dart';
import 'sign_up_details.dart';
import 'sign_in.dart';

class SignUpPage extends StatelessWidget {
  SignUpPage({super.key});

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();
  static const Color mainColor = Colors.teal;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sign Up'),
        backgroundColor: mainColor,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => HomePage()),
          ),
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
                  'Join Us!',
                  style: TextStyle(fontSize: 24, color: Colors.white),
                ),
                const SizedBox(height: 40),
                // Email field
                TextField(
                  controller: emailController,
                  style: const TextStyle(color: Colors.white),
                  cursorColor: mainColor,
                  decoration: InputDecoration(
                    labelText: 'Email',
                    labelStyle: const TextStyle(color: Colors.white),
                    border: OutlineInputBorder(),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: mainColor),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.white),
                    ),
                    prefixIcon: const Icon(Icons.email, color: Colors.white),
                  ),
                  keyboardType: TextInputType.emailAddress,
                ),
                // Password field
                const SizedBox(height: 20),
                TextField(
                  controller: passwordController,
                  style: const TextStyle(color: Colors.white),
                  cursorColor: mainColor,
                  decoration: InputDecoration(
                    labelText: 'Password',
                    labelStyle: const TextStyle(color: Colors.white),
                    border: OutlineInputBorder(),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: mainColor),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.white),
                    ),
                    prefixIcon: const Icon(Icons.lock, color: Colors.white),
                  ),
                  obscureText: true,
                ),
                // Confirm password field
                const SizedBox(height: 20),
                TextField(
                  controller: confirmPasswordController,
                  style: const TextStyle(color: Colors.white),
                  cursorColor: mainColor,
                  decoration: InputDecoration(
                    labelText: 'Confirm Password',
                    labelStyle: const TextStyle(color: Colors.white),
                    border: OutlineInputBorder(),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: mainColor),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.white),
                    ),
                    prefixIcon: const Icon(Icons.lock, color: Colors.white),
                  ),
                  obscureText: true,
                ),
                // Sign up button
                const SizedBox(height: 30),
                ElevatedButton(
                  onPressed: () async {
                    if (passwordController.text.trim() == confirmPasswordController.text.trim()) {
                      try {
                        UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
                          email: emailController.text.trim(),
                          password: passwordController.text.trim(),
                        );

                        SharedPreferences prefs = await SharedPreferences.getInstance();
                        await prefs.setString('userID', userCredential.user!.uid);
                        await prefs.setBool('signUpEditingMode', true);

                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: const Text('Account created successfully.'),
                          backgroundColor: Colors.green,
                        ));

                        // Redirection vers la page SignupDetails
                        Navigator.of(context).pushReplacement(
                          MaterialPageRoute(builder: (context) => SignupDetails()),
                        );
                      } on FirebaseAuthException catch (e) {
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Text(e.message ?? 'An error occurred'),
                          backgroundColor: Colors.red,
                        ));
                      }
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                        content: Text('Passwords do not match'),
                        backgroundColor: Colors.red,
                      ));
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    primary: mainColor,
                    padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
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
                  child: const Text('Already have an account? Sign In', style: TextStyle(color: Colors.white)),
                ),
                // Divider
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
