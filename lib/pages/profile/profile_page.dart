import 'dart:convert';
import 'package:beauty_saloon/components/custom_button_2.dart';
import 'package:beauty_saloon/localization/language/languages.dart';
import 'package:beauty_saloon/model/CountriesAndCitiesModel.dart';
import 'package:beauty_saloon/model/otp_response.dart';
import 'package:beauty_saloon/pages/profile/edit_profile_page.dart';
import 'package:beauty_saloon/screens/sign_in/sign_in_screen.dart';
import 'package:beauty_saloon/utils/app_constants.dart';
import 'package:beauty_saloon/utils/color_constants.dart';
import 'package:beauty_saloon/utils/shared_prefs.dart';
import 'package:beauty_saloon/utils/static_data.dart';
import 'package:beauty_saloon/utils/styles.dart';
import 'package:beauty_saloon/utils/utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';


class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {

  //OTPResponse userData;
  bool isLoading = false;

  //countries and cities
  CountriesAndCitiesModel countriesAndCitiesModel;

  String userCountry, userCity;

  @override
  void initState() {

    if(StaticData.userData == null) {

      setState(() {
        isLoading = true;
      });

      _getUserDataFromSharedPref().then((value) => {

        Future.delayed(const Duration(milliseconds: 1000), () {

          setState(() {
            //userData = value;
            StaticData.userData = value;
            isLoading = false;
          });

        }),

      });

    }

    // _getCountriesAndCities();
    // getUserCountryAndCity(userData.data.countryId, userData.data.cityId);


    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: ColorConstants.bgColor,
      body: SafeArea(
        child: isLoading ? Utils.buildLoading() : Center(
          child: StaticData.userData == null ? signedOutLayout() : SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  //profile image, name and edit button
                  Card(
                    child: Container(
                      padding: EdgeInsets.all(16.0),
                      child: Row(
                        children: [

                          //image
                          Container(
                            width: 70.0,
                            height: 70.0,
                            decoration: new BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                width: 1,
                                color: ColorConstants.black,
                              ),
                              image: new DecorationImage(
                                fit: BoxFit.fill,
                                image: NetworkImage(StaticData.userData.data.image),
                              ),
                            ),
                          ),

                          SizedBox(width: 16),
                          //username
                          Text(StaticData.userData.data.name, style: normalTextStyleBlackBold),

                          Expanded(child: SizedBox()),

                          FloatingActionButton(
                            onPressed: () {

                              //navigate to edit profile page
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) => EditProfilePage(userData: StaticData.userData,),
                                ),
                              ).then((value) => {

                                setState(() {
                                  isLoading = true;
                                }),

                                _getUserDataFromSharedPref().then((value) => {

                                  setState(() {
                                    StaticData.userData = value;
                                    isLoading = false;
                                  }),

                                }),


                              });

                            },
                            mini: true,
                            child: Icon(
                              Icons.edit,
                            ),
                          ),

                        ],
                      ),
                    ),
                  ),

                  SizedBox(
                    height: 20,
                  ),


                  Text(Languages.of(context).nameFieldHeadingProfile, style: normalTextStyleBlackBold),
                  SizedBox(
                    height: 8.0,
                  ),

                  //name
                  Container(
                    width: double.maxFinite,
                    height: 50,
                      padding: EdgeInsets.all(16.0),
                      decoration: BoxDecoration(
                          color: ColorConstants.greyColor.withOpacity(0.2),
                          borderRadius: BorderRadius.all(Radius.circular(16.0),)
                      ),
                      child: Row(
                        children: [
                          Text(StaticData.userData.data.name),
                        ],
                      ),
                  ),

/*                SizedBox(
                    height: 16,
                  ),


                  Text('Email', style: normalTextStyleBlackBold),
                  SizedBox(
                    height: 8.0,
                  ),

                  //email
                  Container(
                    width: double.maxFinite,
                    height: 50,
                    padding: EdgeInsets.all(16.0),
                    decoration: BoxDecoration(
                        color: ColorConstants.greyColor.withOpacity(0.2),
                        borderRadius: BorderRadius.all(Radius.circular(16.0),)
                    ),
                    child: Row(
                      children: [
                        Text(userData.data.email),
                      ],
                    ),
                  ),


                  SizedBox(
                    height: 16,
                  ),

                  Text('Phone', style: normalTextStyleBlackBold),
                  SizedBox(
                    height: 8.0,
                  ),
                  //phone
                  Container(
                    width: double.maxFinite,
                    height: 50,
                    padding: EdgeInsets.all(16.0),
                    decoration: BoxDecoration(
                        color: ColorConstants.greyColor.withOpacity(0.2),
                        borderRadius: BorderRadius.all(Radius.circular(16.0),)
                    ),
                    child: Row(
                      children: [
                        Text(userData.data.phone),
                      ],
                    ),
                  ),*/


                  SizedBox(
                    height: 16,
                  ),

                  Text(Languages.of(context).dobFieldHeadingProfile, style: normalTextStyleBlackBold),
                  SizedBox(
                    height: 8.0,
                  ),

                  //date of birth
                  Container(
                    width: double.maxFinite,
                    height: 50,
                    padding: EdgeInsets.all(16.0),
                    decoration: BoxDecoration(
                        color: ColorConstants.greyColor.withOpacity(0.2),
                        borderRadius: BorderRadius.all(Radius.circular(16.0),)
                    ),
                    child: Row(
                      children: [
                        Text(StaticData.userData.data.birthDate),
                      ],
                    ),
                  ),

                  SizedBox(
                    height: 16,
                  ),

                  Text(Languages.of(context).genderHeadingProfile, style: normalTextStyleBlackBold),
                  SizedBox(
                    height: 8.0,
                  ),

                  //gender
                  Container(
                    width: double.maxFinite,
                    height: 50,
                    padding: EdgeInsets.all(16.0),
                  decoration: BoxDecoration(
                        color: ColorConstants.greyColor.withOpacity(0.2),
                        borderRadius: BorderRadius.all(Radius.circular(16.0),)
                    ),
                    child: Row(
                      children: [
                        Text(StaticData.userData.data.gender),
                      ],
                    ),
                  ),

                  SizedBox(
                    height: 16,
                  ),

                  Text(Languages.of(context).countryHeadingProfile, style: normalTextStyleBlackBold),
                  SizedBox(
                    height: 8.0,
                  ),

                  //country
                  Container(
                    width: double.maxFinite,
                    height: 50,
                    padding: EdgeInsets.all(16.0),
                    decoration: BoxDecoration(
                        color: ColorConstants.greyColor.withOpacity(0.2),
                        borderRadius: BorderRadius.all(Radius.circular(16.0),)
                    ),
                    child: Row(
                      children: [
                        Text(StaticData.userData.data.country.countryName,),
                      ],
                    ),
                  ),


                  SizedBox(
                    height: 16,
                  ),

                  Text(Languages.of(context).cityHeadingProfile, style: normalTextStyleBlackBold),
                  SizedBox(
                    height: 8.0,
                  ),

                  //city
                  Container(
                    width: double.maxFinite,
                    height: 50,
                    padding: EdgeInsets.all(16.0),
                    decoration: BoxDecoration(
                        color: ColorConstants.greyColor.withOpacity(0.2),
                        borderRadius: BorderRadius.all(Radius.circular(16.0),)
                    ),
                    child: Row(
                      children: [
                        Text(StaticData.userData.data.city.cityName,),
                      ],
                    ),
                  ),


                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<OTPResponse> _getUserDataFromSharedPref() async {

    //SignInResponse userData;
    OTPResponse userData;

    if(await SharedPref.checkIfKeyExistsInSharedPref(AppConstants.user_data)) {
      //userData = SignInResponse.fromJson(await SharedPref.read(AppConstants.user_data));
      userData = OTPResponse.fromJson(await SharedPref.read(AppConstants.user_data));
    }
    else {
      userData = null;
    }

    return userData;
  }

  void _getCountriesAndCities() async {

    String url = '${AppConstants.baseURL}/api/countries';

    // make get request
    http.Response response = await http.get(
        url,
        headers: {"APP_KEY": "HGwADiSjyHSAWZwTZRNXfNoJYZVyPf38x4Aq6jBaDrIyH76FKeNDBcy1UrEq0FInDgC9SWRMVIlmZ4jX"}
    );

    // check the status code for the result
    int statusCode = response.statusCode;

    if (statusCode == 200) {

      String body = response.body;
      print('countries and cities response $body');

      countriesAndCitiesModel = CountriesAndCitiesModel.fromJson(jsonDecode(response.body));


    }
    else {


      //display something went wrong message
      print('status code: $statusCode');
      print('something went wrong !');

    }
    //end if

    setState(() {
      isLoading = false;
    });

  }

  getUserCountryAndCity(String countryId, String cityId) {

    String countryValue;
    String cityValue;

    for(int i=0; i<countriesAndCitiesModel.data.length; i++) {

      if(countriesAndCitiesModel.data[i].id.toString() == countryId) {
        countryValue = countriesAndCitiesModel.data[i].countryName;

        for(int j=0; j<countriesAndCitiesModel.data[i].city.length; j++) {

          if(countriesAndCitiesModel.data[i].city[j].id.toString() == cityId) {
            cityValue = countriesAndCitiesModel.data[i].city[j].cityName;
          }
        }


      }

    }

    setState(() {
      userCountry = countryValue;
      userCity = cityValue;
    });


  }


  Widget signedOutLayout() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [

          Text(Languages.of(context).userNotLoggedInText,
              style: TextStyle(fontFamily: 'Quicksand', fontSize: 20, fontWeight: FontWeight.bold, color: ColorConstants.black,)),
          SizedBox(
            height: 8,
          ),
          Text(
              Languages.of(context).pleaseLoginText,
              style: TextStyle(fontFamily: 'Quicksand', fontSize: 18, color: ColorConstants.black,)),
          SizedBox(
            height: 20,
          ),
          CustomButton2(
              text: Languages.of(context).signInButtonText,
              callback: () {

                //navigate to sign in screen
                pushNewScreen(
                  context,
                  screen: SignInScreen(),
                  withNavBar: false, // OPTIONAL VALUE. True by default.
                  pageTransitionAnimation: PageTransitionAnimation.cupertino,
                ).then((value) => {

                  _getUserDataFromSharedPref().then((value) => {
                    setState(() {
                      StaticData.userData = value;
                      isLoading = false;
                    }),
                  }),

                });


              }
          ),


        ],
      ),
    );
  }


}
