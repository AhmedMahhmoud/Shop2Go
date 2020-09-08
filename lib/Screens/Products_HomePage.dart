import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopapp/Models/AppDrawer.dart';
import 'package:shopapp/Models/GradientAppBar.dart';
import 'package:shopapp/Providers/Cart.dart';
import 'package:shopapp/Screens/SearchScreen.dart';
import '../Providers/products_provider.dart';
import 'package:shopapp/Screens/CartScreen.dart';
import 'package:shopapp/Widgets/Gridview.dart';
import "../Widgets/badge.dart";

enum FliteringOptions {
  Favs,
  All,
}

class ProductsHomePage extends StatefulWidget {
  static final String homeid = "homescreen";
  @override
  _ProductsHomePageState createState() => _ProductsHomePageState();
}

class _ProductsHomePageState extends State<ProductsHomePage> {
  @override
  var isLoading = false;
  void initState() {
    print("ana d5lt");
    isLoading = true;
    // TODO: implement initState
    Provider.of<ProductsProvider>(context, listen: false)
        .fetchProductsOnline(false)
        .then((value) {
      setState(() {
        isLoading = false;
      });
    });
    super.initState();
  }

  int index = 0;
  var showonlyFav = false;
  @override
  Widget build(BuildContext context) {
    Size deviceSize = MediaQuery.of(context).size;
    //final cartno = Provider.of<Cart>(context); try to use consumer now
    return Container(
        decoration: BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: <Color>[Colors.red, Colors.blue])),
        child: Scaffold(
          bottomNavigationBar: Container(
            height: deviceSize.height * 0.094,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.red[700].withOpacity(1), Colors.blue[700]],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: BottomNavigationBar(
              unselectedFontSize: 10,
              selectedFontSize: 14,
              backgroundColor: Colors.transparent,
              currentIndex: index,
              items: [
                BottomNavigationBarItem(
                    backgroundColor: Colors.red,
                    icon: InkWell(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => SearchScreen(),
                            ));
                      },
                      child: Icon(
                        Icons.search,
                      ),
                    ),
                    title: Text("Search")),
                BottomNavigationBarItem(
                    backgroundColor: Colors.blue,
                    icon: InkWell(
                        onTap: () =>
                            Navigator.pushNamed(context, CartScreen.cartscreen),
                        child: Icon(Icons.shopping_basket)),
                    title: Text("MyCart")),
              ],
              onTap: (count) {
                setState(() {
                  index = count;
                });
              },
            ),
          ),
          drawer: AppDrawer(),
          backgroundColor: Colors.transparent,
          appBar: AppBar(
              flexibleSpace: GradientAppBar(),
              centerTitle: true,
              title: Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 50),
                    child: Text(
                      "Shop 2 Go",
                      style: TextStyle(
                          fontStyle: FontStyle.italic, letterSpacing: 2),
                    ),
                  ),
                  Spacer(),
                  PopupMenuButton(
                    elevation: 2,
                    color: Colors.grey[200],
                    onSelected: (value) {
                      if (value == FliteringOptions.Favs) {
                        //dosomething
                        setState(() {
                          showonlyFav = true;
                        });
                      } else {
                        //do something
                        setState(() {
                          showonlyFav = false;
                        });
                      }
                    },
                    icon: Icon(Icons.more_horiz),
                    itemBuilder: (context) => [
                      PopupMenuItem(
                        child: Text('Only Favourites'),
                        value: FliteringOptions.Favs,
                      ),
                      PopupMenuItem(
                        child: Text('Show All'),
                        value: FliteringOptions.All,
                      )
                    ],
                  ),
                  Consumer<Cart>(
                    builder: (context, cart, ch) => Badge(
                      child: ch,
                      value: cart.itemsCount.toString(),
                      color: Colors.red,
                    ),
                    child: IconButton(
                      icon: Icon(
                        Icons.shopping_cart,
                        size: 25,
                      ),
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => CartScreen(),
                            ));
                      },
                    ),
                  )
                ],
              )),
          body: isLoading
              ? Center(
                  child: CircularProgressIndicator(
                    backgroundColor: Colors.blue,
                  ),
                )
              : ProductsGrid(showonlyFav),
        ));
  }
}
