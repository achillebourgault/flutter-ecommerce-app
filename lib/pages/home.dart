import 'package:flutter/material.dart';
import 'package:ecommerce_app/widgets/home/carousel.dart';
import 'package:ecommerce_app/widgets/home/category_buttons.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'auth/sign_in.dart';
import 'auth/sign_up_details.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  void _navigateUser(BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userId = prefs.getString('userID');
    bool signUpEditingMode = prefs.getBool('signUpEditingMode') ?? false;

    if (userId != null && userId.isNotEmpty) {
      if (signUpEditingMode) {
        // Rediriger l'utilisateur vers SignupDetails
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => SignupDetails()),
        );
      } else {
        // L'utilisateur est connecté et signUpEditingMode est false
        // Rediriger vers HomePage (ou une autre page, selon la logique de l'application)
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const HomePage()),
        );
      }
    } else {
      // Pas d'utilisateur connecté, naviguer vers SignInPage
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => SignInPage()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: ListView(
          children: const <Widget>[
            CategoryButtons(),
            Carousel(categoryName: "men's clothing"),
            Carousel(categoryName: "women's clothing"),
            Carousel(categoryName: "jewelery"),
            Carousel(categoryName: "electronics"),
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
                      // Remove userID & signUpEditingMode from shared preferences
                      SharedPreferences.getInstance().then((prefs) {
                        prefs.remove('userID');
                        prefs.remove('signUpEditingMode');
                      });
                    },
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
