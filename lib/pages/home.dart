import 'package:ecommerce_app/widgets/home/category_buttons.dart';
import 'package:flutter/material.dart';

import '../widgets/common/product_tile.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: <Widget> [
            CategoryButtons(),
            Container(
              height: 200.0,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: const <Widget> [
                  ProductTile(),
                  ProductTile(),
                  ProductTile(),
                  ProductTile(),
                ],
              ),
            ),
          ],
        )
      ),
      bottomNavigationBar: const BottomAppBar(
        child: Center(
          child: TextField(
            decoration: InputDecoration(
              hintText: "Search",
              prefixIcon: Icon(Icons.search),
              filled: true,
              border: OutlineInputBorder(
                borderSide: BorderSide.none,
                borderRadius: BorderRadius.all(Radius.circular(100.0))
              )
            )
          ),
        )
      ),
    );
  }
}