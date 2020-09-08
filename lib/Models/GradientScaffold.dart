import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class GradientScaffold extends StatelessWidget {
  final Widget child;
  GradientScaffold(this.child);
  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: <Color>[Colors.red, Colors.blue])),
        child: child);
  }
}
