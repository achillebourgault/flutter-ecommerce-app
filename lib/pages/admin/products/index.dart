import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class AdminProductsIndex extends StatefulWidget {
  const AdminProductsIndex({Key? key}) : super(key: key);
  @override
  State<AdminProductsIndex> createState() => _AdminProductsIndexState();
}

class _AdminProductsIndexState extends State<AdminProductsIndex> {
  Map<String, List<dynamic>> productsByCollection = {};
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchProducts();
  }

  void _fetchProducts() {
    setState(() => isLoading = true);
    var url = Uri.parse('http://15.237.20.86:3000/v2/products/getAll');
    http.get(url).then((response) {
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
    });
  }

  void _updateProduct(String id, Map<String, dynamic> productData) {
    setState(() => isLoading = true);
    var url = Uri.parse('http://15.237.20.86:3000/v2/products/edit/$id');
    http
        .post(url, body: json.encode(productData), headers: {'Content-Type': 'application/json'})
        .then((response) {
      if (json.decode(response.body)['message'] == 'Document updated successfully') {
        _fetchProducts();
        Navigator.of(context).pop();
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Product updated')));
      } else {
        setState(() => isLoading = false);
      }
    }).catchError((e) {
      setState(() => isLoading = false);
    });
  }

  void _confirmDeleteProduct(String id) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Delete Product'),
          content: const Text('Are you sure you want to delete this product?'),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop(); // Cancel Confirm Dialog
                _deleteProduct(id).then((_) {
                  Navigator.of(context).pop(); // Cancel Edit Dialog
                });
              },
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
              child: const Text('Delete', style: TextStyle(color: Colors.white)),
            ),
          ],
        );
      },
    );
  }

  Future<void> _deleteProduct(String id) {
    setState(() => isLoading = true);
    var url = Uri.parse('http://15.237.20.86:3000/v2/products/delete/$id');
    return http.delete(url).then((response) {
      if (response.statusCode == 200) {
        _fetchProducts();
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Product deleted')));
      } else {
        setState(() => isLoading = false);
      }
    }).catchError((e) {
      setState(() => isLoading = false);
    });
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
              backgroundColor: const Color.fromRGBO(245, 245, 245, 1.0),
              title: const Text('Edit Product'),
              content: SingleChildScrollView(
                child: ListBody(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: TextField(
                        controller: titleController,
                        decoration: const InputDecoration(labelText: 'Title'),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: TextField(
                        controller: priceController,
                        decoration: const InputDecoration(labelText: 'Price'),
                        keyboardType: TextInputType.number,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: Row(
                        children: [
                          Expanded(
                            child: TextField(
                              controller: imageUrlController,
                              decoration: const InputDecoration(labelText: 'Image URL'),
                              onChanged: (value) {
                                setState(() {});
                              },
                            ),
                          ),
                          const SizedBox(width: 8),
                          (Uri.tryParse(imageUrlController.text)?.isAbsolute ?? false)
                              ? Image.network(
                            imageUrlController.text,
                            width: 50,
                            height: 50,
                            fit: BoxFit.contain,
                            errorBuilder: (context, error, stackTrace) => const SizedBox(),
                          )
                              : const SizedBox(),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: TextField(
                        controller: descriptionController,
                        decoration: const InputDecoration(labelText: 'Description'),
                        maxLines: 3,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: TextField(
                        controller: collectionController,
                        decoration: const InputDecoration(labelText: 'Collection'),
                      ),
                    ),
                  ],
                ),
              ),
              actions: <Widget>[
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                    foregroundColor: Colors.white,
                  ),
                    child: const Text('Cancel'),
                    onPressed: () {
                      Navigator.of(context).pop();
                    }
                ),
                ElevatedButton(
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
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.black),
                  child: const Text('Save', style: TextStyle(color: Colors.white)),
                ),
                ElevatedButton(
                  onPressed: () {
                    _confirmDeleteProduct(product['id']);
                  },
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                  child: const Text('Delete', style: TextStyle(color: Colors.white)),
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
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: Text(
            collection,
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
        ),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
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
                color: const Color.fromRGBO(245, 245, 245, 1.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    Expanded(
                      child: (product['images'] != null && product['images'].isNotEmpty && Uri.tryParse(product['images'][0]['url'])!.isAbsolute)
                          ? Image.network(
                        product['images'][0]['url'],
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) => const Icon(Icons.error),
                      )
                          : const Icon(Icons.image_not_supported),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            product['title'],
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
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
        title: const Text('Edit your products'),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(10),
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
