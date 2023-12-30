import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

import '../index.dart';

class AdminProductsIndex extends StatefulWidget {
  @override
  _AdminProductsIndexState createState() => _AdminProductsIndexState();
}

class _AdminProductsIndexState extends State<AdminProductsIndex> {
  Map<String, List<dynamic>> productsByCollection = {};
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchProducts();
  }

  Future<void> _fetchProducts() async {
    setState(() => isLoading = true);
    var url = Uri.parse('http://15.237.20.86:3000/v2/products/getAll');
    var response = await http.get(url);
    if (response.statusCode == 200) {
      List<dynamic> products = json.decode(response.body);
      setState(() {
        productsByCollection = {};
        for (var product in products) {
          String collection = product['collection'] ?? 'Other';
          productsByCollection.putIfAbsent(collection, () => []).add(product);
        }
        isLoading = false;
      });
    } else {
      setState(() => isLoading = false);
    }
  }

  Future<void> _updateProduct(String id, Map<String, dynamic> productData) async {
    try {
      setState(() => isLoading = true);
      var url = Uri.parse('http://15.237.20.86:3000/v2/products/edit/$id');
      var response = await http.post(url, body: json.encode(productData), headers: {'Content-Type': 'application/json'});
      if (json.decode(response.body)['message'] == 'Document updated successfully') {
        await _fetchProducts();
        Navigator.of(context).pop();
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Product updated')));
      } else {
        setState(() => isLoading = false);
      }
    } catch (e) {
      print('Error updating product: $e');
      setState(() => isLoading = false);
    }
  }

  void _confirmDeleteProduct(String id) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Delete Product'),
          content: Text('Are you sure you want to delete this product?'),
          actions: <Widget>[
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            ElevatedButton(
              child: Text('Delete', style: TextStyle(color: Colors.white)),
              onPressed: () {
                Navigator.of(context).pop(); // Cancel Confirm Dialog
                _deleteProduct(id);
                Navigator.of(context).pop(); // Cancel Edit Dialog
              },
              style: ElevatedButton.styleFrom(primary: Colors.red),
            ),
          ],
        );
      },
    );
  }

  Future<void> _deleteProduct(String id) async {
    try {
      setState(() => isLoading = true);
      var url = Uri.parse('http://15.237.20.86:3000/v2/products/delete/$id');
      var response = await http.delete(url);
      if (response.statusCode == 200) {
        await _fetchProducts();
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Product deleted')));
      } else {
        setState(() => isLoading = false);
      }
    } catch (e) {
      print('Error deleting product: $e');
      setState(() => isLoading = false);
    }
  }

  void _showEditProductDialog(Map<String, dynamic> product) {
    TextEditingController titleController = TextEditingController(text: product['title']);
    TextEditingController priceController = TextEditingController(text: product['price'].toString());
    TextEditingController imageUrlController = TextEditingController(text: product['images'][0]['url']);
    TextEditingController descriptionController = TextEditingController(text: product['description']);
    TextEditingController collectionController = TextEditingController(text: product['collection']);

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: Text('Edit Product'),
              content: SingleChildScrollView(
                child: ListBody(
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.only(bottom: 8),
                      child: TextField(
                        controller: titleController,
                        decoration: InputDecoration(labelText: 'Title'),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(bottom: 8),
                      child: TextField(
                        controller: priceController,
                        decoration: InputDecoration(labelText: 'Price'),
                        keyboardType: TextInputType.number,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(bottom: 8),
                      child: Row(
                        children: [
                          Expanded(
                            child: TextField(
                              controller: imageUrlController,
                              decoration: InputDecoration(labelText: 'Image URL'),
                              onChanged: (value) {
                                setState(() {});
                              },
                            ),
                          ),
                          SizedBox(width: 8),
                          (Uri.tryParse(imageUrlController.text)?.isAbsolute ?? false)
                              ? Image.network(
                            imageUrlController.text,
                            width: 50,
                            height: 50,
                            fit: BoxFit.contain,
                            errorBuilder: (context, error, stackTrace) => SizedBox(),
                          )
                              : SizedBox(),
                        ],
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(bottom: 8),
                      child: TextField(
                        controller: descriptionController,
                        decoration: InputDecoration(labelText: 'Description'),
                        maxLines: 3,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(bottom: 8),
                      child: TextField(
                        controller: collectionController,
                        decoration: InputDecoration(labelText: 'Collection'),
                      ),
                    ),
                  ],
                ),
              ),
              actions: <Widget>[
                TextButton(
                  child: Text('Cancel'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
                ElevatedButton(
                  child: Text('Save', style: TextStyle(color: Colors.white)),
                  onPressed: () {
                    Map<String, dynamic> updatedProduct = {
                      'title': titleController.text,
                      'price': double.parse(priceController.text),
                      'images': [{'url': imageUrlController.text}],
                      'description': descriptionController.text,
                      'collection': collectionController.text,
                    };
                    _updateProduct(product['id'], updatedProduct);
                  },
                  style: ElevatedButton.styleFrom(primary: Colors.green),
                ),
                ElevatedButton(
                  child: Text('Delete', style: TextStyle(color: Colors.white)),
                  onPressed: () {
                    _confirmDeleteProduct(product['id']);
                  },
                  style: ElevatedButton.styleFrom(primary: Colors.red),
                ),
              ],
            );
          },
        );
      },
    );
  }

  Widget _buildCategorySection(String collection, List<dynamic> productsInCollection) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(vertical: 10),
          child: Text(
            collection,
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
        ),
        GridView.builder(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: MediaQuery.of(context).size.width > 600 ? 3 : 2,
            childAspectRatio: 1,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
          ),
          itemCount: productsInCollection.length,
          itemBuilder: (context, index) {
            var product = productsInCollection[index];
            return GestureDetector(
              onTap: () => _showEditProductDialog(product),
              child: Card(
                color: Colors.lightBlue[50],
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    Expanded(
                      child: (product['images'] != null && product['images'].isNotEmpty && Uri.tryParse(product['images'][0]['url'])!.isAbsolute ?? false)
                          ? Image.network(
                        product['images'][0]['url'],
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) => Icon(Icons.error),
                      )
                          : Icon(Icons.image_not_supported),
                    ),
                    Padding(
                      padding: EdgeInsets.all(8),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            product['title'],
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 8),
                          Text('\$${product['price']}'),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit your products'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => const AdminIndexPage()));
          },
        ),
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(10),
          child: Column(
            children: productsByCollection.entries.map((entry) {
              return _buildCategorySection(entry.key, entry.value);
            }).toList(),
          ),
        ),
      ),
    );
  }
}
