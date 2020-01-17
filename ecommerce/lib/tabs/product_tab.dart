import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce/tiles/category_tile.dart';
import 'package:flutter/material.dart';

class ProductTab extends StatefulWidget {
  @override
  _ProductTabState createState() => _ProductTabState();
}

class _ProductTabState extends State<ProductTab> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<QuerySnapshot>(
      future: Firestore.instance.collection("products").getDocuments(),
      builder: (context, snapshot) {
        if (!snapshot.hasData)
          return Center(child: CircularProgressIndicator());
        else {
          var dividedTiles = ListTile.divideTiles(
                  tiles: snapshot.data.documents.map((doc) {
                    return CategoryTile(doc);
                  }).toList(),
                  color: Colors.grey[500])
              .toList();
          return ListView(
            padding: EdgeInsets.fromLTRB(10.0, 15.0, 10.0, 0.0),
            children: dividedTiles,
          );
        }
      },
    );
  }
}
