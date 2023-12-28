import 'package:ecommerce_app/widgets/home/carousel.dart';
import 'package:ecommerce_app/widgets/home/category_buttons.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
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
      bottomNavigationBar: const BottomAppBar(
        child: Center(
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
      ),
    );
  }
}