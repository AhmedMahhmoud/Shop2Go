import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopapp/Models/showToast.dart';
import 'package:shopapp/Providers/products_provider.dart';
import 'package:shopapp/Screens/Edit_Screen.dart';

class ManageProductsWidg extends StatelessWidget {
  final String productName;
  final String productImageUrl;
  final String productID;
  ManageProductsWidg({this.productImageUrl, this.productName, this.productID});
  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: BeveledRectangleBorder(
        borderRadius: BorderRadius.circular(20.0),
      ),
      color: Colors.white54,
      child: Row(
        children: [
          CircleAvatar(
            radius: 26,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(30),
              child: Image(
                image: NetworkImage(productImageUrl),
              ),
            ),
          ),
          SizedBox(
            width: 10,
          ),
          Text(
            productName,
            style: TextStyle(
                fontWeight: FontWeight.w700,
                fontStyle: FontStyle.italic,
                letterSpacing: 1),
          ),
          Spacer(),
          IconButton(
            icon: Icon(
              Icons.edit,
              color: Colors.blue[700],
              size: 26,
            ),
            onPressed: () {
              Navigator.pushNamed(context, EditProductsScreen.pageroutes,
                  arguments: productID);
            },
          ),
          SizedBox(
            width: 4,
          ),
          IconButton(
            icon: Icon(Icons.restore_from_trash, size: 26),
            color: Colors.red[700],
            onPressed: () {
              return showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  backgroundColor: Colors.grey[100],
                  title: Text('Are you sure ?'),
                  content: Text(
                      'Do you want to remove this item from the products ?'),
                  actions: [
                    FlatButton(
                      child: Text('Yes'),
                      onPressed: () async {
                        await Provider.of<ProductsProvider>(context,
                                listen: false)
                            .deleteProduct(productID);
                        Navigator.of(context).pop(true);
                        showToast('Item removed !');
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
          ),
          SizedBox(
            width: 20,
          ),
        ],
      ),
    );
  }
}
