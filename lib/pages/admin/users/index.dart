import 'package:ecommerce_app/misc/shop_user.dart';
import 'package:ecommerce_app/misc/string_extension.dart';
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
      var usersJson = json.decode(response.body) as List;
      var usersFuture = usersJson.map((userJson) => ShopUser.fromJson(userJson)).toList();

      // Attendre que toutes les futures soient résolues
      var usersResolved = await Future.wait(usersFuture);

      setState(() {
        users = usersResolved;
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
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
        itemCount: users.length,
        itemBuilder: (context, index) {
          var user = users[index];
          return Card(
            color: Color.fromRGBO(245, 245, 245, 1.0),
            margin: const EdgeInsets.only(bottom: 12.0),
            child: ListTile(
              leading: user.profilePictureBase64 != null && user.profilePictureBase64!.isNotEmpty
                  ? CircleAvatar(backgroundImage: MemoryImage(base64Decode(user.profilePictureBase64!)))
                  : CircleAvatar(child: Text(user.fullname.getInitials(), style: const TextStyle(color: Colors.white))),
              title: Text(user.fullname, style: const TextStyle(color: Colors.black, fontSize: 18)),
              subtitle: Text(user.isAdmin ? 'Admin' : 'User', style: const TextStyle(color: Colors.black)),
            ),
          );
        },
      ),
    );
  }
}
