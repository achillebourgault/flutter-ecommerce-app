import 'package:ecommerce_app/misc/shop_item.dart';
import 'package:ecommerce_app/pages/product_detail.dart';
import 'package:ecommerce_app/redux/store.dart';
import 'package:ecommerce_app/widgets/common/product_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:skeletonizer/skeletonizer.dart';

class ProductTile extends StatefulWidget {
  const ProductTile({Key? key, required this.id, required this.isHomePage}) : super(key: key);

  final String id;
  final bool isHomePage;

  @override
  State<ProductTile> createState() => _ProductTileState();
}

class _ProductTileState extends State<ProductTile> {

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 150.0,
      height: 216.0,
      child: StoreConnector<ShopState, ShopItem?>(
        converter: (store) {
          try {
            return store.state.items.firstWhere((element) => (element.id == widget.id));
          } catch (e) {
            return null;
          }
        },
        builder: (context, item) {
          return Skeletonizer(
            enabled: item == null,
            child: Card(
              clipBehavior: Clip.antiAlias,
              color: const Color.fromRGBO(245, 245, 245, 1.0),
              child: InkWell(
                onTap: () {
                  if (item != null) {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => ProductDetailPage(item: item, fromRoute: widget.isHomePage ? "home" : "products",)));
                  }
                },
                child: Column(
                  children: <Widget>[
                    Hero(
                      tag: "${item?.id ?? widget.id}_${widget.isHomePage ? "home" : "products"}",
                      child: ProductImage(imageUrl: item?.imageUrl),
                    ),
                    Container(
                      padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            item?.title ?? "Nike Air Max 270",
                            style: const TextStyle(fontSize: 16.0),
                            overflow: TextOverflow.fade,
                            maxLines: 1,
                            softWrap: false,
                          ),
                          Text("\$${item?.price ?? "100"}",
                              style:
                              const TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold)),
                        ],
                      ),
                    )
                  ],
                ),
              )
            ),
          );
        },
      ),
    );
  }
}
