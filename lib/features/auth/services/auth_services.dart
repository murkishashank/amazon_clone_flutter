import 'dart:convert';
import 'package:flutter_amazon_clone/common/widgets/bottom_bar.dart';
import 'package:flutter_amazon_clone/constants/error_handling.dart';
import 'package:flutter_amazon_clone/constants/global_variables.dart';
import 'package:flutter_amazon_clone/constants/utils.dart';
import 'package:flutter_amazon_clone/features/home/screens/home_screen.dart';
import 'package:flutter_amazon_clone/models/user.dart';
import 'package:flutter_amazon_clone/providers/user_providers.dart';
import "package:http/http.dart" as http;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  void signUpUser({
    required BuildContext context,
    required String email,
    required String password,
    required String name,
  }) async {
    try {
      User user = User(
        id: '',
        name: name,
        password: password,
        email: email,
        address: '',
        type: '',
        token: '',
      );

      http.Response res = await http.post(
        Uri.parse('$uri/api/v1/signup'),
        body: user.toJson(),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );

      httpErrorHandle(
          response: res,
          context: context,
          onSuccess: () {
            showSnackBar(context, "Account created Successfully.");
          });
    } catch (error) {
      print("error");
      showSnackBar(context, error.toString());
    }
  }

  void signInUser({
    required BuildContext context,
    required String email,
    required String password,
  }) async {
    try {
      http.Response res = await http.post(
        Uri.parse('$uri/api/v1/signin'),
        body: jsonEncode({"email": email, "password": password}),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );

      httpErrorHandle(
          response: res,
          context: context,
          onSuccess: () async {
            SharedPreferences pref = await SharedPreferences.getInstance();
            Provider.of<UserProvider>(context, listen: false).setUser(res.body);
            await pref.setString("x-auth-token", jsonDecode(res.body)["token"]);
            showSnackBar(context, "Login in successfull.");
            Navigator.pushNamedAndRemoveUntil(
              context,
              BottomBar.routeName,
              (route) => false,
            );
          });
    } catch (error) {
      showSnackBar(context, error.toString());
    }
  }

// get user data
  void getUserData(BuildContext context) async {
    try {
      SharedPreferences pref = await SharedPreferences.getInstance();
      String? token = pref.getString("x-auth-token");
      if (token == null) {
        pref.setString("x-auth-token", "");
      }
      var tokenRes = await http.post(
        Uri.parse('$uri/tokenIsValid'),
        body: jsonEncode({}),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          "x-auth-token": token!
        },
      );

      var response = jsonDecode(tokenRes.body);
      if (response == true) {
        http.Response userResposne = await http.get(
          Uri.parse('$uri/'),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
            "x-auth-token": token
          },
        );

        var userProvider = Provider.of<UserProvider>(context, listen: false);
        userProvider.setUser((userResposne.body));
      }
    } catch (error) {
      print("error");
      showSnackBar(context, error.toString());
    }
  }
}
