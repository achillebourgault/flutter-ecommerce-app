import 'dart:convert';

import 'package:ecommerce_app/misc/shop_item.dart';
import 'package:ecommerce_app/misc/shop_user.dart';
import 'package:ecommerce_app/misc/string_extension.dart';
import 'package:ecommerce_app/redux/store.dart';
import 'package:ecommerce_app/widgets/common/clickable_avatar.dart';
import 'package:flutter/material.dart';
import 'package:ecommerce_app/widgets/home/carousel.dart';
import 'package:ecommerce_app/widgets/home/category_buttons.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'auth/sign_in.dart';
import 'package:ecommerce_app/pages/profile.dart';

import 'cart.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();

    SharedPreferences.getInstance().then((prefs) {
      String? userId = prefs.getString('userID');
      // dispatch action to set userId in store
      if (userId != null) {
        ShopUser.getFromId(userId).then((user) {
          StoreProvider.of<ShopState>(context).dispatch(SetUserAction(user));
        });
      } else {
        StoreProvider.of<ShopState>(context).dispatch(ClearUserAction());
      }
    });
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
          StoreConnector<ShopState, ShopUser?>(
            converter: (store) => store.state.user,
            builder: (context, user) => user == null
            ? IconButton(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => SignInPage()),
                  );
                },
                icon: const Icon(Icons.person),
              )
            : SizedBox(
                width: 30,
                height: 30,
                child: ClickableAvatar(
                  image: user.profilePictureBase64 != null ? MemoryImage(base64Decode(user.profilePictureBase64!)) : null,
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => const ProfilePage()),
                    );
                  },
                  child: user.profilePictureBase64 == null
                    ? Container(
                      color: Colors.blueGrey,
                      alignment: Alignment.center,
                      child: Text(user.fullname.getInitials(), style: const TextStyle(color: Colors.white)),
                    )
                    : null,
                )
              )
          ),
          const SizedBox(width: 10)
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
