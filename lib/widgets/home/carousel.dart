import 'package:ecommerce_app/misc/shop_item.dart';
import 'package:ecommerce_app/redux/store.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';

import '../common/product_tile.dart';

class Carousel extends StatefulWidget {
  const Carousel({Key? key, required this.categoryName}) : super(key: key);

  final String categoryName;

  @override
  State<Carousel> createState() => _CarouselState();
}

class _CarouselState extends State<Carousel> {

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 10.0, bottom: 10.0),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(left: 10.0),
            child: Text("Featured ${widget.categoryName}", style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
          ),
          const SizedBox(height: 10.0),
          SizedBox(
            height: 200.0,
            child: StoreConnector<ShopState, List<ShopItem>>(
              converter: (store) {
                List<ShopItem> items = store.state.items.where((element) => element.category == widget.categoryName).toList();
                items.shuffle();
                if (items.length > 4) {
                  items = items.sublist(0, 4);
                }
                return items;
              },
              builder: (context, items) {
                if (items.isNotEmpty) {
                  return ListView.builder(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.only(left: 10.0, right: 10.0),
                    itemCount: items.length,
                    itemBuilder: (context, index) {
                      return ProductTile(id: items[index].id, isHomePage: true);
                    },
                  );
                } else {
                  return const Center(child: CircularProgressIndicator());
                }
              },
            ),
          ),
        ],
      )
    );
  }
}
