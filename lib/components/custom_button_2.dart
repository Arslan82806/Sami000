import 'package:beauty_saloon/utils/color_constants.dart';
import 'package:flutter/material.dart';

class CustomButton2 extends StatelessWidget {

  final String text;
  VoidCallback callback;

  CustomButton2({this.text, this.callback});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.maxFinite,
      height: MediaQuery.of(context).size.width > 768 ? 56 : 44,
      margin: EdgeInsets.symmetric(horizontal: 8.0),
      child: ElevatedButton(
        onPressed: () {
          callback();
        },

        style: ButtonStyle(
            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30.0),
                    side: BorderSide(color: ColorConstants.primaryColor)
                )
            ),
        ),
        child: Text(
            text,
            style: TextStyle(
              fontFamily: 'Quicksand',
              fontSize: MediaQuery.of(context).size.width > 768 ? 20 : 14,
              color: ColorConstants.whiteColor,
            )),
      ),
    );
  }
}
