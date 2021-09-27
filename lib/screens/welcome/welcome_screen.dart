import 'package:beauty_saloon/model/countries_model.dart';
import 'package:beauty_saloon/utils/shared_prefs.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:beauty_saloon/utils/utils.dart';
import 'package:beauty_saloon/components/custom_button_1.dart';
import 'package:beauty_saloon/localization/language/languages.dart';
import 'package:beauty_saloon/localization/locale_constants.dart';
import 'package:beauty_saloon/model/CountriesAndCitiesModel.dart';
import 'package:beauty_saloon/model/city_model.dart';
import 'package:beauty_saloon/model/language_data.dart';
import 'package:beauty_saloon/screens/service_type/service_type_screen.dart';
import 'package:beauty_saloon/utils/app_constants.dart';
import 'package:beauty_saloon/utils/color_constants.dart';
import 'package:http/http.dart' as http;

class WelcomeScreen extends StatefulWidget {
  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {

  //countries and cities
  Dialog languageDialog;
  Dialog countryDialog;
  Dialog cityDialog;


  CountriesAndCitiesModel countriesAndCitiesModel;
  CountriesModel selectedCountry;
  CityModel selectedCity;

  List<String> languagesList = [];
  List<CityModel> _citiesList = [];


  String country;
  String city;


  bool showAgainCheckedValue = false;
  bool formValidate = false;
  bool isCountrySelectedMsg = false;

  bool isLoading = true;


  @override
  void initState() {

    country = 'Country';
    city = 'City';

    _getCountriesAndCities();

    super.initState();
  }

  @override
  void didChangeDependencies() {

    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(
          Languages.of(context).welcomeScreenTitle,
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: isLoading ? Utils.buildLoading() : Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Image.asset(
                      'assets/images/salon_logo.png',
                      width: 220,
                    ),

                    //language drop down
                    //_createLanguageDropDown(),

                    Container(
                      height: 50,
                      padding: EdgeInsets.symmetric(horizontal: 16.0),
                      margin: EdgeInsets.symmetric(horizontal: 8.0),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(4.0),
                        border: Border.all(
                            color:  (formValidate && (Languages.of(context).labelSelectLanguage == 'Select Language'
                                || Languages.of(context).labelSelectLanguage == 'اختار اللغة'))  ? ColorConstants.redColor : ColorConstants.black,
                            style: BorderStyle.solid,
                            width: 0.80),
                      ),
                      child: InkWell(
                        onTap: () {
                          //open language dialog box
                          displayLanguageDialog();
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              Languages.of(context).labelSelectLanguage,
                              style: TextStyle(
                                  fontSize: 17,
                                  color: ColorConstants.black.withOpacity(0.7)),
                            ),

                            Icon(Icons.keyboard_arrow_down_rounded, color: ColorConstants.black.withOpacity(0.6), size: 30),

                          ],
                        ),
                      ),
                    ),

                    SizedBox(
                      height: 4,
                    ),

                    Visibility(
                      visible: (formValidate && (Languages.of(context).labelSelectLanguage == 'Select Language' ||
                          Languages.of(context).labelSelectLanguage == 'اختار اللغة'))  ? true : false,
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 28.0),
                        child: Text(
                          Languages.of(context).selectLanguageErrorMessage,
                          style: TextStyle(
                            fontSize: 12,
                            color: ColorConstants.redColor,
                          ),
                        ),
                      ),
                    ),


                    SizedBox(height: 8),

                    //CountryDropDown(),
                    //country dialog
                    Container(
                      height: 50,
                      padding: EdgeInsets.symmetric(horizontal: 16.0),
                      margin: EdgeInsets.symmetric(horizontal: 8.0),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(4.0),
                        border: Border.all(
                            color:  (formValidate && (Languages.of(context).welcomeLabelSelectCountry == 'Select Country'
                                || Languages.of(context).welcomeLabelSelectCountry == 'حدد الدولة')) ? ColorConstants.redColor : ColorConstants.black,
                            style: BorderStyle.solid,
                            width: 0.80),
                      ),
                      child: InkWell(
                        onTap: () {
                          //open country dialog box
                          displayCountryDialog();
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              //country,
                              Languages
                                  .of(context)
                                  .welcomeLabelSelectCountry,
                              style: TextStyle(
                                  fontSize: 17,
                                  color: ColorConstants.black.withOpacity(0.7)),
                            ),

                            Icon(Icons.keyboard_arrow_down_rounded, color: ColorConstants.black.withOpacity(0.6), size: 30),

                          ],
                        ),
                      ),
                    ),

                    SizedBox(
                      height: 4,
                    ),

                    Visibility(
                      visible: (formValidate && (Languages.of(context).welcomeLabelSelectCountry == 'Select Country'
                          || Languages.of(context).welcomeLabelSelectCountry == 'حدد الدولة')) ? true : false,
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 28.0),
                        child: Text(
                          Languages.of(context).selectCountryErrorMessage,
                          style: TextStyle(
                            fontSize: 12,
                            color: ColorConstants.redColor,
                          ),
                        ),
                      ),
                    ),


                    SizedBox(height: 8),

                    //city dialog
                    //CityDropDown(),
                    Container(
                      height: 50,
                      padding: EdgeInsets.symmetric(horizontal: 16.0),
                      margin: EdgeInsets.symmetric(horizontal: 8.0),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(4.0),
                        border: Border.all(
                            color: (formValidate && (Languages.of(context).welcomeLabelSelectCity == 'Select City'
                            || Languages.of(context).welcomeLabelSelectCity == 'اختر مدينة')) ? ColorConstants.redColor : ColorConstants.black,
                            style: BorderStyle.solid,
                            width: 0.80),
                      ),
                      child: InkWell(
                        onTap: () {
                          //open city dialog box

                          //if(country == 'Select Country') {
                          if((Languages.of(context).welcomeLabelSelectCountry == 'Select Country'
                              || Languages.of(context).welcomeLabelSelectCountry == 'حدد الدولة')) {
                            setState(() {
                              isCountrySelectedMsg = true;
                            });
                          }
                          else {
                            displayCityDialog();
                          }

                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              //city,
                            Languages
                            .of(context)
                            .welcomeLabelSelectCity,
                              style: TextStyle(
                                  color: ColorConstants.black.withOpacity(0.7), fontSize: 17),
                            ),

                            Icon(Icons.keyboard_arrow_down_rounded, color: ColorConstants.black.withOpacity(0.6), size: 30),


                          ],
                        ),
                      ),
                    ),

                    SizedBox(
                      height: 4,
                    ),

                    Visibility(
                      visible: (formValidate && (Languages.of(context).welcomeLabelSelectCity == 'Select City'
                          || Languages.of(context).welcomeLabelSelectCity == 'اختر مدينة')) ? true : false,
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 28.0),
                        child: Text(
                          Languages.of(context).selectCityErrorMessage,
                          style: TextStyle(
                            fontSize: 12,
                            color: ColorConstants.redColor,
                          ),
                        ),
                      ),
                    ),


                    Visibility(
                      visible: (isCountrySelectedMsg && (Languages.of(context).welcomeLabelSelectCountry == 'Select Country'
                      || Languages.of(context).welcomeLabelSelectCountry == 'حدد الدولة')) ? true : false,
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 28.0),
                        child: Text(
                          Languages.of(context).selectCountryErrorMessage,
                          style: TextStyle(
                            fontSize: 12,
                            color: ColorConstants.redColor,
                          ),
                        ),
                      ),
                    ),


                    SizedBox(height: 16),

                    //get started button
                    CustomButton1(
                      text: Languages.of(context).welcomeButtonTitle,
                      callback: () {

                        setState(() {
                          formValidate = true;
                        });


                        if(

                          (Languages.of(context).labelSelectLanguage != 'Select Language' &&
                            Languages.of(context).labelSelectLanguage != 'اختار اللغة') &&

                          (Languages.of(context).welcomeLabelSelectCountry != 'Select Country' &&
                              Languages.of(context).welcomeLabelSelectCountry != 'حدد الدولة') &&

                          (Languages.of(context).welcomeLabelSelectCity != 'Select City' &&
                          Languages.of(context).welcomeLabelSelectCity != 'اختر مدينة')

                        ) {

                          //navigate to services types screen
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => ServiceTypeScreen(),
                            ),
                          );


                        }


                      },
                    ),

                    SizedBox(height: 16),

                    //welcome info 1
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 22.0),
                      child: Text(
                        Languages.of(context).welcomeInfo1,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 13,
                            fontFamily: 'Quicksand',
                            fontWeight: FontWeight.bold),
                      ),
                    ),

                    SizedBox(
                      height: 8,
                    ),

                    //welcome info 2
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 22.0),
                      child: Text(
                        Languages.of(context).welcomeInfo2,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 13,
                            fontFamily: 'Quicksand',
                            fontWeight: FontWeight.bold),
                      ),
                    ),

                    SizedBox(
                      height: 16,
                    ),

                    //do not show again checkbox
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.65,
                      child: CheckboxListTile(
                        dense: false,
                        activeColor: ColorConstants.primaryColor,
                        title: Text(
                          Languages.of(context).welcomeCheckboxText,
                          style: TextStyle(
                            fontFamily: 'Quicksand',
                          ),
                        ),
                        value: showAgainCheckedValue,
                        onChanged: (newValue) {
                          setState(() {
                            showAgainCheckedValue = newValue;
                          });

                          SharedPref.save(AppConstants.prefShowWelcomeSceen, showAgainCheckedValue);

                        },
                        controlAffinity: ListTileControlAffinity.leading,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  _createLanguageDropDown() {
    return Container(
      width: double.maxFinite,
      padding: EdgeInsets.symmetric(horizontal: 16.0),
      margin: EdgeInsets.symmetric(horizontal: 8.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(4.0),
        border: Border.all(
            color: Colors.black, style: BorderStyle.solid, width: 0.80),
      ),
      child: DropdownButton<LanguageData>(
        iconSize: 30,
        isExpanded: true,
        icon: Icon(Icons.keyboard_arrow_down_outlined),
        hint: Text(Languages.of(context).labelSelectLanguage),
        onChanged: (LanguageData language) {

          changeLanguage(context, language.languageCode);
          Languages.of(context).setLanguageValue(language.name);

        },
        items: LanguageData.languageList()
            .map<DropdownMenuItem<LanguageData>>(
              (e) => DropdownMenuItem<LanguageData>(
                value: e,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[Text(e.name)],
                  //children: <Widget>[Text(e)],
                ),
              ),
            )
            .toList(),
      ),
    );
  }

  void _getCountriesAndCities() async {

    String url = '${AppConstants.baseURL}/api/countries';

    // make get request
    http.Response response = await http.get(url, headers: {"APP_KEY": "HGwADiSjyHSAWZwTZRNXfNoJYZVyPf38x4Aq6jBaDrIyH76FKeNDBcy1UrEq0FInDgC9SWRMVIlmZ4jX"});

    // check the status code for the result
    int statusCode = response.statusCode;

    if (statusCode == 200) {

      String body = response.body;
      //print('countries and cities response $body');

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

  displayLanguageDialog() {
    languageDialog = Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4.0)),
      child: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height / 3.0,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            //heading
            Container(
              width: double.maxFinite,
              height: 64,
              decoration: BoxDecoration(
                color: ColorConstants.primaryColor,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(4.0),
                  topRight: Radius.circular(4.0),
                ),
              ),
              child: Center(
                child: Text(
                  Languages.of(context).labelSelectLanguage,
                  style: TextStyle(
                      fontFamily: 'Quicksand',
                      fontSize: 22,
                      color: ColorConstants.whiteColor,
                      fontWeight: FontWeight.normal),
                ),
              ),
            ),

            //languages list
            ListView.builder(
              scrollDirection: Axis.vertical,
              itemCount: LanguageData.languageList().length,
              shrinkWrap: true,
              primary: false,
              itemBuilder: (BuildContext context, int index) {
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: InkWell(
                    onTap: () {

                      changeLanguage(context, LanguageData.languageList()[index].languageCode);
                      Languages.of(context).setLanguageValue(LanguageData.languageList()[index].name);

                      Navigator.pop(context);
                    },
                    child: Center(
                        child: Text(
                          LanguageData.languageList()[index].name,
                          style: TextStyle(
                            fontFamily: 'Quicksand',
                            fontSize: 20,
                          ),
                        )),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );

    showDialog(
        context: context, builder: (BuildContext context) => languageDialog);
  }


  displayCountryDialog() {
    countryDialog = Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4.0)),
      child: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height / 3.0,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            //heading
            Container(
              width: double.maxFinite,
              height: 64,
              decoration: BoxDecoration(
                color: ColorConstants.primaryColor,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(4.0),
                  topRight: Radius.circular(4.0),
                ),
              ),
              child: Center(
                child: Text(
                  'Select Country',
                  style: TextStyle(
                      fontFamily: 'Quicksand',
                      fontSize: 22,
                      color: ColorConstants.whiteColor,
                      fontWeight: FontWeight.normal),
                ),
              ),
            ),

            //country list
            ListView.builder(
              scrollDirection: Axis.vertical,
              //itemCount: countryList.length,
              itemCount: countriesAndCitiesModel.data.length,
              shrinkWrap: true,
              primary: false,
              itemBuilder: (BuildContext context, int index) {
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: InkWell(
                    onTap: () {

                      Languages
                          .of(context)
                          .setCountryValue(countriesAndCitiesModel.data[index].countryName);

                      Languages
                          .of(context)
                          .resetCityValue();

                      setState(() {

                        Languages
                            .of(context)
                            .welcomeLabelSelectCountry;

                        selectedCountry = countriesAndCitiesModel.data[index];

                        if(_citiesList != null) {
                          _citiesList.clear();
                        }

                        setState(() {
                          _citiesList.addAll(countriesAndCitiesModel.data[index].city);
                        });


                      });

                      //save selected country value in shared pref
                      SharedPref.save(AppConstants.prefSelectedCountry, countriesAndCitiesModel.data[index].id);


                      /*setState(() {

                        country = countriesAndCitiesModel.data[index].countryName;
                        selectedCountry = countriesAndCitiesModel.data[index];

                        if(_citiesList != null) {
                          _citiesList.clear();
                        }

                        setState(() {
                          _citiesList.addAll(countriesAndCitiesModel.data[index].city);
                        });


                      });*/

                      Navigator.pop(context);
                    },
                    child: Center(
                        child: Text(
                          countriesAndCitiesModel.data[index].countryName,
                          style: TextStyle(
                            fontFamily: 'Quicksand',
                            fontSize: 20,
                          ),
                        )),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );

    showDialog(
        context: context, builder: (BuildContext context) => countryDialog);
  }

  displayCityDialog() {
    cityDialog = Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4.0)),
      child: Container(
        width: MediaQuery.of(context).size.width,
        //height: MediaQuery.of(context).size.height / 3.5,
        //height: _citiesList.length * 70.0,
        height: _citiesList.length == 1 ? 120 :_citiesList.length * 70.0,
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              //heading
              Container(
                width: double.maxFinite,
                height: 64,
                decoration: BoxDecoration(
                  color: ColorConstants.primaryColor,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(4.0),
                    topRight: Radius.circular(4.0),
                  ),
                ),
                child: Center(
                  child: Text(
                    'Select City',
                    style: TextStyle(
                        fontFamily: 'Quicksand',
                        fontSize: 22,
                        color: ColorConstants.whiteColor,
                        fontWeight: FontWeight.normal),
                  ),
                ),
              ),

              //city list
              ListView.builder(
                scrollDirection: Axis.vertical,
                itemCount: _citiesList.length,
                shrinkWrap: true,
                primary: false,
                itemBuilder: (BuildContext context, int index) {
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: InkWell(
                      onTap: () {

                        Languages
                            .of(context)
                            .setCityValue(_citiesList[index].cityName);

                        setState(() {

                          selectedCity = _citiesList[index];
                          Languages
                              .of(context)
                              .welcomeLabelSelectCity;

                        });

                        //save selected city value in shared pref
                        SharedPref.save(AppConstants.prefSelectedCity, _citiesList[index].id);
                        //SharedPref.save(AppConstants.prefSelectedCountryCites, _citiesList[index]);
                        SharedPref.saveCitiesList(AppConstants.prefSelectedCountryCites, _citiesList);

                        /*setState(() {
                          city = _citiesList[index].cityName;
                          selectedCity = _citiesList[index];
                        });*/

                        Navigator.pop(context);
                      },
                      child: Center(
                          child: Text(
                            _citiesList[index].cityName,
                            style: TextStyle(
                              fontFamily: 'Quicksand',
                              fontSize: 20,
                            ),
                          )),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );

    showDialog(context: context, builder: (BuildContext context) => cityDialog);
  }



}
