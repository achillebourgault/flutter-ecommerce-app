import 'package:flutter/material.dart';

class CheckoutPage extends StatelessWidget {
  const CheckoutPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('CHECKOUT'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const ListTile(
              title: Text('FirstItem'),
              subtitle: Text('PRICE'),
              trailing: Text('Change', style: TextStyle(color: Colors.blue)),
            ),
            const Divider(),
            Expanded(
              child: ListView(
                children: const [
                  Text('ORDER SUMMARY', style: TextStyle(fontWeight: FontWeight.bold)),
                  SizedBox(height: 10),
                  Text('Item Total: 1 item(s)'),
                  Text('Shipping'),
                  SizedBox(height: 10),
                  Text('Grand Total', style: TextStyle(fontWeight: FontWeight.bold)),
                  Text('12 EUR'),
                ],
              ),
            ),
            ElevatedButton(
              onPressed: () {
                // Implement the checkout functionality here
              },
              child: const Text('CONTINUE'),
            ),
          ],
        ),
      ),
    );
  }
}
