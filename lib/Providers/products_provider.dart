import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'products.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ProductsProvider with ChangeNotifier {
  List<Products> itemss = [
    // Products(
    //   id: 'p1',
    //   title: 'Red Shirt',
    //   desc: 'A red shirt - it is pretty red!',
    //   price: 29.99,
    //   imageUrl:
    //       'https://cdn.pixabay.com/photo/2016/10/02/22/17/red-t-shirt-1710578_1280.jpg',
    // ),
    // Products(
    //     id: 'p2',
    //     title: 'Trousers',
    //     desc: 'A nice pair of trousers.',
    //     price: 59.99,
    //     imageUrl:
    //         'https://www.dhresource.com/0x0/f2/albu/g6/M01/CE/C8/rBVaSFrLIp2ADRQbAAL7FqBvpGM522.jpg'),
    // Products(
    //     id: 'p3',
    //     title: 'Blue Dress',
    //     desc: 'An elegent dress. ',
    //     price: 86.99,
    //     imageUrl:
    //         'https://gloimg.drlcdn.com/L/pdm-product-pic/Clothing/2020/04/01/goods-img/1585781588767552869.jpg'),
    // Products(
    //     id: 'p4',
    //     title: 'Socks',
    //     desc: 'A comffortable socks ',
    //     price: 11.99,
    //     imageUrl:
    //         'https://i.pinimg.com/originals/87/61/63/876163835a774db0b94076bfbe031a80.jpg'),
    // Products(
    //     id: 'p5',
    //     title: 'Chimese',
    //     desc: 'Casual chimese for hangouts',
    //     price: 32.99,
    //     imageUrl:
    //         'https://ae01.alicdn.com/kf/HTB16fpoaFzsK1Rjy1Xbq6xOaFXaj/Summer-Style-Cowboy-Shirt-2019-New-Men-Clothing-Double-Pocket-Design-Short-Sleeves-Denim-Shirts-Fashion.jpg'),
    // Products(
    //     id: 'p6',
    //     title: 'Cute Dress',
    //     desc:
    //         'Cute Dress for Teens Girl Two Piece Set Bunny Prints Casual Cotton Dresses ',
    //     price: 63.99,
    //     imageUrl:
    //         'https://images-na.ssl-images-amazon.com/images/I/51760mKbrDL._AC_UL1000_.jpg')
  ];
  final String authToken;
  final String useriD;
  ProductsProvider(this.authToken, this.itemss, this.useriD);
  List<Products> get items {
    return itemss;
  }

  List<Products> get favourites {
    return itemss.where((element) => element.isFavourite).toList();
  }
  // void showFav() {
  //   showFavOnly = true;
  //   notifyListeners();
  // }

  // void showAll() {
  //   showFavOnly = false;
  //   notifyListeners();
  // }

  Products findById(String id) {
    return items.firstWhere((element) =>
        element.id == id); // law al condition da et722 hatli al item //
  }

  Future<void> updateProduct(String proid, Products u) async {
    final prodIndex = itemss.indexWhere((element) => element.id == proid);
    try {
      if (prodIndex >= 0) {
        final url =
            'https://shop2go-f94d9.firebaseio.com/products/$proid.json?auth=$authToken';
        await http.patch(url,
            body: json.encode({
              'Title': u.title,
              'Price': u.price,
              'Description': u.desc,
              'ImageUrl': u.imageUrl
            }));
        //MAKE SURE THAT THERE IS A FOUNDED ITEM
        itemss[prodIndex] = u;
        notifyListeners();
      }
    } catch (error) {
      throw error;
    }
  }

  Future<void> deleteProduct(String proid) async {
    final proIndex = itemss.indexWhere((element) => element.id == proid);
    final url =
        'https://shop2go-f94d9.firebaseio.com/products/$proid.json?auth=$authToken';
    await http.delete(url);
    itemss.removeAt(proIndex);
    notifyListeners();
  }

  Future<void> fetchProductsOnline([bool filterByuser = false]) async {
    final filterString =
        filterByuser ? 'orderBy="CreatorId"&equalTo="$useriD"' : '';
    var url =
        'https://shop2go-f94d9.firebaseio.com/products.json?auth=$authToken&$filterString';
    try {
      final response = await http.get(url);
      final decodedResponse = json.decode(response.body);
      if (decodedResponse == Null) {
        return;
      }
      url =
          'https://shop2go-f94d9.firebaseio.com/userFavourites/$useriD.json?auth=$authToken';

      final favouriteResponse = await http.get(url);
      final favouriteData = jsonDecode(favouriteResponse.body);

      final List<Products> loadedProducts = [];
      decodedResponse.forEach((key, value) {
        loadedProducts.add(Products(
            id: key,
            desc: value['Description'],
            imageUrl: value['ImageUrl'],
            price: value['Price'],
            title: value['Title'],
            isFavourite: favouriteData == null
                ? false
                : favouriteData[key] ??
                    false)); //?? mean if it is null assign the value after the ? ? to it
      });
      itemss = loadedProducts;
      notifyListeners();
      // print(json.decode(response.body));
    } catch (error) {
      throw error;
    }
  }

  Future<void> addProduct(Products x) async {
    final url =
        'https://shop2go-f94d9.firebaseio.com/products.json?auth=$authToken';
    try {
      final response = await http.post(url,
          body: json.encode({
            'Title': x.title,
            'Description': x.desc,
            'ImageUrl': x.imageUrl,
            'Price': x.price,
            "CreatorId": useriD
          }));

      final newProduct = Products(
        desc: x.desc,
        id: json.decode(response.body)['name'],
        imageUrl: x.imageUrl,
        price: x.price,
        title: x.title,
      );

      itemss.add(newProduct);
      //itemss.insert(0, newProduct); //at the start of index
      notifyListeners();
    } catch (error) {
      print(error);
      throw error;
    }
  }
}
