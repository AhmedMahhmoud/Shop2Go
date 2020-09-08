import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopapp/Providers/auth.dart';

import 'package:shopapp/Screens/ManageProducts.dart';

import '../Screens/ordersScreen.dart';

class AppDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Container(
        decoration: BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: <Color>[Colors.red, Colors.blue])),
        child: Column(
          children: <Widget>[
            Container(
              child: AppBar(
                elevation: 0,
                title: Text(
                  'Welcome Back !',
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 2,
                      fontStyle: FontStyle.italic),
                ),
                automaticallyImplyLeading: false,
                backgroundColor: Colors.transparent,
              ),
            ),
            Divider(
              color: Colors.black,
              thickness: 0.5,
            ),
            buildPadding(context, '/', 'Shop', Colors.red[700], Icons.shop),
            SizedBox(
              height: 20,
            ),
            buildPadding(context, OrdersScreen.routeName, 'Orders',
                Colors.blue[500], Icons.attach_money),
            SizedBox(
              height: 20,
            ),
            buildPadding(context, ManageProducts.pageroute, "Manage Products",
                Colors.black, Icons.enhanced_encryption),
            SizedBox(
              height: 20,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 10),
              child: Row(
                children: [
                  Icon(
                    Icons.exit_to_app,
                    color: Colors.purple[700],
                    size: 30,
                  ),
                  SizedBox(
                    width: 20,
                  ),
                  InkWell(
                      onTap: () {
                        Navigator.pop(context);
                        Provider.of<UserInfoAuth>(context, listen: false)
                            .logout(); //OrdersScreen.routeName);
                      },
                      child: Text(
                        "Logout",
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 2,
                            fontStyle: FontStyle.italic),
                      )),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Padding buildPadding(BuildContext context, String pageroute, String title,
      Color color, IconData iconData) {
    return Padding(
      padding: const EdgeInsets.only(left: 10),
      child: Row(
        children: [
          Icon(
            iconData,
            color: color,
            size: 30,
          ),
          SizedBox(
            width: 20,
          ),
          InkWell(
              onTap: () {
                Navigator.of(context)
                    .pushReplacementNamed(pageroute); //OrdersScreen.routeName);
              },
              child: Text(
                title,
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 2,
                    fontStyle: FontStyle.italic),
              )),
        ],
      ),
    );
  }
}
