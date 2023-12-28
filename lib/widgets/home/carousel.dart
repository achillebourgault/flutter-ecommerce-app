import 'package:ecommerce_app/misc/shop_item.dart';
import 'package:ecommerce_app/misc/string_extension.dart';
import 'package:flutter/material.dart';

import '../common/product_tile.dart';

class Carousel extends StatefulWidget {
  const Carousel({Key? key, required this.categoryName}) : super(key: key);

  final String categoryName;

  @override
  State<Carousel> createState() => _CarouselState();
}

class _CarouselState extends State<Carousel> {

  late Future<List<ShopItem>> _futureShopItems;

  @override
  void initState() {
    super.initState();
    
    _futureShopItems = ShopItem.getItems();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 10.0, bottom: 10.0),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(left: 10.0),
            child: Text("Featured ${widget.categoryName}", style: Theme.of(context).textTheme.headlineSmall)
          ),
          SizedBox(
            height: 200.0,
            child: FutureBuilder<List<ShopItem>>(
              future: _futureShopItems,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  List<ShopItem> categoryItems = snapshot.data!.where((element) => element.category == widget.categoryName).toList();
                  categoryItems.shuffle();
                  categoryItems = categoryItems.sublist(0, 4);
                  return ListView.builder(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.only(left: 10.0, right: 10.0),
                    itemCount: categoryItems?.length,
                    itemBuilder: (context, index) {
                      return ProductTile(id: categoryItems?[index].id ?? "");
                    },
                  );
                } else if (snapshot.hasError) {
                  return Text("${snapshot.error}");
                }

                return const Center(child: CircularProgressIndicator());
              },
            ),
          ),
        ],
      )
    );
  }
}
