import 'package:flutter/material.dart';
import 'package:ecommerce_app/widgets/home/carousel.dart';
import 'package:ecommerce_app/widgets/home/category_buttons.dart';

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
                  InteractiveIcon(icon: Icons.shopping_cart),
                  InteractiveIcon(icon: Icons.person),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class InteractiveIcon extends StatefulWidget {
  final IconData icon;

  const InteractiveIcon({Key? key, required this.icon}) : super(key: key);

  @override
  _InteractiveIconState createState() => _InteractiveIconState();
}

class _InteractiveIconState extends State<InteractiveIcon> {
  Color _iconColor = Colors.black;
  Color _backgroundColor = Colors.grey[200]!;

  void _updateColorOnHover(bool isHovering) {
    setState(() {
      if (isHovering) {
        _iconColor = Colors.white;
        _backgroundColor = Colors.blue;
      } else {
        _iconColor = Colors.black;
        _backgroundColor = Colors.grey[200]!;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onHover: _updateColorOnHover,
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: _backgroundColor,
          shape: BoxShape.circle,
        ),
        child: Icon(widget.icon, color: _iconColor),
      ),
    );
  }
}
