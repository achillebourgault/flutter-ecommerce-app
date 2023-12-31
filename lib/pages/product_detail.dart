import 'package:ecommerce_app/misc/shop_item.dart';
import 'package:ecommerce_app/pages/cart.dart';
import 'package:ecommerce_app/redux/store.dart';
import 'package:ecommerce_app/widgets/common/product_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';

class ProductDetailPage extends StatelessWidget {
  final ShopItem item;
  final String fromRoute;

  const ProductDetailPage({Key? key, required this.item, required this.fromRoute}) : super(key: key);

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
                tag: '${item.id}_$fromRoute',
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
              style: ElevatedButton.styleFrom(
                primary: Colors.black,
                onPrimary: Colors.white,
                textStyle: const TextStyle(fontSize: 17),
                padding: const EdgeInsets.symmetric(horizontal: 26, vertical: 18),
              ),
              onPressed: () {
                StoreProvider.of<ShopState>(context).dispatch(AddToCartAction(item));
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: const Text('Added to cart'),
                    duration: const Duration(seconds: 1),
                    action: SnackBarAction(
                      label: 'View Cart',
                      onPressed: () {
                        Navigator.push(context, MaterialPageRoute(builder: (context) => const CartPage()));
                      },
                    )
                  ),
                );
              },
              child: const Text('Add to Cart'),
            ),
          ],
        ),
      ) 
    );
  }
}