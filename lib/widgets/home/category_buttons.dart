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
              child: ItemCategoryButton(categoryName: "Shirts"),
            ),
            Expanded(
              child: ItemCategoryButton(categoryName: "Pants"),
            )
          ],
        ),
        Row(
          children: <Widget> [
            Expanded(
              child: ItemCategoryButton(categoryName: "Shoes"),
            ),
            Expanded(
              child: ItemCategoryButton(categoryName: "Accessories"),
            )
          ],
        )
      ],
    );
  }
}
