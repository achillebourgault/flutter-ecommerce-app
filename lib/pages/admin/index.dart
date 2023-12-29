import 'package:flutter/material.dart';
import '../profile.dart';

class AdminIndexPage extends StatelessWidget {
  const AdminIndexPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin Area'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => const ProfilePage()),
          ),
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text('Admin area',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
              },
              child: Text('ACTION'),
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                // Actions à exécuter
              },
              child: Text('ACTIONS'),
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
                    onTap: () {
                      // Actions pour l'icône de panier
                    },
                    child: const Icon(Icons.shopping_cart, color: Colors.black),
                  ),
                  InkWell(
                    onTap: () {
                      // Actions pour l'icône de profil
                    },
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
