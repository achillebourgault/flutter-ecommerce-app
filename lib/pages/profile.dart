import 'dart:convert';
import 'package:ecommerce_app/pages/admin/index.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'auth/sign_in.dart';
import 'auth/sign_up_details.dart';
import 'home.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  bool isAdmin = false;

  @override
  void initState() {
    super.initState();
    _checkAdminStatus();
  }

  Future<void> _checkAdminStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userId = prefs.getString('userID');

    if (userId != null) {
      var response = await http.get(Uri.parse('http://15.237.20.86:3000/auth/getUserDetails/$userId'));
      if (response.statusCode == 200) {
        var userDetails = json.decode(response.body);
        setState(() {
          isAdmin = userDetails['isAdmin'] ?? false;
        });
      }
    }
  }

  void _disconnectUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('userID');
    await prefs.remove('signUpEditingMode');

    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
      content: Text('Disconnected successfully'),
      backgroundColor: Colors.green,
    ));

    Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => const HomePage()));
  }

  void _navigateUser(BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userId = prefs.getString('userID');
    bool signUpEditingMode = prefs.getBool('signUpEditingMode') ?? false;

    if (userId != null && userId.isNotEmpty) {
      if (signUpEditingMode) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => SignupDetails()),
        );
      } else {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const ProfilePage()),
        );
      }
    } else {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => SignInPage()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => const HomePage()),
          ),
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: _disconnectUser,
              child: const Text('Disconnect'),
            ),
            if (isAdmin) ElevatedButton(
              onPressed: () {
                Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => const AdminIndexPage()));
              },
              child: const Text('Admin Area'),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        child: Row(
          children: <Widget>[
            Expanded(
              flex: 8,
              child: TextField(
                decoration: InputDecoration(
                  hintText: "Search",
                  prefixIcon: Icon(Icons.search),
                  filled: true,
                  border: OutlineInputBorder(
                    borderSide: BorderSide.none,
                    borderRadius: BorderRadius.all(Radius.circular(100.0)),
                  ),
                ),
              ),
            ),
            Expanded(
              flex: 2,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  InkWell(
                    onTap: _disconnectUser,
                    child: const Icon(Icons.shopping_cart, color: Colors.black),
                  ),
                  InkWell(
                    onTap: () => _navigateUser(context),
                    child: const Icon(Icons.person, color: Colors.black),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
