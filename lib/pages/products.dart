import 'package:ecommerce_app/misc/shop_item.dart';
import 'package:ecommerce_app/redux/store.dart';
import 'package:ecommerce_app/widgets/common/product_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';

class ProductsPage extends StatelessWidget {
  const ProductsPage({Key? key, this.filter}) : super(key: key);

  final String? filter;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Products${filter != null ? ' - $filter' : ''}'),
      ),
      body: SafeArea(
        child: StoreConnector<ShopState, List<ShopItem>>(
          converter: (Store<ShopState> store) {
            if (filter == null) {
              return store.state.items;
            }
            return store.state.items.where((item) => item.category == filter?.toLowerCase()).toList();
          },
          builder: (BuildContext context, List<ShopItem> shopItems) {
            return GridView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
              itemCount: shopItems.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.75,
                crossAxisSpacing: 10.0,
                mainAxisSpacing: 10.0,
              ),
              itemBuilder: (BuildContext context, int index) {
                return ProductTile(id: shopItems[index].id, isHomePage: false);
              },
            );
          },
        ),
      ),
    );
  }
}