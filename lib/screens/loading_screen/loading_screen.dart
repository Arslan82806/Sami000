import 'package:beauty_saloon/model/about_response.dart';
import 'package:beauty_saloon/model/sliders_response.dart';
import 'package:beauty_saloon/screens/home/home_screen.dart';
import 'package:beauty_saloon/utils/app_constants.dart';
import 'package:beauty_saloon/utils/static_data.dart';
import 'package:beauty_saloon/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';


class LoadingScreen extends StatefulWidget {
  @override
  _LoadingScreenState createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen> {

  bool isLoading = true;

  @override
  void initState() {

    getSliderImages();
    getAboutInfo();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: isLoading ? Utils.buildLoading() : Container(),
    );
  }

  void getSliderImages() async {

    SlidersResponse slidersResponse;
    String url = '${AppConstants.baseURL}/api/all-sliders';

    // make get request
    http.Response response = await http.get(
        url,
        headers: {
          "APP_KEY": "HGwADiSjyHSAWZwTZRNXfNoJYZVyPf38x4Aq6jBaDrIyH76FKeNDBcy1UrEq0FInDgC9SWRMVIlmZ4jX"
        }
    );

    // check the status code for the result
    int statusCode = response.statusCode;

    if (statusCode == 200) {

      String body = response.body;
      print('sliders response $body');

      slidersResponse = SlidersResponse.fromJson(jsonDecode(response.body));

      StaticData.slidersResponse = slidersResponse;

      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => HomeScreen(),
        ),
      );
    }
    else {

      //display something went wrong message
      print('status code: $statusCode');
      print('something went wrong !');
      print('result ${response.body}');

    }
    //end if

  }

  void getAboutInfo() async {

    String url = '${AppConstants.baseURL}/api/about-us';

    // make get request
    http.Response response = await http.get(
        url,
        headers: {
          "APP_KEY": "HGwADiSjyHSAWZwTZRNXfNoJYZVyPf38x4Aq6jBaDrIyH76FKeNDBcy1UrEq0FInDgC9SWRMVIlmZ4jX"
        }
    );

    // check the status code for the result
    int statusCode = response.statusCode;

    if (statusCode == 200) {

      String body = response.body;
      print('about us response $body');

      StaticData.aboutResponse = AboutResponse.fromJson(jsonDecode(response.body));

    }
    else {


      //display something went wrong message
      print('status code: $statusCode');
      print('something went wrong !: ${response.body}');

      StaticData.aboutResponse = AboutResponse.fromJson(jsonDecode(response.body));

    }
    //end if

    setState(() {
      isLoading = false;
    });
  }



}
