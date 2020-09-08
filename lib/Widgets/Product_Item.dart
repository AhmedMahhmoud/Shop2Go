import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopapp/Models/showToast.dart';
import 'package:shopapp/Providers/auth.dart';
import 'package:shopapp/Providers/products.dart';
import 'package:shopapp/Screens/ProductsDetailsPage.dart';
import 'package:auto_size_text/auto_size_text.dart';
import '../Providers/Cart.dart';

class ProductItem extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final loadedproduct = Provider.of<Products>(context);
    final userIDAuth = Provider.of<UserInfoAuth>(context, listen: false).userId;
    final loadedcart = Provider.of<Cart>(context, listen: false);
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: GridTile(
        footer: GridTileBar(
          leading: IconButton(
            onPressed: () {
              loadedproduct.reverseFav(
                  Provider.of<UserInfoAuth>(context, listen: false).token,
                  userIDAuth);
            },
            icon: Icon(
              loadedproduct.isFavourite
                  ? Icons.favorite
                  : Icons.favorite_border,
              size: 23,
              color: Colors.red[700],
            ),
          ),
          trailing: IconButton(
            onPressed: () {
              loadedcart.addItem(loadedproduct.id, loadedproduct.price,
                  loadedproduct.title, loadedproduct.imageUrl);
              showToast('Item added to cart');
            },
            icon: Icon(
              Icons.shopping_cart,
              size: 23,
              color: Colors.blue,
            ),
          ),
          title: FittedBox(
              child: AutoSizeText(
            loadedproduct.title,
            style: TextStyle(
                fontStyle: FontStyle.italic, letterSpacing: 1, fontSize: 2),
          )),
          backgroundColor: Colors.black87,
        ),
        child: GestureDetector(
          onTap: () {
            Navigator.push(context, MaterialPageRoute(
              builder: (context) {
                return ProductDetails(
                  id: loadedproduct.id,
                );
              },
            ));
          },
          child: Hero(
            tag: loadedproduct.id,
            child: Image.network(
              loadedproduct.imageUrl,
              fit: BoxFit.fill,
            ),
          ),
        ),
      ),
    );
  }
}
