import 'package:ecommerce_app/misc/shop_item.dart';
import 'package:ecommerce_app/pages/product_detail.dart';
import 'package:ecommerce_app/redux/shop_items.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:skeletonizer/skeletonizer.dart';

class ProductTile extends StatefulWidget {
  const ProductTile({Key? key, required this.id}) : super(key: key);

  final String id;

  @override
  State<ProductTile> createState() => _ProductTileState();
}

class _ProductTileState extends State<ProductTile> {

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 150.0,
      height: 216.0,
      child: StoreConnector<ShopItemState, ShopItem?>(
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
              child: InkWell(
                onTap: () {
                  if (item != null) {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => ProductDetailPage(item: item)));
                  }
                },
                child: Column(
                  children: <Widget>[
                    AspectRatio(
                      aspectRatio: 1,
                      child: Container(
                        decoration: const BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(10.0),
                                topRight: Radius.circular(10.0))),
                        padding: const EdgeInsets.all(10.0),
                        margin: const EdgeInsets.all(5.0),
                        child: Image(
                          image: NetworkImage(
                              item?.imageUrl ?? "https://encrypted-tbn0.gstatic.com/shopping?q=tbn:ANd9GcRLfVqFbSuy3JLkIJP6-RV7n94_j2zqIO3HLHvykseOB1-8nCtvz3cJbKsBUeInQgGv8euedPRDM-UOmFz6IZxc3uDIPFtUY3n-SPB1KaqWhaxZgnCRSDLKflE"),
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.only(left: 5.0, right: 5.0),
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
              ),
            ),
          );
        },
      ),
    );
  }
}
