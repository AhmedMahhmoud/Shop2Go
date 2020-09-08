import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:shopapp/Models/GradientAppBar.dart';
import 'package:shopapp/Providers/products.dart';
import 'package:shopapp/Providers/products_provider.dart';

import 'ProductsDetailsPage.dart';

class SearchScreen extends StatefulWidget {
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  List<Products> products = List();
  List<Products> filiteredProducts = List();
  @override
  var isEmmmpty = true;
  void initState() {
    // TODO: implement initState
    products = Provider.of<ProductsProvider>(context, listen: false).items;

    filiteredProducts = products;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIOverlays([]);

    return Container(
        decoration: BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: <Color>[Colors.red, Colors.blue])),
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: Scaffold(
            backgroundColor: Colors.transparent,
            appBar: AppBar(
              flexibleSpace: GradientAppBar(),
              title: Text(
                "Search for a product by name ",
                style: TextStyle(fontSize: 20, fontStyle: FontStyle.italic),
                textAlign: TextAlign.start,
              ),
            ),
            body: SingleChildScrollView(
              child: Column(
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width,
                    height: 35,
                    decoration: BoxDecoration(color: Colors.white),
                    child: TextField(
                      style: TextStyle(
                          color: Colors.black, fontSize: 20, letterSpacing: 1),
                      textAlign: TextAlign.start,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        prefixIcon: Icon(Icons.search),
                      ),
                      onChanged: (value) {
                        setState(() {
                          filiteredProducts = products
                              .where((element) =>
                                  (element.title
                                      .toLowerCase()
                                      .contains(value)) ||
                                  element.title.toUpperCase().contains(value))
                              .toList();
                          print(value);
                          isEmmmpty = false;
                          if (value == "") {
                            isEmmmpty = true;
                          }
                        });
                      },
                    ),
                  ),
                  ListView.builder(
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      return isEmmmpty
                          ? null
                          : Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                InkWell(
                                  onTap: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => ProductDetails(
                                            id: filiteredProducts[index].id,
                                          ),
                                        ));
                                  },
                                  child: Card(
                                    elevation: 2,
                                    shape: ContinuousRectangleBorder(
                                      borderRadius: BorderRadius.circular(20.0),
                                    ),
                                    color: Colors.white54,
                                    child: Row(
                                      children: [
                                        CircleAvatar(
                                          backgroundColor: Colors.white,
                                          child: ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(20),
                                            child: Image(
                                              image: NetworkImage(
                                                  filiteredProducts[index]
                                                      .imageUrl),
                                            ),
                                          ),
                                        ),
                                        SizedBox(width: 10),
                                        Text(
                                          filiteredProducts[index].title,
                                          style: TextStyle(
                                            fontWeight: FontWeight.w600,
                                            letterSpacing: 1,
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                )
                              ],
                            );
                    },
                    itemCount: filiteredProducts.length,
                  ),
                ],
              ),
            )));
  }
}
