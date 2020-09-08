import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'package:shopapp/Models/showToast.dart';
import 'package:shopapp/Providers/Cart.dart';
import 'package:shopapp/Providers/Orders.dart';

showAlertDialog(BuildContext context) {
  final cartitemm = Provider.of<Cart>(context, listen: false);

  // set up the buttons
  Widget cancelButton = FlatButton(
    child: Text("Yes"),
    onPressed: () {
      cartitemm.removeALL();

      return showToast('Order Done Successfully !');
    },
  );
  Widget continueButton = FlatButton(
    child: Text("No"),
    onPressed: () {
      Navigator.of(context).pop();
    },
  );

  // set up the AlertDialog
  AlertDialog alert = AlertDialog(
    title: Text(
      "Ordering in process",
      style:
          TextStyle(fontStyle: FontStyle.italic, fontWeight: FontWeight.bold),
    ),
    content: Text(
      "You are going to order these items now , Are you sure you want to continue ?",
      style: TextStyle(
        fontStyle: FontStyle.italic,
      ),
      maxLines: 3,
    ),
    actions: [
      cancelButton,
      continueButton,
    ],
  );

  // show the dialog
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );
}
