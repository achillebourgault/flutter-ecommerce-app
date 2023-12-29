import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../home.dart';
import '../profile.dart';

const mainColor = Color(0xFF151026);

class AdminIndexPage extends StatefulWidget {
  const AdminIndexPage({Key? key}) : super(key: key);

  @override
  _AdminIndexPageState createState() => _AdminIndexPageState();
}

class _AdminIndexPageState extends State<AdminIndexPage> {
  int productCount = 0;
  bool isLoading = true;
  String adminName = 'Admin';

  @override
  void initState() {
    super.initState();
    _getProductCount();
    _getAdminName();
  }

  Future<void> _getProductCount() async {
    var response = await http.get(Uri.parse('http://15.237.20.86:3000/v2/products/getAll'));
    if (response.statusCode == 200) {
      setState(() {
        productCount = json.decode(response.body).length;
        isLoading = false;
      });
    }
  }

  Future<void> _getAdminName() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userId = prefs.getString('userID');

    if (userId != null) {
      var response = await http.get(Uri.parse('http://15.237.20.86:3000/auth/getUserDetails/$userId'));
      if (response.statusCode == 200) {
        var userDetails = json.decode(response.body);
        setState(() {
          adminName = userDetails['fullname'] ?? 'Admin';
        });
      }
    }
  }

  Widget _buildStatCard(String title, int count, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: Card(
        color: mainColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 20.0),
          child: Stack(
            children: [
              Align(
                alignment: Alignment.topLeft,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontSize: 21,
                        fontWeight: FontWeight.w100,
                        color: Colors.white70, // Light text for the title
                      ),
                    ),
                    Divider(
                        color: Color.fromARGB(61, 127, 151, 255),
                        thickness: 2.5,
                    ), // Light divider line
                    Text(
                      '$count',
                      style: TextStyle(
                        fontSize: 42,
                        fontWeight: FontWeight.bold,
                        fontStyle: FontStyle.italic,
                        color: Colors.white70, // Light text for the number
                      ),
                    ),
                  ],
                ),
              ),
              Align(
                alignment: Alignment.bottomRight,
                child: Text(
                  'Tap to manage',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white70, // Light text for the "Tap to manage"
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black87, // Dark background for the scaffold
      appBar: AppBar(
        backgroundColor: Colors.black87, // Dark background for the app bar
        title: const Text('Admin Area', style: TextStyle(color: Colors.white70)), // Light text for the app bar
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white70), // Light icon for the app bar
          onPressed: () => Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => const ProfilePage()),
          ),
        ),
      ),
      body: Container(
        color: Colors.black87,
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: ListView(
            children: [
              Text(
                'Welcome $adminName',
                style: TextStyle(fontSize: 22, fontStyle: FontStyle.italic, fontWeight: FontWeight.w100, color: Colors.white70), // Light text for the welcome message
              ),
              const SizedBox(height: 20),
              isLoading
                  ? Center(child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Colors.white70))) // Light loading indicator
                  : _buildStatCard('Products', productCount, () {
                Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => const HomePage()));
              }),
              const SizedBox(height: 20),
              _buildStatCard('Users', 42, () {
                // Actions pour les utilisateurs
              }),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        color: Colors.black87, // Dark background for the bottom app bar
        child: Row(
          children: <Widget>[
            Expanded(
              flex: 8,
              child: TextField(
                style: TextStyle(color: Colors.white70), // Light text for the text field
                decoration: InputDecoration(
                  hintText: "Search",
                  hintStyle: TextStyle(color: Colors.white70), // Light hint text for the text field
                  prefixIcon: Icon(Icons.search, color: Colors.white70), // Light icon for the text field
                  fillColor: Colors.black54, // Dark fill for the text field
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
                  Icon(Icons.shopping_cart, color: Colors.white70), // Light icon for shopping cart
                  Icon(Icons.person, color: Colors.white70), // Light icon for person
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
