import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Products with ChangeNotifier {
  final String id;
  final String title;
  final String desc;
  final double price;
  final String imageUrl;
  bool isFavourite;
  Products(
      {@required this.id,
      @required this.title,
      @required this.desc,
      @required this.price,
      @required this.imageUrl,
      this.isFavourite = false});
  Future<void> reverseFav(String token, String userID) async {
    final url =
        'https://shop2go-f94d9.firebaseio.com/userFavourites/$userID/$id.json?auth=$token';
    isFavourite = !isFavourite;
    notifyListeners();

    await http.put(url, body: json.encode(isFavourite));
  }
}
