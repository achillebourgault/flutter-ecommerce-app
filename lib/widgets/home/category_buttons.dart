import 'package:flutter/material.dart';

import 'item_category_button.dart';

class CategoryButtons extends StatelessWidget {
  const CategoryButtons({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Column(
      children: <Widget> [
        Row(
          children: <Widget> [
            Expanded(
              child: ItemCategoryButton(name: "Men's clothing", icon: Icons.male),
            ),
            Expanded(
              child: ItemCategoryButton(name: "Women's clothing", icon: Icons.female),
            )
          ],
        ),
        Row(
          children: <Widget> [
            Expanded(
              child: ItemCategoryButton(name: "Jewelery", icon: Icons.diamond),
            ),
            Expanded(
              child: ItemCategoryButton(name: "Electronics", icon: Icons.electrical_services),
            )
          ],
        )
      ],
    );
  }
}
