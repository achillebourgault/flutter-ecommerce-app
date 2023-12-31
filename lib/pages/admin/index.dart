import 'package:ecommerce_app/pages/admin/products/index.dart';
import 'package:ecommerce_app/pages/admin/users/index.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

const mainColor = Color.fromRGBO(245, 245, 245, 1.0);

class AdminIndexPage extends StatefulWidget {
  const AdminIndexPage({Key? key}) : super(key: key);

  @override
  State<AdminIndexPage> createState() => _AdminIndexPageState();
}

class _AdminIndexPageState extends State<AdminIndexPage> {
  int productCount = 0;
  int userCount = 0;
  bool isLoading = true;
  String adminName = 'Admin';

  @override
  void initState() {
    super.initState();
    _getProductCount();
    _getUserCount();
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

  Future<void> _getUserCount() async {
    var response = await http.get(Uri.parse('http://15.237.20.86:3000/auth/getUsersDetails'));
    if (response.statusCode == 200) {
      setState(() {
        userCount = json.decode(response.body).length;
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
      borderRadius: BorderRadius.circular(15),
      child: Card(
        color: mainColor,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20.0),
          child: Stack(
            children: [
              Align(
                alignment: Alignment.topLeft,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w600,
                        color: Colors.black,
                      ),
                    ),
                    const Divider(
                        color: Colors.black12,
                        thickness: 2.5,
                    ),
                    Text(
                      '$count',
                      style: const TextStyle(
                        fontSize: 42,
                        fontWeight: FontWeight.bold,
                        fontStyle: FontStyle.italic,
                        color: Colors.black38,
                      ),
                    ),
                  ],
                ),
              ),
              const Align(
                alignment: Alignment.bottomRight,
                child: Text(
                  'Tap to manage',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.black,
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
      appBar: AppBar(
        title: const Text('Admin Area', style: TextStyle(color: Colors.black87)),
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: ListView(
          children: [
            Text(
              'Welcome $adminName',
              style: const TextStyle(fontSize: 26, fontWeight: FontWeight.w300, color: Colors.black87),
            ),
            const SizedBox(height: 20),
            isLoading
                ? const Center(child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Colors.white70)))
                : _buildStatCard('Products', productCount, () {
              Navigator.of(context).push(MaterialPageRoute(builder: (context) => const AdminProductsIndex()));
            }),
            const SizedBox(height: 20),
            isLoading
                ? const Center(child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Colors.white70)))
                : _buildStatCard('Users', userCount, () { // Update userCount
              Navigator.of(context).push(MaterialPageRoute(builder: (context) => const AdminUsersPage()));
            }),
          ],
        ),
      )
    );
  }
}
