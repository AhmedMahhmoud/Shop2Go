import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:shopapp/Models/HttpException.dart';
import 'package:shopapp/Providers/auth.dart';

import 'package:shopapp/Screens/SignUp.dart';

class Login extends StatefulWidget {
  static final String loginid = "loginid";

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  bool isvisiable = true;
  bool togglevisiability() {
    setState(() {
      isvisiable = !isvisiable;
    });
    return isvisiable;
  }

  final formKey = GlobalKey<FormState>();
  var isLoading = false;
  Map<String, String> login_auth = {
    'email': '',
    'password': '',
  };
  void showErrorDiaglog(String message) {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: Text("Error Occured !"),
              content: Text(message),
              actions: [
                FlatButton(
                  child: Text('Okay'),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                )
              ],
            ));
  }

  Future<void> saveForm() async {
    if (!formKey.currentState.validate()) {
      return;
    }
    formKey.currentState.save();
    setState(() {
      isLoading = true;
    });
    try {
      await Provider.of<UserInfoAuth>(context, listen: false)
          .signin(login_auth['email'], login_auth['password']);
    } on HttpException catch (error) {
      var errorMessage = 'Authentication failed';
      if (error.toString().contains('EMAIL_EXISTS')) {
        errorMessage = 'This email address is already in use.';
      } else if (error.toString().contains('INVALID_EMAIL')) {
        errorMessage = 'This is not a valid email address';
      } else if (error.toString().contains('WEAK_PASSWORD')) {
        errorMessage = 'This password is too weak.';
      } else if (error.toString().contains('EMAIL_NOT_FOUND')) {
        errorMessage = 'Could not find a user with that email.';
      } else if (error.toString().contains('INVALID_PASSWORD')) {
        errorMessage = 'Invalid password.';
      }
      showErrorDiaglog(errorMessage);
    } catch (error) {
      const errorMessage =
          'Could not authenticate you. Please try again later.';
      showErrorDiaglog(errorMessage);
    }
    setState(() {
      isLoading = false;
    });
    // Provider.of<UserInfoAuth>(context, listen: false)
    //     .sendResetPassword("manarahmed2262@gmail.com");
    //Navigator.pushReplacementNamed(context, ProductsHomePage.homeid);
  }

  @override
  Widget build(BuildContext context) {
    final Size deviceSiae = MediaQuery.of(context).size;
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.red[700].withOpacity(1), Colors.blue],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Scaffold(
        //resizeToAvoidBottomPadding: false,
        backgroundColor: Colors.transparent,
        body: SingleChildScrollView(
          child: Container(
            width: deviceSiae.width,
            height: deviceSiae.height,
            child: Stack(
              children: [
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: Image(
                    image: AssetImage('lib/assets/images/login_bottom.png'),
                    width: deviceSiae.width * 0.3,
                  ),
                ),
                Positioned(
                  top: 0,
                  left: 0,
                  child: Image(
                    image: AssetImage('lib/assets/images/main_top.png'),
                    width: deviceSiae.width * 0.3,
                  ),
                ),
                Form(
                  key: formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SvgPicture.asset(
                        'lib/assets/icons/login.svg',
                        height: deviceSiae.height * 0.24,
                      ),
                      Divider(),
                      Card(
                          margin: EdgeInsets.all(10),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          color: Colors.white.withOpacity(0.8),
                          child: Padding(
                            padding: const EdgeInsets.only(left: 10),
                            child: TextFormField(
                              validator: (value) {
                                if (!value.contains('@')) {
                                  return 'Invalid Email !';
                                }
                              },
                              onSaved: (newValue) {
                                login_auth['email'] = newValue;
                              },
                              decoration: InputDecoration(
                                  border: InputBorder.none,
                                  icon: Icon(
                                    Icons.person,
                                    color: Colors.red,
                                    size: 23,
                                  ),
                                  hintText: "Your Email",
                                  hintStyle: TextStyle(
                                    color: Colors.blue[700],
                                    letterSpacing: 3,
                                    fontSize: 14,
                                    fontStyle: FontStyle.italic,
                                  )),
                            ),
                          )),
                      Card(
                          margin: EdgeInsets.all(10),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          color: Colors.white.withOpacity(0.8),
                          child: Padding(
                            padding: const EdgeInsets.only(left: 10),
                            child: TextFormField(
                              validator: (value) {
                                if (value.length < 6) {
                                  return 'Too short password !';
                                }
                              },
                              onSaved: (newValue) {
                                login_auth['password'] = newValue;
                              },
                              obscureText: isvisiable,
                              decoration: InputDecoration(
                                  border: InputBorder.none,
                                  icon: Icon(
                                    Icons.lock,
                                    color: Colors.red,
                                    size: 23,
                                  ),
                                  hintText: "Your Password",
                                  suffixIcon: IconButton(
                                    color: Colors.red,
                                    onPressed: () {
                                      togglevisiability();
                                    },
                                    icon: Icon(Icons.visibility),
                                  ),
                                  hintStyle: TextStyle(
                                    color: Colors.blue[700],
                                    letterSpacing: 3,
                                    fontSize: 14,
                                    fontStyle: FontStyle.italic,
                                  )),
                            ),
                          )),
                      isLoading
                          ? CircularProgressIndicator(
                              backgroundColor: Colors.red,
                            )
                          : ButtonLR(
                              buttonname: "LOGIN",
                              textcolor: Colors.white,
                              color: Colors.purple[700],
                              pressed: () {
                                saveForm();
                              },
                              deviceSize: deviceSiae,
                            ),
                      SizedBox(
                        height: 20,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Don\'t have an account ? ',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                            ),
                          ),
                          InkWell(
                            onTap: () =>
                                Navigator.pushNamed(context, SignUp.signup),
                            child: Text(
                              'Sign Up',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 12,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
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
