import 'dart:ffi';

import 'package:cloud_firestore/cloud_firestore.dart';
//price = snapshot.data["price"] + 0.0;
class ProductData{

  String category;
  String id;
  String title;
  String desc;
  double price;
  List images;
  List sizes;

  ProductData.fromDocument(DocumentSnapshot snapshot ){
    id = snapshot.documentID;
    title = snapshot.data['title'];
    desc = snapshot.data['desc'];
    price = snapshot.data['price'];
    images = snapshot.data[ 'images'];
    sizes = snapshot.data['sizes'];
  }
  Map<String, dynamic> toResumedMap(){
    return{
      "title": title,
      "desc": desc,
      "price": price
    };
  }
}