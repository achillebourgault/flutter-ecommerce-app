import 'package:flutter/material.dart';

class ProductTile extends StatelessWidget {
  const ProductTile({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 150.0,
      height: 216.0,
      child: Card(
        child: Column(
          children: <Widget> [
            AspectRatio(
              aspectRatio: 1,
              child: Container(
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(10.0),
                    topRight: Radius.circular(10.0)
                  )
                ),
                padding: EdgeInsets.all(10.0),
                margin: EdgeInsets.all(5.0),
                child: Image(
                  image: NetworkImage("https://encrypted-tbn0.gstatic.com/shopping?q=tbn:ANd9GcRLfVqFbSuy3JLkIJP6-RV7n94_j2zqIO3HLHvykseOB1-8nCtvz3cJbKsBUeInQgGv8euedPRDM-UOmFz6IZxc3uDIPFtUY3n-SPB1KaqWhaxZgnCRSDLKflE"),
                  fit: BoxFit.contain,
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.only(left: 5.0, right: 5.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget> [
                  const Text("Nike Air Max 270", style: TextStyle(fontSize: 16.0)),

                  const Text("\$150.00", style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold)),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
