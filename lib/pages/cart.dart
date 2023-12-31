import 'package:ecommerce_app/misc/shop_item.dart';
import 'package:ecommerce_app/pages/checkout.dart';
import 'package:ecommerce_app/redux/store.dart';
import 'package:ecommerce_app/widgets/common/product_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';

class CartPage extends StatefulWidget {
  const CartPage({Key? key}) : super(key: key);

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return StoreConnector<ShopState, List<ShopItem>>(
      converter: (store) => store.state.cart,
      builder: (context, cart) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('Cart'),
          ),
          body: SafeArea(
            child: Builder(
              builder: (context) {
                if (cart.isNotEmpty) {
                  return ListView.builder(
                    itemCount: cart.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        leading: ProductImage(imageUrl: cart[index].imageUrl),
                        title: Text(cart[index].title,
                            maxLines: 2, overflow: TextOverflow.ellipsis),
                        subtitle:
                            Text('\$${cart[index].price.toStringAsFixed(2)}'),
                        trailing: IconButton(
                          icon: const Icon(Icons.delete),
                          onPressed: () {
                            // Ask the user to confirm deletion
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
                  );
                } else {
                  return const Center(child: Text('Your cart is empty'));
                }
              },
            ),
          ),
          bottomNavigationBar: cart.isNotEmpty ? BottomAppBar(
            child: Row(
              children: [
                const Spacer(),
                StoreConnector<ShopState, double>(
                  converter: (store) => store.state.cart
                      .fold(0, (previousValue, element) => previousValue + element.price),
                  builder: (context, total) {
                    return Text(
                      '\$${total.toStringAsFixed(2)}',
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    );
                  },
                ),
                const SizedBox(width: 16.0),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                    foregroundColor: Colors.white,
                    textStyle: const TextStyle(fontSize: 17),
                    padding: const EdgeInsets.symmetric(horizontal: 26, vertical: 18),
                  ),
                  onPressed: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => const CheckoutPage()));
                  },
                  child: const Text('Checkout'),
                )
              ],
            ),
          ) : null,
        );
      }
    );
  }
}
