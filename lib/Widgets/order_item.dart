import 'dart:math';

import 'package:flutter/material.dart';

import 'package:shopapp/Providers/Orders.dart';
import 'package:intl/intl.dart';

class OrderItemWidg extends StatefulWidget {
  final OrderItem orderItem;
  OrderItemWidg(this.orderItem);

  @override
  _OrderItemWidgState createState() => _OrderItemWidgState();
}

class _OrderItemWidgState extends State<OrderItemWidg> {
  @override
  @override
  var expanded = false;
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white54,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      child: Column(
        children: [
          ListTile(
            title: Text(
              '${widget.orderItem.amount.toStringAsFixed(2)}\$',
              style: TextStyle(
                fontStyle: FontStyle.italic,
                fontSize: 17,
                letterSpacing: 1,
              ),
            ),
            subtitle: Text(
              DateFormat('dd/MM/yyyy hh:mm').format(widget.orderItem.datetime),
              style: TextStyle(
                  fontStyle: FontStyle.italic,
                  fontSize: 15,
                  letterSpacing: 1,
                  color: Colors.grey[700]),
            ),
            trailing: IconButton(
              icon: Icon(expanded ? Icons.expand_less : Icons.expand_more),
              onPressed: () {
                setState(() {
                  expanded = !expanded;
                });
              },
            ),
          ),
          if (expanded)
            SingleChildScrollView(
              child: Container(
                padding: EdgeInsets.all(8),
                height: min(widget.orderItem.products.length * 20.0 + 80, 180),
                child: ListView(
                  children: widget.orderItem.products
                      .map((e) => Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              children: [
                                CircleAvatar(
                                  radius: 24,
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(30),
                                    child: Image(
                                      image: NetworkImage(e.imageUrl),
                                    ),
                                  ),
                                ),
                                Spacer(),
                                Text(
                                  ' ${e.quantity} X  ${e.price}\$',
                                  style: TextStyle(
                                      fontStyle: FontStyle.italic,
                                      fontSize: 15,
                                      letterSpacing: 1,
                                      fontWeight: FontWeight.w600),
                                )
                              ],
                            ),
                          ))
                      .toList(),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
