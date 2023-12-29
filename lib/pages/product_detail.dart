import 'package:ecommerce_app/misc/shop_item.dart';
import 'package:ecommerce_app/widgets/common/product_image.dart';
import 'package:flutter/material.dart';

class ProductDetailPage extends StatelessWidget {
  final ShopItem item;

  const ProductDetailPage({Key? key, required this.item}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Product Detail'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.only(bottom: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                item.title,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Hero(
                tag: item.id,
                child: ProductImage(imageUrl: item.imageUrl),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                item.description,
                style: const TextStyle(
                  fontSize: 16,
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        child: Row(
          children: [
            const Spacer(),
            Text(
              '\$${item.price.toStringAsFixed(2)}',
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(width: 16.0),
            ElevatedButton(
              onPressed: () {
                // TODO: Implement add to cart functionality
              },
              child: const Text('Add to Cart'),
            ),
          ],
        ),
      ) 
    );
  }
}