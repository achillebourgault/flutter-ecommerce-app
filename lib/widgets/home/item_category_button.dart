import 'package:flutter/material.dart';

class ItemCategoryButton extends StatelessWidget {
  const ItemCategoryButton({Key? key, required this.categoryName}) : super(key: key);

  final String categoryName;

  @override
  Widget build(BuildContext context) {
    onPressed() {}

    return Container(
      padding: const EdgeInsets.only(left: 5.0, right:5.0),
      child: FilledButton.tonal(
        onPressed: onPressed,
        child: Text(categoryName),
      ),
    );
  }
}