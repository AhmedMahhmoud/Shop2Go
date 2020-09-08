import 'dart:async';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:shopapp/Models/HttpException.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserInfoAuth with ChangeNotifier {
  String _token;
  DateTime expiaryDate;
  String userID;
  Timer auth_timer;
  Future<void> signup(String email, String password) async {
    const url =
        'https://identitytoolkit.googleapis.com/v1/accounts:signUp?key=AIzaSyAvCzZklnOwprVPXVPsKZr8QX8OSs0BJLE';
    try {
      final response = await http.post(
        url,
        body: json.encode(
          {'email': email, 'password': password, 'returnSecureToken': true},
        ),
      );
      final responseData = json.decode(response.body);
      if (responseData['error'] != null) {
        throw HttpException(responseData['error']['message']);
      }
    } catch (error) {
      throw (error);
    }
  }

  String get userId {
    return userID;
  }

  bool get isAuth {
    return token !=
        null; //return true if it is not null (hence authenticated)//
  }

  String get token {
    if (expiaryDate != null &&
        expiaryDate.isAfter(DateTime.now()) &&
        _token != null) {
      return _token;
    }
    return null;
  }

  Future<void> sendResetPassword(String email) async {
    final url =
        "https://identitytoolkit.googleapis.com/v1/accounts:sendOobCode?key=AIzaSyAvCzZklnOwprVPXVPsKZr8QX8OSs0BJLE";
    final response = await http.post(url,
        body: json.encode({'requestType': "PASSWORD_RESET", 'email': email}));
    final responseMsg = json.decode(response.body);
    print(responseMsg);
  }

  Future<void> logout() async {
    _token = null;
    expiaryDate = null;
    userID = null;
    if (auth_timer != null) {
      auth_timer.cancel();
      auth_timer = null;
    }
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    prefs.clear();
  }

  Future<bool> truAutoLogin() async {
    final userPref = await SharedPreferences.getInstance();
    if (!userPref.containsKey('userData')) {
      return false;
    }
    final extractedUserData =
        json.decode(userPref.getString('userData')) as Map<String, Object>;
    final expiarydate = DateTime.parse(extractedUserData['expiarydate']);
    if (expiarydate.isBefore(DateTime.now())) //not valid token
    {
      return false;
    }
    _token = extractedUserData['token'];
    userID = extractedUserData['userId'];
    expiaryDate = expiarydate;
    notifyListeners();
    auto_logout();
    return true;
  }

  void auto_logout() {
    if (auth_timer != null) {
      auth_timer.cancel();
    }
    final timetoExpire = expiaryDate.difference(DateTime.now()).inSeconds;
    auth_timer = Timer(Duration(seconds: timetoExpire), logout);
  }

  Future<void> signin(String email, String password) async {
    const url =
        'https://identitytoolkit.googleapis.com/v1/accounts:signInWithPassword?key=AIzaSyAvCzZklnOwprVPXVPsKZr8QX8OSs0BJLE';
    try {
      final response = await http.post(url,
          body: json.encode(
            {'email': email, 'password': password, 'returnSecureToken': true},
          ));
      final responseData = json.decode(response.body);
      if (responseData['error'] != null) {
        throw HttpException((responseData['error']['message']));
      }

      if (responseData['error'] != null) {
        throw HttpException(responseData['error']['message']);
      }
      _token = responseData['idToken'];
      userID = responseData['localId'];
      expiaryDate = DateTime.now().add(
        Duration(
          seconds: int.parse(
            responseData['expiresIn'],
          ),
        ),
      );
      auto_logout();
      notifyListeners();
      //SAVE DATA LOCALLY ON DEVICE USING SHAREDPREFERENCES//
      final userPref = await SharedPreferences.getInstance();
      final userData = json.encode({
        'token': _token,
        'userId': userID,
        'expiarydate': expiaryDate.toIso8601String()
      });

      userPref.setString('userData', userData);
    } catch (error) {
      throw error;
    }
  }
}
