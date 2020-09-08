import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopapp/Models/AppDrawer.dart';
import 'package:shopapp/Models/GradientAppBar.dart';
import 'package:shopapp/Providers/Orders.dart';
import '../Widgets/order_item.dart';

class OrdersScreen extends StatelessWidget {
  static const routeName = '/orders';

  Future<void> refreshOrdersOnline(BuildContext context) async {
    await Provider.of<Orders>(context, listen: false).fetchOrdersOnline();
  }

  @override
  Widget build(BuildContext context) {
    //final orderData = Provider.of<Orders>(context);
    return Container(
      decoration: BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: <Color>[Colors.red, Colors.blue])),
      child: Scaffold(
        appBar: AppBar(
          title: Text('Your Orders'),
          flexibleSpace: GradientAppBar(),
        ),
        drawer: AppDrawer(),
        backgroundColor: Colors.transparent,
        body: RefreshIndicator(
          onRefresh: () => refreshOrdersOnline(context),
          child: FutureBuilder(
              future: refreshOrdersOnline(context),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting)
                  return Center(child: CircularProgressIndicator());
                else {
                  if (snapshot.error != Null)
                    return Consumer<Orders>(
                        builder: (context, orderData, child) =>
                            ListView.builder(
                              itemCount: orderData.orders.length,
                              itemBuilder: (ctx, i) =>
                                  OrderItemWidg(orderData.orders[i]),
                            ));
                }
              }),
        ),
      ),
    );
  }
}
