import 'package:ecommerce_app/misc/shop_user.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class AdminUsersPage extends StatefulWidget {
  const AdminUsersPage({Key? key}) : super(key: key);
  @override
  State<AdminUsersPage> createState() => _AdminUsersPageState();
}

class _AdminUsersPageState extends State<AdminUsersPage> {
  List<ShopUser> users = [];
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
      for (var userJson in json.decode(response.body)) {
        ShopUser user = await ShopUser.fromJson(userJson);
        setState(() {
          users.add(user);
        });
      }
      setState(() {
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
        title: const Text('Users'),
        leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () => Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => const AdminIndexPage()))
        ),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
        itemCount: users.length,
        itemBuilder: (context, index) {
          var user = users[index];
          return Card(
            child: ListTile(
              leading: CircleAvatar(
                backgroundImage: user.profilePictureBase64 != null
                    ? MemoryImage(base64Decode(user.profilePictureBase64!))
                    : null,
              ),
              title: Row(
                children: [
                  Text(user.fullname),
                  const SizedBox(width: 8),
                  if (user.isAdmin)
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                      color: Colors.red,
                      child: const Text('ADMIN', style: TextStyle(color: Colors.white, fontSize: 12)),
                    ),
                ],
              ),
              subtitle: Text(user.isAdmin ? 'Admin' : 'User'),
            ),
          );
        },
      ),
    );
  }
}
