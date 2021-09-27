import 'dart:convert';
import 'package:beauty_saloon/components/custom_app_bar.dart';
import 'package:beauty_saloon/components/custom_button_2.dart';
import 'package:beauty_saloon/components/custom_button_3.dart';
import 'package:beauty_saloon/localization/language/languages.dart';
import 'package:beauty_saloon/model/CountriesAndCitiesModel.dart';
import 'package:beauty_saloon/model/city_model.dart';
import 'package:beauty_saloon/model/countries_model.dart';
import 'package:beauty_saloon/model/service.dart';
import 'package:beauty_saloon/model/service_data.dart';
import 'package:beauty_saloon/utils/app_constants.dart';
import 'package:beauty_saloon/utils/color_constants.dart';
import 'package:beauty_saloon/utils/shared_prefs.dart';
import 'package:beauty_saloon/utils/static_data.dart';
import 'package:beauty_saloon/utils/styles.dart';
import 'package:beauty_saloon/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_range_slider/flutter_range_slider.dart' as frs;
import 'package:http/http.dart' as http;


class FilterScreen extends StatefulWidget {
  @override
  _FilterScreenState createState() => _FilterScreenState();
}

class _FilterScreenState extends State<FilterScreen> {
  RangeValues values = RangeValues(10, 100);

  double minPrice = 0;
  double maxPrice = 3000;
  /*double _lowerValue = 0;
  double _upperValue = 1000;*/
  double _lowerValue;
  double _upperValue;

  //countries lsit
  Dialog countryDialog;
  List<String> countryList = [];
  String country = 'Select Country';

  //cities list
  Dialog cityDialog;
  List<String> cityList = [];
  String city = 'Select City';

  //services
  Dialog servicesDialog;
  List<ServiceModel> servicesList = [];
  String selectedServices = '';
  String services = 'Select Service Type';

  //promotion type
  Dialog promotionDialog;
  List<String> _promotionList = [];
  String promotion = 'Offers / Packages';

  //sort by dialog
  Dialog sortDialog;
  List<String> _sortList = [];
  String sortBy = 'Sort By';


  //promotion type
  Dialog serviceTypeDialog;
  List<String> _serviceTypeList = [];
  String serviceTypeValue = 'Service Type';



  //countries and cities
  CountriesModel selectedCountry;
  CityModel selectedCity;
  CountriesAndCitiesModel countriesAndCitiesModel;
  List<CityModel> _citiesList = [];

  bool isLoading = true;
  bool isAssignedValues = false;

  @override
  void initState() {
    getCountryList();
    getCityList();

    getServicesList();
    getServiceTypeList();

    getPromotionList();
    getSortList();

    _getCountriesAndCities();

    /*StaticData.startPrice = StaticData.startPrice == '' ? _lowerValue.toString() : StaticData.startPrice;
    StaticData.endPrice = StaticData.endPrice == '' ? _upperValue.toString() : StaticData.endPrice;*/

    _lowerValue = double.parse(StaticData.startPrice);
    _upperValue = double.parse(StaticData.endPrice);

    //country = StaticData.countryName == '' ? 'Select Country' : StaticData.countryName;
    //city = StaticData.cityName == '' ? 'Select City' : StaticData.cityName;
    //services = StaticData.serviceTypeName == '' ? 'Select Service Type' : StaticData.serviceTypeName;


    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if(!isAssignedValues) {
      country = StaticData.countryName == '' ? Languages.of(context).selectCountryInFilter : StaticData.countryName;
      city = StaticData.cityName == '' ? Languages.of(context).selectCityInFilter : StaticData.cityName;
      services = StaticData.serviceTypeName == '' ? Languages.of(context).selectServiceTypeInFilter : StaticData.serviceTypeName;
    }


  }


  @override
  Widget build(BuildContext context) {
    isAssignedValues = true;
    return Scaffold(
      backgroundColor: ColorConstants.bgColor,
      /*appBar: CustomAppBar(
        title: Languages.of(context).lableFilterScreen,
      ),*/
      body: SafeArea(
        child: isLoading ? Utils.buildLoading() : SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              //country
              filterSection(context, Languages.of(context).countriesListTitle, country, () {
                print('country dropdown button clicked');

                displayCountryDialog();
              }),

              SizedBox(
                height: 8,
              ),

              //city
              filterSection(context, Languages.of(context).citiesListTitle, city, () {
                print('city dropdown button clicked');

                //open city dialog
                displayCityDialog();
              }),

              SizedBox(
                height: 8,
              ),

              //services
              filterSection(context, Languages.of(context).selectServicesTitle, services, () {
                print('services dropdown button clicked');

                //displayServicesDialog();
                displayServiceTypeDialog();
              }),

              //promotion
              /*
              SizedBox(
                height: 8,
              ),

              filterSection(context, Languages.of(context).promotionTypeTitle, promotion, () {
                displayPromotionDialog();
              }),
              */

              SizedBox(
                height: 8,
              ),

              priceSection(context),

              //sort by
              /*
              SizedBox(
                height: 8,
              ),

              filterSection(context, Languages.of(context).sortByTitle, sortBy, () {
                //open sort dialog
                displaySortDialog();
              }),
              */


              SizedBox(
                height: 8,
              ),

              //clear filter and filter buttons row
              Container(
                color: ColorConstants.whiteColor,
                padding: EdgeInsets.all(16.0),
                child: Row(
                  children: [
                    Expanded(
                        child: CustomButton3(
                      text: Languages.of(context).clearFilterButtonText,
                      callback: () {

                        StaticData.countryName = '';
                        StaticData.cityName = '';
                        StaticData.serviceTypeName = '';
                        StaticData.startPrice = '0';
                        StaticData.endPrice = '1000';


                        Navigator.pop(context, 0);
                      },
                    )),
                    Expanded(
                        child: CustomButton2(
                      text: Languages.of(context).filterButtonText,
                      callback: () {

                        Navigator.pop(context, 1);
                      },
                    )),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget priceSection(BuildContext context) {
    return Container(
      color: ColorConstants.whiteColor,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          //price
          Container(
            width: MediaQuery.of(context).size.width,
            color: ColorConstants.whiteColor,
            padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 16),
            child: Row(
              children: [
                Text(Languages.of(context).priceTitle, style: mediumTextStyleBlack),
                SizedBox(width: 24),
                Text('${_lowerValue.toStringAsFixed(1)} SAR - ${_upperValue.toStringAsFixed(1)} SAR',
                    style: normalTextStyleGrey),
              ],
            ),
          ),

          Divider(
            height: 0,
            color: ColorConstants.dividerColor,
          ),

          //price range slider
          Padding(
            padding: EdgeInsets.symmetric(vertical: 16.0),
            child: SliderTheme(
              data: SliderTheme.of(context).copyWith(
                activeTrackColor: ColorConstants.primaryColor,
                inactiveTrackColor: ColorConstants.greyColor,
                thumbColor: ColorConstants.primaryColor,
                thumbShape: RoundSliderThumbShape(enabledThumbRadius: 10),
              ),
              child: frs.RangeSlider(
                min: minPrice,
                max: maxPrice,
                lowerValue: _lowerValue,
                upperValue: _upperValue,
                divisions: 50,
                showValueIndicator: true,
                valueIndicatorMaxDecimals: 4,
                onChanged: (double newLowerValue, double newUpperValue) {
                  setState(() {
                    _lowerValue = newLowerValue;
                    _upperValue = newUpperValue;
                  });


                  StaticData.startPrice = _lowerValue.toString();
                  StaticData.endPrice = _upperValue.toString();

                },
                onChangeStart:
                    (double startLowerValue, double startUpperValue) {
                  print(
                      'Started with values: $startLowerValue and $startUpperValue');
                },
                onChangeEnd: (double newLowerValue, double newUpperValue) {
                  print('Ended with values: $newLowerValue and $newUpperValue');
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget filterSection(BuildContext context, String title, String selectedValue,
      VoidCallback callback) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        //title
        Container(
          width: MediaQuery.of(context).size.width,
          color: ColorConstants.whiteColor,
          padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 16),
          child: Text(title, style: mediumTextStyleBlack),
        ),

        Divider(
          height: 0,
          color: ColorConstants.dividerColor,
        ),

        //dialog row
        InkWell(
          onTap: () {
            //open countries dialog
            callback();
          },
          child: Container(
            color: ColorConstants.whiteColor,
            padding: EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(child: Text(selectedValue, style: normalTextStyleGrey)),
                Icon(
                  Icons.arrow_drop_down_outlined,
                  color: ColorConstants.greyColor,
                  size: 32,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  displayCountryDialog() {
    countryDialog = Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4.0)),
      child: Container(
        width: MediaQuery.of(context).size.width,
        //height: MediaQuery.of(context).size.height / 4.5,
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
                      setState(() {
                        //country = countryList[index];
                        country = countriesAndCitiesModel.data[index].countryName;
                        StaticData.countryId = countriesAndCitiesModel.data[index].id.toString();
                        StaticData.countryName = countriesAndCitiesModel.data[index].countryName;
                      });


                      if(_citiesList != null) {
                        _citiesList.clear();
                      }

                      setState(() {
                        _citiesList.addAll(countriesAndCitiesModel.data[index].city);
                      });



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

  getCountryList() {
    countryList.add('Saudi Arabia');
    countryList.add('Bahrain');
  }

  displayCityDialog() {
    cityDialog = Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4.0)),
      child: Container(
        width: MediaQuery.of(context).size.width,
        //height: MediaQuery.of(context).size.height / 3.5,
        height: _citiesList.length == 1 ? 120 :_citiesList.length * 70.0,
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
              //itemCount: cityList.length,
              itemCount: _citiesList.length,
              shrinkWrap: true,
              primary: false,
              itemBuilder: (BuildContext context, int index) {
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: InkWell(
                    onTap: () {
                      /*setState(() {
                        city = cityList[index];
                      });*/


                      setState(() {
                        city = _citiesList[index].cityName;
                        selectedCity = _citiesList[index];
                        StaticData.cityId = _citiesList[index].id.toString();
                        StaticData.cityName = _citiesList[index].cityName;
                        Languages.of(context)
                            .setAreaValue(_citiesList[index].cityName);
                      });

                      SharedPref.saveCitiesList(AppConstants.prefSelectedCountryCites, _citiesList);


                      Navigator.pop(context);
                    },
                    child: Center(
                        child: Text(
                      //cityList[index],
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
    );

    showDialog(context: context, builder: (BuildContext context) => cityDialog);
  }

  getCityList() {
    cityList.add('Al Khobar');
    cityList.add('Dammam');
    cityList.add(
      'Al Qatif - Sihat',
    );
  }

  displayServicesDialog() {

    showDialog(
        context: context,
        builder: (BuildContext context) {
          return StatefulBuilder(
            builder: (context, setState) {
              return Dialog(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4.0)),
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height / 1.2,
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
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              IconButton(
                                icon: Icon(Icons.arrow_back,
                                    color: ColorConstants.whiteColor),
                                onPressed: () {

                                  /*setState((){

                                  });*/

                                  uncheckAllSelectedServices();

                                  selectedServices = 'Service Type';

                                  Navigator.pop(context);
                                },
                              ),
                              Text(
                                'Service Type',
                                style: TextStyle(
                                    fontFamily: 'Quicksand',
                                    fontSize: 22,
                                    color: ColorConstants.whiteColor,
                                    fontWeight: FontWeight.normal),
                              ),
                              IconButton(
                                icon: Icon(Icons.check, color: ColorConstants.whiteColor),
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                              ),
                            ],
                          ),
                        ),

                        //services list
                        ListView.builder(
                          scrollDirection: Axis.vertical,
                          itemCount: servicesList.length,
                          shrinkWrap: true,
                          primary: false,
                          itemBuilder: (BuildContext context, int index) {
                            return Container(
                                color: ColorConstants.greyColor,
                                //padding: EdgeInsets.symmetric(vertical: 8.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 8.0, vertical: 8.0),
                                      child: Text(
                                        servicesList[index].category,
                                        style: TextStyle(
                                          fontFamily: 'Quicksand',
                                          fontSize: 20,
                                        ),
                                      ),
                                    ),
                                    ListView.builder(
                                      scrollDirection: Axis.vertical,
                                      itemCount:
                                      servicesList[index].servicesList.length,
                                      shrinkWrap: true,
                                      primary: false,
                                      itemBuilder:
                                          (BuildContext context, int servicesIndex) {
                                        return Container(
                                          color: ColorConstants.whiteColor,
                                          child: InkWell(
                                            onTap: () {


                                              setState(() {
                                                servicesList[index]
                                                    .servicesList[servicesIndex]
                                                    .isSelected =
                                                !servicesList[index]
                                                    .servicesList[servicesIndex]
                                                    .isSelected;

                                                /*selectedServices = selectedServices + servicesList[index]
                                                    .servicesList[servicesIndex].title;
                                                selectedServices = selectedServices + ' ';*/

                                                if(selectedServices == 'Select Services') {
                                                  selectedServices = servicesList[index]
                                                      .servicesList[servicesIndex].title;
                                                  selectedServices = selectedServices + ' ';
                                                }
                                                else {
                                                  selectedServices = selectedServices + servicesList[index]
                                                      .servicesList[servicesIndex].title;
                                                  selectedServices = selectedServices + ' ';
                                                }

                                              });






                                            },
                                            child: Column(
                                              crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                              children: [
                                                Padding(
                                                  padding: EdgeInsets.symmetric(
                                                      vertical: 8.0, horizontal: 8.0),
                                                  child: Row(
                                                    mainAxisAlignment:
                                                    MainAxisAlignment.spaceBetween,
                                                    children: [
                                                      Text(servicesList[index]
                                                          .servicesList[servicesIndex]
                                                          .title),
                                                      Visibility(
                                                        visible: servicesList[index]
                                                            .servicesList[servicesIndex]
                                                            .isSelected,
                                                        child: Icon(Icons.check,
                                                            color:
                                                            ColorConstants.black),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                Visibility(
                                                  visible: servicesIndex ==
                                                      servicesList[index]
                                                          .servicesList
                                                          .length -
                                                          1
                                                      ? false
                                                      : true,
                                                  child: Divider(
                                                    color: ColorConstants.dividerColor,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                  ],
                                ));
                          },
                        ),

                      ],
                    ),
                  ),
                ),
              );
            },
          );
        }).then((value) {

          print('services dialog closed');
          print('selected servies: $selectedServices');

          setState(() {

            services = selectedServices;

          });

    });
  }

  getServicesList() {
    //hair
    List<ServiceData> hairServicesList = [];

    hairServicesList.add(ServiceData('Hair Cutting', false));
    hairServicesList.add(ServiceData('Hair Coloring', false));
    hairServicesList.add(ServiceData('Hair Styling', false));
    hairServicesList.add(ServiceData('Hair Extensions', false));
    hairServicesList.add(ServiceData('Hair Treatments', false));
    hairServicesList.add(ServiceData('Other Hair Servoces', false));

    servicesList.add(ServiceModel('Hair', hairServicesList));

    //face
    List<ServiceData> faceServicesList = [];
    faceServicesList.add(ServiceData('Make Up', false));
    faceServicesList.add(ServiceData('Facial Sevices', false));
    faceServicesList.add(ServiceData('Eyelashes', false));
    faceServicesList.add(ServiceData('Face Hair', false));
    faceServicesList.add(ServiceData('Eyebrows', false));

    servicesList.add(ServiceModel('Face', faceServicesList));

    //nails
    List<ServiceData> nailServicesList = [];
    nailServicesList.add(ServiceData('Manicure & Pedicure', false));
    nailServicesList.add(ServiceData('Manicure', false));
    nailServicesList.add(ServiceData('Pedicure', false));
    nailServicesList.add(ServiceData('Nail Extensions', false));
    nailServicesList.add(ServiceData('Nail Polish', false));
    nailServicesList.add(ServiceData('Nail Designs', false));
    nailServicesList.add(ServiceData('Other Nail Services', false));

    servicesList.add(ServiceModel('Nails', nailServicesList));

    //body
    List<ServiceData> bodyServicesList = [];
    bodyServicesList.add(ServiceData('Body Hair Removal', false));

    servicesList.add(ServiceModel('Body Hair Removal', nailServicesList));

    //Henna
    List<ServiceData> hennaList = [];
    hennaList.add(ServiceData('Henna Tattoo', false));
    hennaList.add(ServiceData('Tattoo', false));

    servicesList.add(ServiceModel('Henna', hennaList));

    //massage
    List<ServiceData> massageServicesList = [];
    massageServicesList.add(ServiceData('Body Massage', false));
    massageServicesList.add(ServiceData('Shoulders Massage', false));
    massageServicesList.add(ServiceData('Head Massage', false));
    massageServicesList.add(ServiceData('Foot Massage', false));

    servicesList.add(ServiceModel('Massage', massageServicesList));

    //baths
    List<ServiceData> bathServicesList = [];
    bathServicesList.add(ServiceData('Baths', false));

    servicesList.add(ServiceModel('Bath', bathServicesList));

    //bridal
    List<ServiceData> bridalServicesList = [];
    bridalServicesList.add(ServiceData('Bridal', false));

    servicesList.add(ServiceModel('Bridal', bridalServicesList));

    //Kids Services
    List<ServiceData> kidsServicesList = [];
    kidsServicesList.add(ServiceData('Kids Hair', false));
    kidsServicesList.add(ServiceData('Kids Nails', false));
    kidsServicesList.add(ServiceData('Other Kids Services', false));

    servicesList.add(ServiceModel('Kids Services', kidsServicesList));

    //skin treatments
    List<ServiceData> skinServicesList = [];
    skinServicesList.add(ServiceData('Skin Treatments', false));

    servicesList.add(ServiceModel('Skin Treatments', skinServicesList));

    //home services
    List<ServiceData> homeServicesList = [];
    homeServicesList.add(ServiceData('Home Services', false));

    servicesList.add(ServiceModel('Home Servies', homeServicesList));
  }

  displayPromotionDialog() {
    promotionDialog = Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4.0)),
      child: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height / 4.5,
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
                    'Promotion Type',
                    style: TextStyle(
                        fontFamily: 'Quicksand',
                        fontSize: 22,
                        color: ColorConstants.whiteColor,
                        fontWeight: FontWeight.normal),
                  ),
                ),
              ),

              //promotion list
              ListView.builder(
                scrollDirection: Axis.vertical,
                itemCount: _promotionList.length,
                shrinkWrap: true,
                primary: false,
                itemBuilder: (BuildContext context, int index) {
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: InkWell(
                      onTap: () {
                        setState(() {
                          promotion = _promotionList[index];
                        });

                        Navigator.pop(context);
                      },
                      child: Center(
                          child: Text(
                        _promotionList[index],
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

    showDialog(
        context: context, builder: (BuildContext context) => promotionDialog);
  }

  displayServiceTypeDialog() {

    serviceTypeDialog = Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4.0)),
      child: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height / 4.5,
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
                    'Service Type',
                    style: TextStyle(
                        fontFamily: 'Quicksand',
                        fontSize: 22,
                        color: ColorConstants.whiteColor,
                        fontWeight: FontWeight.normal),
                  ),
                ),
              ),

              //promotion list
              ListView.builder(
                scrollDirection: Axis.vertical,
                itemCount: _serviceTypeList.length,
                shrinkWrap: true,
                primary: false,
                itemBuilder: (BuildContext context, int index) {
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: InkWell(
                      onTap: () {
                        setState(() {
                          serviceTypeValue = _serviceTypeList[index];
                          services = _serviceTypeList[index];
                          StaticData.serviceType = _serviceTypeList[index].toLowerCase();
                          StaticData.serviceTypeName = _serviceTypeList[index];
                        });

                        SharedPref.save(AppConstants.prefServiceType, _serviceTypeList[index].toLowerCase());

                        Navigator.pop(context);
                      },
                      child: Center(
                          child: Text(
                            _serviceTypeList[index],
                            //serviceType,
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

    showDialog(context: context, builder: (BuildContext context) => serviceTypeDialog);

  }

  getServiceTypeList() {
    _serviceTypeList.add('Salon');
    _serviceTypeList.add('Home');
  }


  getPromotionList() {
    _promotionList.add('OFFER');
    _promotionList.add('PACKAGE');
  }

  displaySortDialog() {
    sortDialog = Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4.0)),
      child: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height / 4.5,
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
                    'Sort By',
                    style: TextStyle(
                        fontFamily: 'Quicksand',
                        fontSize: 22,
                        color: ColorConstants.whiteColor,
                        fontWeight: FontWeight.normal),
                  ),
                ),
              ),

              //sort list
              ListView.builder(
                scrollDirection: Axis.vertical,
                itemCount: _sortList.length,
                shrinkWrap: true,
                primary: false,
                itemBuilder: (BuildContext context, int index) {
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: InkWell(
                      onTap: () {
                        setState(() {
                          sortBy = _sortList[index];
                        });

                        Navigator.pop(context);
                      },
                      child: Center(
                          child: Text(
                        _sortList[index],
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

    showDialog(context: context, builder: (BuildContext context) => sortDialog);
  }

  getSortList() {
    _sortList.add('Most Booked');
    _sortList.add('Most Rated');
  }

  uncheckAllSelectedServices() {
    for(int i=0; i<servicesList.length; i++) {
      for(int j=0; j<servicesList[i].servicesList.length; j++) {
        servicesList[i].servicesList[j].isSelected = false;
      }
    }
  }

  void _getCountriesAndCities() async {

    String url = '${AppConstants.baseURL}/api/countries';

    // make get request
    http.Response response = await http.get(url, headers: {"APP_KEY": "HGwADiSjyHSAWZwTZRNXfNoJYZVyPf38x4Aq6jBaDrIyH76FKeNDBcy1UrEq0FInDgC9SWRMVIlmZ4jX"});

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


}
