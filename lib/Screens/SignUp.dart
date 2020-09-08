import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:shopapp/Models/HttpException.dart';
import 'package:shopapp/Models/showToast.dart';
import 'package:shopapp/Providers/auth.dart';
import 'package:shopapp/Screens/Login.dart';

class SignUp extends StatefulWidget {
  static final String signup = "signup";

  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final passwordController = TextEditingController();
  final formkey = GlobalKey<FormState>();
  var isLoading = false;
  Map<String, String> auth_map = {
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
    if (!formkey.currentState.validate()) {
      return;
    }

    formkey.currentState.save();
    setState(() {
      isLoading = true;
    });
    try {
      await Provider.of<UserInfoAuth>(context, listen: false)
          .signup(auth_map['email'], auth_map['password']);
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
      const errorMessage = "Failed to authenticate";
      showErrorDiaglog(errorMessage);
    }

    setState(() {
      isLoading = false;
    });
    Navigator.pushReplacementNamed(context, Login.loginid);
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
                  top: 0,
                  left: 0,
                  child: Image(
                    image: AssetImage('lib/assets/images/signup_top.png'),
                    width: deviceSiae.width * 0.3,
                  ),
                ),
                Positioned(
                  bottom: 0,
                  left: 0,
                  child: Image(
                    image: AssetImage('lib/assets/images/main_bottom.png'),
                    width: deviceSiae.width * 0.2,
                  ),
                ),
                Form(
                  key: formkey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SvgPicture.asset(
                        'lib/assets/icons/signup.svg',
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
                              keyboardType: TextInputType.emailAddress,
                              validator: (value) {
                                if (value.isEmpty || !value.contains('@')) {
                                  return 'Invalid Email';
                                }
                              },
                              onSaved: (newValue) {
                                auth_map['email'] = newValue;
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
                                if (value.length < 6 || value.isEmpty) {
                                  return 'Password is too short !';
                                }
                              },
                              onSaved: (newValue) {
                                auth_map['password'] = newValue;
                              },
                              controller: passwordController,
                              obscureText: true,
                              decoration: InputDecoration(
                                  border: InputBorder.none,
                                  icon: Icon(
                                    Icons.lock,
                                    color: Colors.red,
                                    size: 23,
                                  ),
                                  hintText: "Your Password",
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
                                if (passwordController.text != value) {
                                  return 'Password do not match !';
                                }
                              },
                              obscureText: true,
                              decoration: InputDecoration(
                                  border: InputBorder.none,
                                  icon: Icon(
                                    Icons.lock,
                                    color: Colors.red,
                                    size: 23,
                                  ),
                                  hintText: "Confirm Password",
                                  hintStyle: TextStyle(
                                    color: Colors.blue[700],
                                    letterSpacing: 3,
                                    fontSize: 14,
                                    fontStyle: FontStyle.italic,
                                  )),
                            ),
                          )),

                      ///RESIGER BUTTON
                      isLoading
                          ? CircularProgressIndicator(
                              backgroundColor: Colors.red,
                            )
                          : Container(
                              width: deviceSiae.width * 0.8,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  color: Colors.purple,
                                  gradient: LinearGradient(
                                    colors: [Colors.purple, Colors.white],
                                    begin: Alignment.center,
                                    end: Alignment.bottomLeft,
                                  )),
                              child: FlatButton(
                                  materialTapTargetSize:
                                      MaterialTapTargetSize.shrinkWrap,
                                  onPressed: () {
                                    saveForm();
                                  },
                                  child: Center(
                                    child: Text(
                                      "SIGN UP",
                                      style: TextStyle(
                                          color: Colors.white,
                                          letterSpacing: 1),
                                    ),
                                  )),
                            ),
                      //END OF REGISTER BUTTON //
                      SizedBox(
                        height: 20,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Already have an account ? ',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                            ),
                          ),
                          InkWell(
                            // onTap: () =>
                            //   Navigator.pushNamed(context, SignUp.signup),
                            child: InkWell(
                              onTap: () =>
                                  Navigator.pushNamed(context, Login.loginid),
                              child: Text(
                                'Sign in',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12,
                                ),
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
