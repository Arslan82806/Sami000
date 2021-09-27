import 'package:flutter/material.dart';

class CustomButton1 extends StatelessWidget {

  final String text;
  VoidCallback callback;

  CustomButton1({this.text, this.callback});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.maxFinite,
      //height: MediaQuery.of(context).size.width > 768 ? 60 : 44,
      height: MediaQuery.of(context).size.height * 0.06,
      margin: EdgeInsets.symmetric(horizontal: 8.0),
      child: ElevatedButton(
        onPressed: () {
          callback();
        },
        child: Text(
            text,
            style: TextStyle(
              fontFamily: 'Quicksand',
              fontSize: 18,
            )),
      ),
    );
  }
}
