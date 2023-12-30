import 'package:ecommerce_app/pages/admin/index.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class AdminUsersPage extends StatefulWidget {
  @override
  _AdminUsersPageState createState() => _AdminUsersPageState();
}

class _AdminUsersPageState extends State<AdminUsersPage> {
  List<dynamic> users = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchUsers();
  }

  Future<void> _fetchUsers() async {
    setState(() => isLoading = true);
    var url = Uri.parse('http://15.237.20.86:3000/auth/getUsersDetails');
    var response = await http.get(url);
    if (response.statusCode == 200) {
      setState(() {
        users = json.decode(response.body);
        isLoading = false;
      });
    } else {
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Users'),
        leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () => Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => const AdminIndexPage()))
        ),
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
        itemCount: users.length,
        itemBuilder: (context, index) {
          var user = users[index];
          return Card(
            child: ListTile(
              leading: CircleAvatar(
                backgroundImage: NetworkImage(user['profilePicture'] ?? ''), // Added null check here
              ),
              title: Row(
                children: [
                  Text(user['fullname'] ?? 'Unknown'), // Added null check here
                  SizedBox(width: 8),
                  if (user['isAdmin'] == true) // Updated condition
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                      color: Colors.red,
                      child: Text('ADMIN', style: TextStyle(color: Colors.white, fontSize: 12)),
                    ),
                ],
              ),
              subtitle: Text(user['isAdmin'] == true ? 'Admin' : 'User'), // Updated condition
            ),
          );
        },
      ),
    );
  }
}
