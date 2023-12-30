import 'dart:convert';
import 'package:http/http.dart' as http;

class ShopItem {
  final String id;
  final String title;
  final String description;
  String? imageUrl;
  final num price;
  final String category;

  ShopItem({
    required this.id,
    required this.title,
    required this.description,
    required this.imageUrl,
    required this.price,
    required this.category
  });

  factory ShopItem.fromJson(Map<String, dynamic> json) {
    return ShopItem(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      imageUrl: json['images']?[0]?['url'],
      price: json['price'],
      category: json['collection']
    );
  }

  Map toJson() => {
    'id': id,
    'title': title,
    'description': description,
    'images': [{'url': imageUrl}],
    'price': price,
    'collection': category
  };

  static Future<List<ShopItem>> getItems() async {
    
    var url = Uri.parse("http://15.237.20.86:3000/v2/products/getAll");
    final response = await http.get(url, headers: {"Content-Type": "application/json"});
    final List body = json.decode(response.body);
    return body.map((e) => ShopItem.fromJson(e)).toList();
  }
}