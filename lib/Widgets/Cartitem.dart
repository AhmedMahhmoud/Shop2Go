import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopapp/Providers/Cart.dart';

class CartWidget extends StatelessWidget {
  final String id;
  final String title;
  final String imageUrl;
  final double price;
  final int quantity;
  final String productID;
  CartWidget(
      {this.id,
      this.title,
      this.imageUrl,
      this.price,
      this.quantity,
      this.productID});
  @override
  Widget build(BuildContext context) {
    final cartaccess = Provider.of<Cart>(context);
    return Dismissible(
      confirmDismiss: (direction) {
        return showDialog(
          context: context,
          builder: (context) => AlertDialog(
            backgroundColor: Colors.grey[100],
            title: Text('Are you sure ?'),
            content: Text('Do you want to remove this item from the cart ?'),
            actions: [
              FlatButton(
                child: Text('Yes'),
                onPressed: () {
                  Navigator.of(context).pop(true);
                },
              ),
              FlatButton(
                child: Text('No'),
                onPressed: () {
                  Navigator.of(context).pop(false);
                },
              ),
            ],
          ),
        );
      },
      key: ValueKey(id),
      onDismissed: (direction) {
        cartaccess.removeItem(productID);
      },
      direction: DismissDirection.endToStart,
      background: Container(
        color: Colors.red[700],
        padding: EdgeInsets.only(right: 20),
        child: Icon(
          Icons.delete,
          color: Colors.white,
          size: 40,
        ),
        alignment: Alignment.centerRight,
      ),
      child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.0),
          ),
          elevation: 4,
          color: Colors.white54,
          child: Padding(
            padding: EdgeInsets.all(2),
            child: ListTile(
              leading: CircleAvatar(
                backgroundImage: NetworkImage(imageUrl),
                radius: 26,
              ),
              title: Text(
                title,
                style: TextStyle(
                    color: Colors.red[700],
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    fontStyle: FontStyle.italic),
              ),
              subtitle: Row(
                children: <Widget>[
                  Text(
                    'Total : \$${(price * quantity)}',
                    style: TextStyle(
                        color: Colors.blue[700],
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        fontStyle: FontStyle.italic),
                  ),
                ],
              ),
              trailing: Text(
                '$quantity x',
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    fontStyle: FontStyle.italic),
              ),
            ),
          )),
    );
  }
}
