import 'package:beauty_saloon/utils/color_constants.dart';
import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {

  final _controller;
  final String labelText;
  final String hintText;
  final TextInputType keyboardType;
  final String Function(String) validator;
  final VoidCallback onEditingCompleted;

  final bool obscureText;

  CustomTextField(this._controller, this.labelText, this.hintText, this.keyboardType, this.validator, {this.obscureText = false, this.onEditingCompleted});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: _controller,
      keyboardType: keyboardType,
      obscureText: obscureText,
      validator: validator,
      onEditingComplete: onEditingCompleted,
      decoration: InputDecoration(
          border: new OutlineInputBorder(
          ),
          labelText: labelText,
          hintText: hintText,
      hintStyle: TextStyle(
          color: ColorConstants.lightGreyTextColor, fontSize: 13),
      labelStyle: TextStyle(
          color: ColorConstants.lightGreyTextColor, fontSize: 13),
      ),
    );
  }
}


/*
class CustomTextfield extends StatefulWidget {

  final TextEditingController controller;
  final String hintText;
  final TextInputType keyboardType;
  final bool obscureText;

  CustomTextfield(this.controller, this.hintText, this.keyboardType, {this.obscureText = false});

  @override
  _CustomTextfieldState createState() => _CustomTextfieldState();
}

class _CustomTextfieldState extends State<CustomTextfield> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 2, horizontal: 8),
      margin: EdgeInsets.symmetric(horizontal: 8,),
      decoration: BoxDecoration(
        border: Border.all(
          color: ColorConstants.dividerColor,
        ),
        borderRadius: BorderRadius.all(
          Radius.circular(8.0),
        ),
      ),
      child: TextField(
        controller: widget.controller,
        keyboardType: widget.keyboardType,
        obscureText: widget.obscureText,
        onChanged: (value) {
          print(widget.controller.text.length);
          setState(() {});
        },

        decoration: new InputDecoration(

            border: InputBorder.none,
            filled: true,
            contentPadding: EdgeInsets.only(top: 0, left: 10, right: 10, ),
            hintStyle: TextStyle(color: ColorConstants.lightGreyTextColor),
            hintText: widget.hintText,
            fillColor: Colors.white70),

      ),
    );
  }
}
*/
