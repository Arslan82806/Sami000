import 'dart:convert';
import 'package:beauty_saloon/localization/language/languages.dart';
import 'package:beauty_saloon/model/salon_gallery_model.dart';
import 'package:beauty_saloon/screens/full_screen_image/full_screen_image.dart';
import 'package:beauty_saloon/utils/app_constants.dart';
import 'package:beauty_saloon/utils/utils.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class SalonGalleryPage extends StatefulWidget {

  final String salonId;
  SalonGalleryPage({this.salonId});

  @override
  _SalonGalleryPageState createState() => _SalonGalleryPageState();
}

class _SalonGalleryPageState extends State<SalonGalleryPage> {

  SalonGalleryModel salonImages;
  bool isLoading = false;

  @override
  void initState() {

    _getSalonImages(widget.salonId).then((value) => {
      salonImages = value,
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: isLoading ? Utils.buildLoading() : salonImages == null ? emptyGallery() : SingleChildScrollView(
        child: GridView.builder(
          padding: EdgeInsets.all(24),
          itemCount: salonImages.data.length,
          shrinkWrap: true,
          primary: false,

          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3, mainAxisSpacing: 4, crossAxisSpacing: 4),
          itemBuilder: (BuildContext context, int index) {
            return InkWell(
              onTap: () {

                //navigate to full screen image
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => FullScreenImage(
                      image: salonImages.data[index].image,
                    ),
                  ),
                );

              },
              child: CachedNetworkImage(
                imageUrl: salonImages.data[index].image,
                fit: BoxFit.fill,
                placeholder: (context, url) =>
                    CupertinoActivityIndicator(),
                errorWidget: (context, url, error) =>
                    Icon(Icons.error),
              ),
            );
          },
        ),
      ),
    );
  }

  Future<SalonGalleryModel> _getSalonImages(String salonId) async {

    String url = '${AppConstants.baseURL}/api/getSalonGallery';
    SalonGalleryModel salonGalleryModel;


    setState(() {
      isLoading = true;
    });

    var response = await http.post(
        url,
        headers: {
          "APP_KEY": AppConstants.APP_KEY,
        },
        body: {
          "salon_id": salonId,
        });


    // check the status code for the result
    int statusCode = response.statusCode;

    if (statusCode == 200) {

      salonGalleryModel = SalonGalleryModel.fromJson(jsonDecode(response.body));

      setState(() {
        isLoading = false;
      });

      return salonGalleryModel;

    }
    else {

      //display something went wrong message
      print('status code: $statusCode');
      print('something went wrong !');

      setState(() {
        isLoading = false;
      });

      return salonGalleryModel;
    }
    //end if

  }

  Widget emptyGallery() {
    return Center(
      child: Text(Languages.of(context).noGalleryImages, style: TextStyle(fontFamily: 'Quicksand', fontSize: 20,)),
    );
  }


}
