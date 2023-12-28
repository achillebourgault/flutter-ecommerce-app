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
              child: ItemCategoryButton(categoryName: "Men's clothing"),
            ),
            Expanded(
              child: ItemCategoryButton(categoryName: "Women's clothing"),
            )
          ],
        ),
        Row(
          children: <Widget> [
            Expanded(
              child: ItemCategoryButton(categoryName: "Jewelery"),
            ),
            Expanded(
              child: ItemCategoryButton(categoryName: "Electronics"),
            )
          ],
        )
      ],
    );
  }
}
