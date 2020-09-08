import 'package:flutter/material.dart';

class GradientAppBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: <Color>[Colors.red, Colors.blue]),
          boxShadow: [
            new BoxShadow(
              color: Colors.red[200],
              blurRadius: 10.0,
              spreadRadius: 2.0,
            )
          ]),
    );
  }
}
