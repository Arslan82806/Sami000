import 'package:beauty_saloon/components/custom_app_bar.dart';
import 'package:beauty_saloon/model/about_response.dart';
import 'package:beauty_saloon/utils/app_constants.dart';
import 'package:beauty_saloon/utils/static_data.dart';
import 'package:beauty_saloon/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:html/parser.dart';


class AboutPage extends StatefulWidget {
  @override
  _AboutPageState createState() => _AboutPageState();
}

class _AboutPageState extends State<AboutPage> {

  //AboutResponse aboutResponse;
  //bool isLoading = true;
  String htmlStringValue;

  @override
  void initState() {

    //not needed anymore
    /*_getAboutInfo().then((value) => {

      setState(() {
        //aboutResponse = value;
        StaticData.aboutResponse = value;
        htmlStringValue = StaticData.aboutResponse.data.aboutUs;
      }),

    });*/


    setState(() {
      htmlStringValue = StaticData.aboutResponse.data.aboutUs;
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: 'About Sami',
      ),
      //body: isLoading ? Utils.buildLoading() : Center(
      body: Center(
        child: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.all(16.0),
            child: Text(parseHtmlString(htmlStringValue)),
          ),
        ),
      ),
    );
  }

  //this api call is not needed anymore
  /*Future<AboutResponse> _getAboutInfo() async {

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
      print('countries and cities response $body');

      StaticData.aboutResponse = AboutResponse.fromJson(jsonDecode(response.body));

    }
    else {


      //display something went wrong message
      print('status code: $statusCode');
      print('something went wrong !');

      StaticData.aboutResponse = AboutResponse.fromJson(jsonDecode(response.body));

    }
    //end if

    setState(() {
      isLoading = false;
    });


    return aboutResponse;
  }*/


  String parseHtmlString(String htmlString) {

    final document = parse(htmlString);
    final String parsedString = parse(document.body.text).documentElement.text;
    return parsedString;

  }




}
