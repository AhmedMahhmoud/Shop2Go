import 'package:flutter/material.dart';
import 'package:shopapp/Providers/Cart.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class OrderItem {
  final String id;
  final double amount;

  final List<CartItem> products;
  final DateTime datetime;
  OrderItem(
      {@required this.amount,
      @required this.datetime,
      @required this.id,
      @required this.products});
}

class Orders with ChangeNotifier {
  List<OrderItem> orders = [];
  List<OrderItem> get getOrders {
    return orders;
  }

  final String orderToken;
  final String userId;
  Orders(this.orderToken, this.orders, this.userId);

  Future<void> addOrder(List<CartItem> cartProducts, double total) async {
    final url =
        'https://shop2go-f94d9.firebaseio.com/orders/$userId.json?auth=$orderToken';
    final timestamp = DateTime.now();
    final response = await http.post(url,
        body: json.encode({
          'Amount': total,
          'DateTime': timestamp.toIso8601String(),
          'Products': cartProducts
              .map((e) => {
                    'ID': e.id,
                    'Title': e.title,
                    'Quantity': e.quantity,
                    'Price': e.price,
                    'imageUrl': e.imageUrl,
                  })
              .toList()
        }));
    orders.insert(
        0,
        OrderItem(
            amount: total,
            datetime: timestamp,
            id: json.decode(response.body)['name'],
            products: cartProducts));
    // print(json.decode(response.body));

    notifyListeners();
  }

  Future<void> fetchOrdersOnline() async {
    final url =
        'https://shop2go-f94d9.firebaseio.com/orders/$userId.json?auth=$orderToken';
    final response = await http.get(url);
    final decodedOrder = json.decode(response.body);
    final List<OrderItem> loadedOrders = [];
    if (decodedOrder == Null) {
      return;
    }
    try {
      decodedOrder.forEach((key, val) {
        loadedOrders.add(OrderItem(
            id: key,
            amount: val['Amount'],
            datetime: DateTime.parse(val['DateTime']),
            products: (val['Products'] as List<dynamic>)
                .map((item) => CartItem(
                    id: item['ID'],
                    price: item['Price'],
                    quantity: item['Quantity'],
                    imageUrl: item['imageUrl'],
                    title: item['Title']))
                .toList()));
      });
      orders = loadedOrders.reversed.toList();
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }
}
