import 'package:ecommerce_app/misc/shop_item.dart';
import 'package:ecommerce_app/redux/store.dart';
import 'package:flutter/material.dart';
import 'package:ecommerce_app/widgets/home/carousel.dart';
import 'package:ecommerce_app/widgets/home/category_buttons.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:localstorage/localstorage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'auth/sign_in.dart';
import 'auth/sign_up_details.dart';
import 'package:ecommerce_app/pages/profile.dart';

import 'cart.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  void _navigateUser(BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userId = prefs.getString('userID');
    bool signUpEditingMode = prefs.getBool('signUpEditingMode') ?? false;

    if (userId != null && userId.isNotEmpty) {
      if (signUpEditingMode) {
        // Rediriger l'utilisateur vers SignupDetails
        Navigator.of(context).push(
          MaterialPageRoute(builder: (context) => SignupDetails()),
        );
      } else {
        // L'utilisateur est connecté et signUpEditingMode est false
        // Rediriger vers HomePage (ou une autre page, selon la logique de l'application)
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const ProfilePage()),
        );
      }
    } else {
      // Pas d'utilisateur connecté, naviguer vers SignInPage
      Navigator.of(context).push(
        MaterialPageRoute(builder: (context) => SignInPage()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
        actions: <Widget>[
          IconButton(
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => const CartPage()),
              );
            },
            icon: StoreConnector<ShopState, List<ShopItem>>(
              converter: (store) => store.state.cart,
              builder: (context, items) =>
                items.isNotEmpty
                  ? Badge.count(
                    count: items.length,
                    child: const Icon(Icons.shopping_cart),
                  )
                  : const Icon(Icons.shopping_cart),
            ),
          ),
          IconButton(
            onPressed: () => _navigateUser(context),
            icon: const Icon(Icons.person),
          ),
        ],
      ),
      body: SafeArea(
        bottom: false,
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
    );
  }
}
