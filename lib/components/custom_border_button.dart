import 'package:beauty_saloon/utils/color_constants.dart';
import 'package:flutter/material.dart';

class CustomBorderButton extends StatelessWidget {

  final String text;
  final VoidCallback onPressedCallback;
  CustomBorderButton(this.text, this.onPressedCallback, );

  double r = 0.1;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height * 0.06,
      margin: EdgeInsets.symmetric(horizontal: 8),
      child: RaisedButton(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(4.0),
            side: BorderSide(color: ColorConstants.primaryColor)),
        onPressed: () => onPressedCallback(),
        color: ColorConstants.whiteColor,
        textColor: ColorConstants.primaryColor,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [

            Text(text, style: TextStyle(fontFamily: 'Quicksand', fontSize: 17), textAlign: TextAlign.center),

          ],
        ),

      ),
    );
  }
}
