import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopapp/Models/AppDrawer.dart';
import 'package:shopapp/Models/GradientAppBar.dart';
import 'package:shopapp/Screens/Edit_Screen.dart';
import 'package:shopapp/Widgets/ManageProductsWig.dart';

import '../Providers/products_provider.dart';

class ManageProducts extends StatelessWidget {
  static final String pageroute = "manageroute";
  Future<void> refreshProductsOnline(BuildContext context) async {
    await Provider.of<ProductsProvider>(context, listen: false)
        .fetchProductsOnline(true);
  }

  @override
  Widget build(BuildContext context) {
    // final products = Provider.of<ProductsProvider>(context);
    return Container(
      decoration: BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: <Color>[Colors.red, Colors.blue])),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        drawer: AppDrawer(),
        appBar: AppBar(
          flexibleSpace: GradientAppBar(),
          title: Text(
            'Your Products',
            style: TextStyle(fontStyle: FontStyle.italic, letterSpacing: 2),
          ),
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 23),
              child: IconButton(
                icon: Icon(
                  Icons.add,
                  size: 28,
                ),
                onPressed: () {
                  Navigator.pushNamed(context, EditProductsScreen.pageroutes);
                },
              ),
            )
          ],
        ),
        body: FutureBuilder(
          future: refreshProductsOnline(context),
          builder: (context, snapshot) =>
              snapshot.connectionState == ConnectionState.waiting
                  ? Center(
                      child: CircularProgressIndicator(
                        backgroundColor: Colors.red[700],
                      ),
                    )
                  : RefreshIndicator(
                      onRefresh: () => refreshProductsOnline(context),
                      child: Consumer<ProductsProvider>(
                        builder: (context, products, child) => ListView.builder(
                          itemBuilder: (context, index) {
                            return ManageProductsWidg(
                              productImageUrl: products.items[index].imageUrl,
                              productName: products.items[index].title,
                              productID: products.items[index].id,
                            );
                          },
                          itemCount: products.items.length,
                        ),
                      ),
                    ),
        ),
      ),
    );
  }
}
