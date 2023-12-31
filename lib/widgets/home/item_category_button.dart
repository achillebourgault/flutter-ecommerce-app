import 'package:ecommerce_app/pages/products.dart';
import 'package:flutter/material.dart';

class ItemCategoryButton extends StatelessWidget {
  const ItemCategoryButton({Key? key, required this.name, required this.icon}) : super(key: key);

  final IconData icon;
  final String name;

  @override
  Widget build(BuildContext context) {
    onPressed() {
      Navigator.push(context, MaterialPageRoute(builder: (context) => ProductsPage(filter: name)));
    }

    return Container(
      padding: const EdgeInsets.only(left: 5.0, right:5.0, top: 10.0),
      child: FilledButton.tonal(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          primary: Color.fromRGBO(1, 1, 1, 0.98),
          onPrimary: Colors.white,
          textStyle: const TextStyle(fontSize: 17),
          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 22),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Icon(icon),
            const SizedBox(width: 5.0),
            Text(name),
          ],
        )
      ),
    );
  }
}
