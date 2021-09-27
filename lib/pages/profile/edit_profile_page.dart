import 'dart:convert';
import 'dart:io';
import 'package:beauty_saloon/components/custom_button_2.dart';
import 'package:beauty_saloon/localization/language/languages.dart';
import 'package:beauty_saloon/model/CountriesAndCitiesModel.dart';
import 'package:beauty_saloon/model/city_model.dart';
import 'package:beauty_saloon/model/countries_model.dart';
import 'package:beauty_saloon/model/otp_response.dart';
import 'package:beauty_saloon/model/update_profile_response.dart';
import 'package:beauty_saloon/model/update_user_profile_data.dart';
import 'package:beauty_saloon/screens/home/home_screen.dart';
import 'package:beauty_saloon/screens/sign_in/sign_in_screen.dart';
import 'package:beauty_saloon/utils/app_constants.dart';
import 'package:beauty_saloon/utils/color_constants.dart';
import 'package:beauty_saloon/utils/shared_prefs.dart';
import 'package:beauty_saloon/utils/static_data.dart';
import 'package:beauty_saloon/utils/styles.dart';
import 'package:beauty_saloon/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart' as myPath;


class EditProfilePage extends StatefulWidget {

  final OTPResponse userData;
  EditProfilePage({@required this.userData});

  @override
  _EditProfilePageState createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {

  TextEditingController _nameController;
  TextEditingController _emailController;
  TextEditingController _phoneController;

  List<String> genderList = [];

  File _image;

  DateTime selectedDate;

  String currentDate;
  String country;
  String city;
  String gender;

  Dialog genderDialog;
  Dialog countryDialog;
  Dialog cityDialog;

  //countries and cities
  CountriesAndCitiesModel countriesAndCitiesModel;
  CountriesModel selectedCountry;
  List<CityModel> _citiesList = [];

  CityModel selectedCity;

  bool formValidate = false;
  bool isLoading = true;
  bool isLoading2 = false;


  @override
  void initState() {

    _nameController = TextEditingController(text: widget.userData.data.name);
    _emailController = TextEditingController(text: widget.userData.data.email);
    _phoneController = TextEditingController(text: widget.userData.data.phone);

    country = widget.userData.data.country.countryName;
    city = widget.userData.data.city.cityName;
    currentDate = widget.userData.data.birthDate;
    gender = widget.userData.data.gender;

    getGendersList();
    _getCountriesAndCities();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorConstants.bgColor,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: isLoading ? Utils.buildLoading() : Container(
              padding: EdgeInsets.all(16.0),
              child: Stack(
                alignment: AlignmentDirectional.center,
                children: [

                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [

                      //profile image, name and edit button
                      Card(
                        child: Container(
                          padding: EdgeInsets.all(16.0),
                          child: Row(
                            children: [

                              //image
                              InkWell(
                                onTap: () {

                                  //take picture from camera or from gallery
                                  _showPicker(context);

                                },
                                child: _image != null ? Container(
                                  width: 70.0,
                                  height: 70.0,
                                  decoration: new BoxDecoration(
                                    shape: BoxShape.circle,
                                    image: new DecorationImage(
                                      fit: BoxFit.fill,
                                      image: FileImage(_image),),
                                  ),) : Container(
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
                                      image: NetworkImage(widget.userData.data.image),
                                    ),
                                  ),
                                ),
                              ),

                              SizedBox(width: 16),
                              //username
                              Text(widget.userData.data.name, style: normalTextStyleBlackBold),

                              Expanded(child: SizedBox()),

                            ],
                          ),
                        ),
                      ),

                      SizedBox(
                        height: 20,
                      ),

                      Text(Languages.of(context).editNameField, style: normalTextStyleBlackBold),

                      SizedBox(
                        height: 8,
                      ),

                      Container(
                          width: double.maxFinite,
                          height: 50,
                          padding: EdgeInsets.fromLTRB(20.0, 16.0, 16.0, 12.0),
                          decoration: BoxDecoration(
                              color: ColorConstants.greyColor.withOpacity(0.2),
                              borderRadius: BorderRadius.all(Radius.circular(16.0),)
                          ),
                          child: TextFormField(
                            controller: _nameController,
                            keyboardType: TextInputType.text,
                            obscureText: false,
                            decoration: InputDecoration(
                              hintText: Languages.of(context).nameHintTextEditProfile,
                              border: InputBorder.none,
                              hintStyle: TextStyle(
                                  color: ColorConstants.lightGreyTextColor, fontSize: 13),
                              labelStyle: TextStyle(
                                  color: ColorConstants.lightGreyTextColor, fontSize: 13),
                            ),
                          )
                      ),

                      SizedBox(
                        height: 4,
                      ),

                      Visibility(
                        visible: formValidate && _nameController.text.isEmpty ? true : false,
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 28.0),
                          child: Text(
                            Languages.of(context).nameFieldError,
                            style: TextStyle(
                              fontSize: 12,
                              color: ColorConstants.redColor,
                            ),
                          ),
                        ),
                      ),


                      /*SizedBox(
                    height: 16,
                  ),

                  Text('Edit Email', style: normalTextStyleBlackBold),

                  SizedBox(
                    height: 8,
                  ),

                  Container(
                      width: double.maxFinite,
                      height: 50,
                      padding: EdgeInsets.fromLTRB(20.0, 16.0, 16.0, 12.0),
                      decoration: BoxDecoration(
                          color: ColorConstants.greyColor.withOpacity(0.2),
                          borderRadius: BorderRadius.all(Radius.circular(16.0),)
                      ),
                      child: TextFormField(
                        controller: _emailController,
                        keyboardType: TextInputType.text,
                        obscureText: false,
                        decoration: InputDecoration(
                          hintText: 'Email',
                          border: InputBorder.none,
                          hintStyle: TextStyle(
                              color: ColorConstants.lightGreyTextColor, fontSize: 13),
                          labelStyle: TextStyle(
                              color: ColorConstants.lightGreyTextColor, fontSize: 13),
                        ),
                      )
                  ),

                  SizedBox(
                    height: 4,
                  ),

                  Visibility(
                    visible: formValidate && _emailController.text.isEmpty ? true : false,
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 28.0),
                      child: Text(
                        'Please enter your email',
                        style: TextStyle(
                          fontSize: 12,
                          color: ColorConstants.redColor,
                        ),
                      ),
                    ),
                  ),

                  SizedBox(
                    height: 16,
                  ),

                  Text('Edit Phone', style: normalTextStyleBlackBold),

                  SizedBox(
                    height: 8,
                  ),

                  Container(
                      width: double.maxFinite,
                      height: 50,
                      padding: EdgeInsets.fromLTRB(20.0, 16.0, 16.0, 12.0),
                      decoration: BoxDecoration(
                          color: ColorConstants.greyColor.withOpacity(0.2),
                          borderRadius: BorderRadius.all(Radius.circular(16.0),)
                      ),
                      child: TextFormField(
                        controller: _phoneController,
                        keyboardType: TextInputType.text,
                        obscureText: false,
                        decoration: InputDecoration(
                          hintText: 'Phone',
                          border: InputBorder.none,
                          hintStyle: TextStyle(
                              color: ColorConstants.lightGreyTextColor, fontSize: 13),
                          labelStyle: TextStyle(
                              color: ColorConstants.lightGreyTextColor, fontSize: 13),
                        ),
                      )
                  ),

                  SizedBox(
                    height: 4,
                  ),

                  Visibility(
                    visible: formValidate && _phoneController.text.isEmpty ? true : false,
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 28.0),
                      child: Text(
                        'Please enter your phone number',
                        style: TextStyle(
                          fontSize: 12,
                          color: ColorConstants.redColor,
                        ),
                      ),
                    ),
                  ),*/

                      SizedBox(
                        height: 16,
                      ),

                      Text(Languages.of(context).dobFieldHeadingProfile, style: normalTextStyleBlackBold),

                      SizedBox(
                        height: 8,
                      ),

                      InkWell(
                        onTap: () async {

                          //open date picker
                          final DateTime picked = await showDatePicker(
                            context: context,
                            builder: (BuildContext context, Widget child) {
                              return Theme(
                                data: ThemeData.dark().copyWith(
                                  colorScheme: ColorScheme.dark(
                                    surface: ColorConstants.primaryColor,
                                  ),
                                ),
                                child: child,
                              );
                            },
                            initialDate: DateTime.now(),
                            firstDate: DateTime(1960),
                            lastDate: DateTime.now(),
                          );

                          if (picked != null && picked != selectedDate) {
                            setState(() {
                              selectedDate = picked;
                              getCurrentDate(selectedDate);
                            });
                          }


                        },
                        child: Container(
                          width: double.maxFinite,
                          height: 50,
                          padding: EdgeInsets.all(16.0),
                          decoration: BoxDecoration(
                              color: ColorConstants.greyColor.withOpacity(0.2),
                              borderRadius: BorderRadius.all(Radius.circular(16.0),)
                          ),
                          child: Row(
                            children: [
                              Text(currentDate),
                            ],
                          ),
                        ),
                      ),

                      SizedBox(
                        height: 4,
                      ),

                      Visibility(
                        visible: formValidate && currentDate.isEmpty ? true : false,
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 28.0),
                          child: Text(
                            Languages.of(context).dobError,
                            style: TextStyle(
                              fontSize: 12,
                              color: ColorConstants.redColor,
                            ),
                          ),
                        ),
                      ),


                      SizedBox(
                        height: 16,
                      ),

                      Text(Languages.of(context).editGenderHeading, style: normalTextStyleBlackBold),
                      SizedBox(
                        height: 8.0,
                      ),

                      //gender
                      InkWell(
                        onTap: () {

                          //open gender dialog
                          displayGenderDialog();

                        },
                        child: Container(
                          width: double.maxFinite,
                          height: 50,
                          padding: EdgeInsets.all(16.0),
                          decoration: BoxDecoration(
                              color: ColorConstants.greyColor.withOpacity(0.2),
                              borderRadius: BorderRadius.all(Radius.circular(16.0),)
                          ),
                          child: Row(
                            children: [
                              Text(gender),
                            ],
                          ),
                        ),
                      ),

                      SizedBox(
                        height: 4,
                      ),

                      Visibility(
                        visible: formValidate && gender.isEmpty ? true : false,
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 28.0),
                          child: Text(
                            Languages.of(context).genderError,
                            style: TextStyle(
                              fontSize: 12,
                              color: ColorConstants.redColor,
                            ),
                          ),
                        ),
                      ),



                      SizedBox(
                        height: 16,
                      ),



                      Text(Languages.of(context).editCountryHeading, style: normalTextStyleBlackBold),

                      SizedBox(
                        height: 8,
                      ),

                      InkWell(
                        onTap: () {

                          //open country dialog
                          displayCountryDialog();

                        },
                        child: Container(
                          width: double.maxFinite,
                          height: 50,
                          padding: EdgeInsets.all(16.0),
                          decoration: BoxDecoration(
                              color: ColorConstants.greyColor.withOpacity(0.2),
                              borderRadius: BorderRadius.all(Radius.circular(16.0),)
                          ),
                          child: Row(
                            children: [
                              Text(country),
                            ],
                          ),
                        ),
                      ),

                      SizedBox(
                        height: 4,
                      ),

                      Visibility(
                        visible: formValidate && country.isEmpty ? true : false,
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 28.0),
                          child: Text(
                            Languages.of(context).countryError,
                            style: TextStyle(
                              fontSize: 12,
                              color: ColorConstants.redColor,
                            ),
                          ),
                        ),
                      ),


                      SizedBox(
                        height: 16,
                      ),

                      Text(Languages.of(context).editCityHeading, style: normalTextStyleBlackBold),

                      SizedBox(
                        height: 8,
                      ),

                      InkWell(
                        onTap: () {

                          //open city dialog
                          displayCityDialog();

                        },
                        child: Container(
                          width: double.maxFinite,
                          height: 50,
                          padding: EdgeInsets.all(16.0),
                          decoration: BoxDecoration(
                              color: ColorConstants.greyColor.withOpacity(0.2),
                              borderRadius: BorderRadius.all(Radius.circular(16.0),)
                          ),
                          child: Row(
                            children: [
                              Text(city),
                            ],
                          ),
                        ),
                      ),

                      SizedBox(
                        height: 4,
                      ),

                      Visibility(
                        visible: formValidate && city.isEmpty ? true : false,
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 28.0),
                          child: Text(
                            Languages.of(context).cityError,
                            style: TextStyle(
                              fontSize: 12,
                              color: ColorConstants.redColor,
                            ),
                          ),
                        ),
                      ),


                    ],
                  ),

                  Visibility(
                    visible: isLoading2,
                    child: Utils.buildLoading(),
                  ),


                ],
              )
            ),
          ),
        )
      ),
      bottomNavigationBar: Container(
        padding: EdgeInsets.all(16.0),
        child: CustomButton2(
          text: Languages.of(context).uploadProfileButtonText,
          callback: () {

            setState(() {
              formValidate = true;
            });

            if(_nameController.text.isNotEmpty) {

              _performUpdateUserProfile();

            }


          },
        ),
      ),
    );
  }


  void _showPicker(context) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return SafeArea(
            child: Container(
              child: new Wrap(
                children: <Widget>[
                  new ListTile(
                      leading: new Icon(Icons.photo_library),
                      title: new Text('Photo Library'),
                      onTap: () {
                        _imgFromGallery();
                        Navigator.of(context).pop();
                      }),
                  new ListTile(
                    leading: new Icon(Icons.photo_camera),
                    title: new Text('Camera'),
                    onTap: () {
                      _imgFromCamera();
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              ),
            ),
          );
        });
  }

  _imgFromCamera() async {
    File image = await ImagePicker.pickImage(
        source: ImageSource.camera, imageQuality: 50);

    setState(() {
      _image = image;
    });
  }

  _imgFromGallery() async {
    File image = await ImagePicker.pickImage(
        source: ImageSource.gallery, imageQuality: 50);

    setState(() {
      _image = image;
    });
  }

  getCurrentDate(DateTime now) {
    var formatter = new DateFormat('yyyy-MM-dd');
    String formattedDate = formatter.format(now);

    currentDate = formattedDate;
  }

  displayGenderDialog() {
    genderDialog = Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4.0)),
      child: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height / 4.0,
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
                  'Select Gender',
                  style: TextStyle(
                      fontFamily: 'Quicksand',
                      fontSize: 22,
                      color: ColorConstants.whiteColor,
                      fontWeight: FontWeight.normal),
                ),
              ),
            ),

            //gender list
            ListView.builder(
                scrollDirection: Axis.vertical,
                itemCount: genderList.length,
                shrinkWrap: true,
                primary: false,
                itemBuilder: (BuildContext context, int index) {
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: InkWell(
                      onTap: () {
                        setState(() {
                          gender = genderList[index];
                        });

                        Navigator.pop(context);
                      },
                      child: Center(
                          child: Text(
                            genderList[index],
                            style: TextStyle(
                              fontFamily: 'Quicksand',
                              fontSize: 20,
                            ),
                          )),
                    ),
                  );
                }),
          ],
        ),
      ),
    );

    showDialog(
        context: context, builder: (BuildContext context) => genderDialog);
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
                        selectedCountry = countriesAndCitiesModel.data[index];

                        if(_citiesList != null) {
                          _citiesList.clear();
                        }

                        setState(() {
                          _citiesList.addAll(countriesAndCitiesModel.data[index].city);
                        });


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


      for(int i=0; i<countriesAndCitiesModel.data.length; i++) {
        if(countriesAndCitiesModel.data[i].id.toString() == widget.userData.data.countryId) {

          if(_citiesList != null) {
            _citiesList.clear();
          }

          //set previously selected country
          setState(() {
            selectedCountry = countriesAndCitiesModel.data[i];
            _citiesList.addAll(countriesAndCitiesModel.data[i].city);
            country = countriesAndCitiesModel.data[i].countryName;
          });

          //set previously selected city
          for(int j=0; j<_citiesList.length; j++) {
            if(_citiesList[j].id.toString() == widget.userData.data.cityId) {

              setState(() {
                selectedCity = _citiesList[j];
                city = _citiesList[j].cityName;
                isLoading = false;
              });


            }
          }

        }
      }


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

  displayCityDialog() {
    cityDialog = Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4.0)),
      child: Container(
        width: MediaQuery.of(context).size.width,
        //height: MediaQuery.of(context).size.height / 3.5,
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
                //itemCount: cityList.length,
                itemCount: _citiesList.length,
                shrinkWrap: true,
                primary: false,
                itemBuilder: (BuildContext context, int index) {
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: InkWell(
                      onTap: () {
                        setState(() {
                          city = _citiesList[index].cityName;
                          selectedCity = _citiesList[index];
                        });

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

  getGendersList() {
    genderList.add(
      'Male',
    );

    genderList.add(
      'Female',
    );
  }

  Future<UpdateProfileResponse> _updateUserProfileWithImage(UpdateUserProfileData updateUserProfileData) async {

    UpdateProfileResponse updateProfileResponse;

    try {

      var request = http.MultipartRequest(
          'POST',
          Uri.parse('http://projet.ae/salon/api/update-user')
      );

          request.fields.addAll({
            "name":updateUserProfileData.name,
            "birth_date":updateUserProfileData.dob,
            "gender":updateUserProfileData.gender,
            "country_id":updateUserProfileData.countryId,
            "city_id":updateUserProfileData.cityId,
            "user_id": widget.userData.data.id.toString(),
          });

      var headers = {
        'APP_KEY': 'HGwADiSjyHSAWZwTZRNXfNoJYZVyPf38x4Aq6jBaDrIyH76FKeNDBcy1UrEq0FInDgC9SWRMVIlmZ4jX'
      };

      request.files.add(await http.MultipartFile.fromPath('image', '${_image.path}'));
      request.headers.addAll(headers);

      http.StreamedResponse response = await request.send();

      var v = await response.stream.bytesToString();
      print( "status code -> ${response.statusCode}" );
      print( "response -> $v" );

      if (response.statusCode == 200) {

        setState(() {
          isLoading2 = false;
        });

        updateProfileResponse = (UpdateProfileResponse.fromJson(json.decode(v)));
        return updateProfileResponse;

      }
      else {


        setState(() {
          isLoading2 = false;
        });

        print(response.reasonPhrase);
        updateProfileResponse = (UpdateProfileResponse.fromJson(json.decode(v)));
        return updateProfileResponse;

      }


    }
    catch(e) {
      print( "in exception ->$e" );
    }

    return updateProfileResponse;

  }

  Future<UpdateProfileResponse> _updateUserProfileWithoutImage(UpdateUserProfileData updateUserProfileData) async {

    UpdateProfileResponse updateProfileResponse;

    try {

      var request = http.MultipartRequest(
          'POST',
          Uri.parse('${AppConstants.baseURL}/api/update-user'));
      request.fields.addAll({
        "name":updateUserProfileData.name,
        "birth_date":updateUserProfileData.dob,
        "gender":updateUserProfileData.gender,
        "country_id":updateUserProfileData.countryId,
        "city_id":updateUserProfileData.cityId,
        "user_id": widget.userData.data.id.toString(),
      });

      var headers = {
        'APP_KEY': 'HGwADiSjyHSAWZwTZRNXfNoJYZVyPf38x4Aq6jBaDrIyH76FKeNDBcy1UrEq0FInDgC9SWRMVIlmZ4jX'
      };

      request.headers.addAll(headers);

      http.StreamedResponse response = await request.send();

      var v = await response.stream.bytesToString();
      print( "status code -> ${response.statusCode}" );
      print( "response -> $v" );

      if (response.statusCode == 200) {

        setState(() {
          isLoading2 = false;
        });

        updateProfileResponse = (UpdateProfileResponse.fromJson(json.decode(v)));
        return updateProfileResponse;

      }
      else {


        setState(() {
          isLoading2 = false;
        });

        print(response.reasonPhrase);
        updateProfileResponse = (UpdateProfileResponse.fromJson(json.decode(v)));
        return updateProfileResponse;

      }


    }
    catch(e) {
      print( "in exception ->$e" );
    }

    return updateProfileResponse;

  }


  _performUpdateUserProfile() {

    setState(() {
      isLoading2 = true;
    });

    UpdateUserProfileData updateUserProfileData = UpdateUserProfileData(
        _nameController.text,
        currentDate,
        gender,
        selectedCountry.id.toString(),
        selectedCity.id.toString(),
        //_image == null ? widget.userData.data.image : myPath.basename(_image.path)
        ''
    );

    if(_image != null) {
      _updateUserProfileWithImage(updateUserProfileData).then((value) => {

        if(value.status) {
          //save user data to shared pref
          SharedPref.save(AppConstants.user_data, value),
        },

        Fluttertoast.showToast(
            msg: value.message,
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.blue,
            textColor: Colors.white,
            fontSize: 16.0
        ),

        Future.delayed(const Duration(milliseconds: 500), () {
            Navigator.pop(context);
        }),


      });
    }
    else {
      _updateUserProfileWithoutImage(updateUserProfileData).then((value) => {

        if(value.status) {
          //save user data to shared pref
          SharedPref.save(AppConstants.user_data, value),
        },

        Fluttertoast.showToast(
            msg: value.message,
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.blue,
            textColor: Colors.white,
            fontSize: 16.0
        ),

        Future.delayed(const Duration(milliseconds: 500), () {
          Navigator.pop(context);
        }),

      });
    }



  }
  


  @override
  void dispose() {

    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();

    super.dispose();
  }


}
