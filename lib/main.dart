import 'package:flutter/material.dart';
import 'package:shopapp/Providers/Cart.dart';
import 'package:shopapp/Providers/Orders.dart';
import 'package:shopapp/Screens/16.2%20splash_screen.dart';
import 'package:shopapp/Screens/AuthenticationScreen.dart';
import 'package:shopapp/Screens/CartScreen.dart';
import 'package:shopapp/Screens/Edit_Screen.dart';
import 'package:shopapp/Screens/Login.dart';
import 'package:shopapp/Screens/ManageProducts.dart';
import 'package:shopapp/Screens/ProductsDetailsPage.dart';
import 'package:shopapp/Screens/SignUp.dart';
import 'package:shopapp/Screens/ordersScreen.dart';

import 'Providers/auth.dart';
import 'Screens/Login.dart';
import './Providers/products_provider.dart';
import 'package:provider/provider.dart';

import 'Screens/Products_HomePage.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider(
            create: (context) => UserInfoAuth(),
          ),
          ChangeNotifierProxyProvider<UserInfoAuth, ProductsProvider>(
            create: (context) => ProductsProvider(null, [], null),
            update: (context, value, previous) => ProductsProvider(value.token,
                previous == null ? [] : previous.items, value.userId),
          ),
          ChangeNotifierProvider(
            create: (context) => Cart(),
          ),
          ChangeNotifierProxyProvider<UserInfoAuth, Orders>(
            create: (context) => Orders(null, [], null),
            update: (context, value, previous) => Orders(value.token,
                previous == null ? [] : previous.getOrders, value.userID),
          ),
        ],
        child: Consumer<UserInfoAuth>(
          builder: (ctx, value, _) => MaterialApp(
            key: UniqueKey(),
            debugShowCheckedModeBanner: false,
            title: "Shop 2 Go",
            home: value.isAuth
                ? ProductsHomePage()
                : FutureBuilder(
                    future: value.truAutoLogin(),
                    builder: (ctx, snapshot) =>
                        snapshot.connectionState == ConnectionState.waiting
                            ? SplashScreen()
                            : AuthScreen(),
                  ),
            routes: {
              ProductsHomePage.homeid: (context) => ProductsHomePage(),
              ProductDetails.pageroute: (context) => ProductDetails(),
              OrdersScreen.routeName: (context) => OrdersScreen(),
              ManageProducts.pageroute: (context) => ManageProducts(),
              AuthScreen.id: (context) => AuthScreen(),
              Login.loginid: (context) => Login(),
              SignUp.signup: (context) => SignUp(),
              EditProductsScreen.pageroutes: (context) => EditProductsScreen(),
              CartScreen.cartscreen: (context) => CartScreen(),
            },
          ),
        ));
  }
}
