import 'package:beauty_saloon/utils/color_constants.dart';
import 'package:flutter/material.dart';

class Utils {

  static Widget buildLoading() => Center(child: CircularProgressIndicator(valueColor: new AlwaysStoppedAnimation<Color>(Color(0xFF8D72B7)),));

  static bool isEmail(String em) {

    String p = r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';

    RegExp regExp = new RegExp(p);

    return regExp.hasMatch(em);
  }

  static void displaySnackBar(BuildContext context, String message, int sec) {
    final snackBar = SnackBar(
        content: Text(
          message,
          style: TextStyle(color: ColorConstants.whiteColor),
        ),
        backgroundColor: ColorConstants.black,
        duration: Duration(seconds: sec));

    // Find the Scaffold in the Widget tree and use it to show a SnackBar!
    Scaffold.of(context).showSnackBar(snackBar);
  }

  static Widget emptyLayout(String msg) {
    return Center(child: Text(msg, style: TextStyle(fontSize: 20,)));
  }


}