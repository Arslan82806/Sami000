import 'package:beauty_saloon/utils/color_constants.dart';
import 'package:flutter/material.dart';

class CustomWidgets {

  static Widget customDivider() {
    return Container(
      width: double.maxFinite,
      height: 0.5,
      color: ColorConstants.dividerColor,
    );
  }

}
