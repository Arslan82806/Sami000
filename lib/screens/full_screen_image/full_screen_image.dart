import 'package:beauty_saloon/utils/color_constants.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class FullScreenImage extends StatefulWidget {

  final String image;
  FullScreenImage({@required this.image});

  @override
  _FullScreenImageState createState() => _FullScreenImageState();
}

class _FullScreenImageState extends State<FullScreenImage> {
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            color: ColorConstants.black.withOpacity(0.8),
            child: CachedNetworkImage(
              imageUrl: widget.image,
              width: double.maxFinite,
              height: 150,
              fit: BoxFit.contain,
              placeholder: (context, url) =>
                  CupertinoActivityIndicator(),
              errorWidget: (context, url, error) =>
                  Icon(Icons.error),
            ),
          ),
        ),
      ),
    );
  }
}
