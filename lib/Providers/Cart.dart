import 'package:flutter/cupertino.dart';

class CartItem {
  final String id;
  final String title;
  final double price;
  final String imageUrl;
  final int quantity;

  CartItem({this.id, this.price, this.title, this.quantity, this.imageUrl});
}

class Cart with ChangeNotifier {
  Map<String, CartItem> _items = {};

  Map<String, CartItem> get items {
    return {..._items};
  }

  int get itemsCount {
    return _items.length;
  }

  double get CalcTotal {
    var sum = 0.0;
    _items.forEach((Key, CartItem) {
      sum = sum + CartItem.price * CartItem.quantity;
    });
    return sum;
  }

  void removeItem(String id) {
    _items.remove(id);
    notifyListeners();
  }

  void removeALL() {
    _items.clear();
    notifyListeners();
  }

  bool isempty() {
    if (_items.length == 0) {
      return true;
    } else {
      return false;
    }
  }

  void addItem(String productID, double price, String title, String imageUrl) {
    if (_items.containsKey(productID)) {
      _items.update(
          productID,
          (existingCartItem) => CartItem(
              id: existingCartItem.id,
              price: existingCartItem.price,
              imageUrl: existingCartItem.imageUrl,
              quantity: existingCartItem.quantity + 1,
              title: existingCartItem.title));
    } else {
      _items.putIfAbsent(
          productID,
          () => CartItem(
              id: DateTime.now().toString(),
              title: title,
              quantity: 1,
              imageUrl: imageUrl,
              price: price));
    }
    notifyListeners();
  }
}
