import 'package:ecommerce_app/misc/shop_item.dart';
import 'package:flutter/material.dart';
import 'package:skeletonizer/skeletonizer.dart';

class ProductTile extends StatefulWidget {
  const ProductTile({Key? key, required this.id}) : super(key: key);

  final String id;

  @override
  State<ProductTile> createState() => _ProductTileState();
}

class _ProductTileState extends State<ProductTile> {

  late Future<ShopItem> _futureShopItem;
  late ShopItem? _shopItem = null;
  late bool _isLoaded = false;

  @override
  void initState() {
    super.initState();

    _futureShopItem = ShopItem.getItem(widget.id);
    _futureShopItem.then((value) {
      setState(() {
        _isLoaded = true;
        _shopItem = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 150.0,
      height: 216.0,
      child: Skeletonizer(
        enabled: !_isLoaded,
        child: Card(
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
                        _shopItem?.imageUrl ?? "https://encrypted-tbn0.gstatic.com/shopping?q=tbn:ANd9GcRLfVqFbSuy3JLkIJP6-RV7n94_j2zqIO3HLHvykseOB1-8nCtvz3cJbKsBUeInQgGv8euedPRDM-UOmFz6IZxc3uDIPFtUY3n-SPB1KaqWhaxZgnCRSDLKflE"),
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
                      _shopItem?.title ?? "Nike Air Max 270",
                      style: const TextStyle(fontSize: 16.0),
                      overflow: TextOverflow.fade,
                      maxLines: 1,
                      softWrap: false,
                    ),
                    Text("\$${_shopItem?.price ?? "100"}",
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
  }
}
