import 'package:ecommerce_app/misc/shop_item.dart';
import 'package:ecommerce_app/redux/store.dart';
import 'package:ecommerce_app/widgets/common/product_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';

class CheckoutPage extends StatelessWidget {
  const CheckoutPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Checkout', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)), // Adjusted to match CartPage
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text('ORDER SUMMARY', style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            StoreConnector<ShopState, List<ShopItem>>(
              converter: (store) => store.state.cart,
              builder: (context, cart) {
                return Expanded(
                  child: ListView.builder(
                    itemCount: cart.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        leading: ProductImage(imageUrl: cart[index].imageUrl), // Image added
                        title: Text(cart[index].title,
                            maxLines: 2, overflow: TextOverflow.ellipsis),
                        subtitle: Text('\$${cart[index].price.toStringAsFixed(2)}'),
                        trailing: IconButton(
                          icon: const Icon(Icons.delete),
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: const Text('Delete item'),
                                  content: const Text(
                                      'Are you sure you want to delete this item?'),
                                  actions: <Widget>[
                                    TextButton(
                                      child: const Text('Cancel'),
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                    ),
                                    TextButton(
                                      child: const Text('Delete'),
                                      onPressed: () {
                                        StoreProvider.of<ShopState>(context,
                                            listen: false)
                                            .dispatch(RemoveFromCartAction(
                                            cart[index]));
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(const SnackBar(
                                            content: Text(
                                                'Item removed from cart')));
                                        Navigator.of(context).pop();
                                      },
                                    ),
                                  ],
                                );
                              },
                            );
                          },
                        ),
                      );
                    },
                  ),
                );
              },
            ),
            const Divider(),
            StoreConnector<ShopState, double>(
              converter: (store) => store.state.cart
                  .fold(0, (previousValue, element) => previousValue + element.price),
              builder: (context, total) {
                return Column(
                  children: [
                    Text('Item Total: ${total.toStringAsFixed(2)}'),
                    const SizedBox(height: 10),
                    const Text('Grand Total', style: TextStyle(fontWeight: FontWeight.bold)),
                    Text('\$${total.toStringAsFixed(2)}'),
                  ],
                );
              },
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black,
                foregroundColor: Colors.white,
                textStyle: const TextStyle(fontSize: 17),
                padding: const EdgeInsets.symmetric(horizontal: 26, vertical: 18),
              ),
              onPressed: () {
                // No checkout functionality needed for this project
              },
              child: const Text('CONTINUE'),
            ),
          ],
        ),
      ),
    );
  }
}
