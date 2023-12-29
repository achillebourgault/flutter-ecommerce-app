import 'package:flutter/material.dart';

class ProductImage extends StatelessWidget {
  final String? imageUrl;

  const ProductImage({Key? key, this.imageUrl}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
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
          image: NetworkImage(imageUrl ?? "https://encrypted-tbn0.gstatic.com/shopping?q=tbn:ANd9GcRLfVqFbSuy3JLkIJP6-RV7n94_j2zqIO3HLHvykseOB1-8nCtvz3cJbKsBUeInQgGv8euedPRDM-UOmFz6IZxc3uDIPFtUY3n-SPB1KaqWhaxZgnCRSDLKflE"),
          fit: BoxFit.contain,
        ),
      ),
    );
  }
}
