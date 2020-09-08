import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopapp/Models/GradientAppBar.dart';

import 'package:shopapp/Models/showToast.dart';
import 'package:shopapp/Providers/Orders.dart';
import '../Providers/Cart.dart';
import '../Widgets/Cartitem.dart';

class CartScreen extends StatefulWidget {
  static final String cartscreen = "cartscreen";
  @override
  _CartScreenState createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  @override
  var isloading = false;

  Widget build(BuildContext context) {
    final cartitem = Provider.of<Cart>(context);
    final orderitem = Provider.of<Orders>(context);
    final GlobalKey<ScaffoldState> _scaffoldKey =
        new GlobalKey<ScaffoldState>();
    final cartitemm = Provider.of<Cart>(context, listen: false);
    void showInSnackBar(String value, String action) {
      _scaffoldKey.currentState.showSnackBar(new SnackBar(
          action: SnackBarAction(
            label: action,
            onPressed: () {
              Navigator.pop(context);
            },
            textColor: Colors.white,
          ),
          content: new Text(value,
              style: TextStyle(
                letterSpacing: 1,
                fontStyle: FontStyle.italic,
              ))));
    }

    return Container(
      decoration: BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: <Color>[Colors.red, Colors.blue])),
      child: Scaffold(
        key: _scaffoldKey,
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          flexibleSpace: GradientAppBar(),
          centerTitle: true,
          title: Text(
            'My Shopping Cart ',
            style: TextStyle(fontStyle: FontStyle.italic),
          ),
        ),
        body: Column(children: [
          Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15.0),
            ),
            color: Colors.white54,
            elevation: 7,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(
                  width: 20,
                ),
                Text(
                  'Total',
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 1),
                ),
                Spacer(),
                Chip(
                  elevation: 4,
                  label: Text(
                    '\$ ${cartitem.CalcTotal.toStringAsFixed(2)}',
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontStyle: FontStyle.italic,
                        letterSpacing: 1),
                  ),
                  backgroundColor: Colors.red[400],
                ),
                isloading
                    ? CircularProgressIndicator()
                    : FlatButton(
                        child: Text(
                          'ORDER NOW',
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              letterSpacing: 2,
                              fontStyle: FontStyle.italic),
                        ),
                        onPressed: () async {
                          // showToast();

                          cartitem.isempty()
                              ? showInSnackBar(
                                  'Please add items to the cart first ', "ADD")
                              : showDialog(
                                  context: context,
                                  builder: (context) => AlertDialog(
                                    title: Text(
                                      "Order in process",
                                      style: TextStyle(
                                          fontStyle: FontStyle.italic,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    content: Text(
                                      "You are going to order these items now , Are you sure you want to continue ?",
                                      style: TextStyle(
                                        fontStyle: FontStyle.italic,
                                      ),
                                      maxLines: 3,
                                    ),
                                    actions: [
                                      FlatButton(
                                        child: Text("YES"),
                                        onPressed: () {
                                          Navigator.pop(context);
                                          setState(() {
                                            isloading = true;
                                          });
                                          orderitem
                                              .addOrder(
                                                  cartitemm.items.values
                                                      .toList(),
                                                  cartitemm.CalcTotal)
                                              .then((value) =>
                                                  cartitemm.removeALL())
                                              .then((value) => setState(() {
                                                    isloading = false;
                                                  }))
                                              .then((value) => showToast(
                                                  "Order done sucessfully !"));
                                        },
                                      ),
                                      FlatButton(
                                        child: Text("NO"),
                                        onPressed: () {
                                          Navigator.pop(context);
                                        },
                                      )
                                    ],
                                  ),
                                );
                          //
                          // Navigator.of(context).pop();

                          // cartitem.removeALL();
                        },
                        textColor: Colors.red[700],
                        highlightColor: Colors.blue,
                      )
              ],
            ),
          ),
          isloading
              ? Center(
                  child: CircularProgressIndicator(
                    backgroundColor: Colors.red,
                  ),
                )
              : Expanded(
                  child: ListView.builder(
                    itemBuilder: (context, index) => CartWidget(
                      productID: cartitem.items.keys.toList()[index],
                      id: cartitem.items.values.toList()[index].id,
                      imageUrl: cartitem.items.values.toList()[index].imageUrl,
                      price: cartitem.items.values.toList()[index].price,
                      quantity: cartitem.items.values.toList()[index].quantity,
                      title: cartitem.items.values.toList()[index].title,
                    ),
                    itemCount: cartitem.items.length,
                  ),
                )
        ]),
      ),
    );
  }
}
