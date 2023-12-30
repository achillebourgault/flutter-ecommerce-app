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
      padding: const EdgeInsets.only(left: 5.0, right:5.0),
      child: FilledButton.tonal(
        onPressed: onPressed,
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
