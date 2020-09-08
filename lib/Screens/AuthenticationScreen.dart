import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_svg/svg.dart';
import 'package:shopapp/Screens/Login.dart';
import 'package:shopapp/Screens/SignUp.dart';

class AuthScreen extends StatelessWidget {
  static final String id = "authid";
  @override
  Widget build(BuildContext context) {
    final Size deviceSize = MediaQuery.of(context).size;
    SystemChrome.setEnabledSystemUIOverlays([]);
    return Scaffold(
      body: Container(
        //  Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.red[700].withOpacity(0.7), Colors.blue],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),

        width: deviceSize.width,
        height: deviceSize.height,
        child: Stack(
          alignment: Alignment.center,
          children: [
            Positioned(
              top: 0,
              left: 0,
              child: Image(
                image: AssetImage('lib/assets/images/main_top.png'),
                width: deviceSize.width * 0.3,
              ),
            ),
            Positioned(
              bottom: 0,
              left: 0,
              child: Image(
                image: AssetImage('lib/assets/images/main_bottom.png'),
                width: deviceSize.width * 0.25,
              ),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Shop 2 Go',
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      letterSpacing: 4,
                      fontSize: 20,
                      fontStyle: FontStyle.italic),
                ),
                Divider(),
                SvgPicture.asset(
                  'lib/assets/icons/chat.svg',
                  height: deviceSize.height * 0.4,
                ),
                Divider(),
                ButtonLR(
                  deviceSize: deviceSize,
                  buttonname: "LOGIN",
                  color: Colors.purple,
                  textcolor: Colors.white,
                  pressed: () => Navigator.pushNamed(context, Login.loginid),
                ),
                Divider(),
                ButtonLR(
                    deviceSize: deviceSize,
                    buttonname: "SIGNUP",
                    textcolor: Colors.white,
                    pressed: () => Navigator.pushNamed(context, SignUp.signup),
                    color: Colors.grey),
              ],
            )
          ],
        ),
      ),
    );
  }
}

class ButtonLR extends StatelessWidget {
  final String buttonname;
  final Function pressed;
  final Color color, textcolor;
  const ButtonLR({
    this.color,
    this.pressed(),
    this.buttonname,
    this.textcolor,
    Key key,
    @required this.deviceSize,
  }) : super(key: key);

  final Size deviceSize;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: deviceSize.width * 0.8,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: color,
          gradient: LinearGradient(
            colors: [color, textcolor],
            begin: Alignment.center,
            end: Alignment.bottomLeft,
          )),
      child: FlatButton(
          onPressed: pressed,
          child: Center(
            child: Text(
              buttonname,
              style: TextStyle(color: textcolor, letterSpacing: 1),
            ),
          )),
    );
  }
}
//  Container(
//           decoration: BoxDecoration(
//             gradient: LinearGradient(
//               colors: [Colors.red[700].withOpacity(0.7), Colors.blue],
//               begin: Alignment.topLeft,
//               end: Alignment.bottomRight,
//             ),
//           ),
//         ),
