import 'package:flutter/material.dart';
import 'package:shopapp/Models/GradientAppBar.dart';
import 'package:shopapp/Models/showToast.dart';
import 'package:shopapp/Providers/Cart.dart';

import '../Providers/products_provider.dart';
import 'package:provider/provider.dart';

class ProductDetails extends StatelessWidget {
  static final String pageroute = "page";
  final String id;
  ProductDetails({this.id});
  @override
  Widget build(BuildContext context) {
    final loadedcart = Provider.of<Cart>(context, listen: false);
    final loadedProduct = Provider.of<ProductsProvider>(context, listen: false)
        .findById(id); // law al condition da et722 hatli al item //
    return Container(
      decoration: BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: <Color>[Colors.red, Colors.blue])),
      child: Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            title: Text(
              loadedProduct.title,
              style: TextStyle(fontStyle: FontStyle.italic, letterSpacing: 4),
            ),
            flexibleSpace: GradientAppBar(),
          ),
          body: Column(
            children: <Widget>[
              Container(
                height: 250,
                width: double.infinity,
                child: Hero(
                  tag: id,
                  child: Image.network(
                    loadedProduct.imageUrl,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                loadedProduct.desc,
                textAlign: TextAlign.center,
                softWrap: true,
                style: TextStyle(
                    fontSize: 20,
                    color: Colors.white,
                    fontStyle: FontStyle.italic),
              ),
              SizedBox(
                height: 10,
              ),
              Text('\$ ${loadedProduct.price}',
                  style: TextStyle(
                      fontSize: 20,
                      color: Colors.grey,
                      fontStyle: FontStyle.italic,
                      fontWeight: FontWeight.bold)),
              Spacer(),
              Container(
                padding: EdgeInsets.only(bottom: 5),
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.width * 0.1,
                child: FlatButton(
                  color: Colors.red[700],
                  child: Text(
                    "ADD TO CART ",
                    style: TextStyle(
                        fontWeight: FontWeight.bold, letterSpacing: 1),
                  ),
                  onPressed: () {
                    loadedcart.addItem(loadedProduct.id, loadedProduct.price,
                        loadedProduct.title, loadedProduct.imageUrl);
                    Navigator.pop(context);
                    showToast('Item added to cart');
                  },
                ),
              )
            ],
          )),
    );
  }
}
