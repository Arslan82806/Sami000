import 'package:beauty_saloon/utils/color_constants.dart';
import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget with PreferredSizeWidget {

  final String title;
  final bool showBackButton;

  CustomAppBar({this.title, this.showBackButton=true});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: ColorConstants.primaryColor,
      leading: showBackButton ? IconButton(
        icon: Icon(Icons.arrow_back, color: ColorConstants.whiteColor),
        onPressed: () {
          Navigator.pop(context);
        },
      ) : Container(),
      title: Text(
        title,
        style: TextStyle(fontFamily: 'Quicksand', color: ColorConstants.whiteColor),
      ),
      centerTitle: true,
    );
  }

  @override
  // TODO: implement preferredSize
  Size get preferredSize => Size.fromHeight(56.0);
}

