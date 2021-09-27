import 'dart:convert';
import 'dart:io';
import 'package:beauty_saloon/components/custom_app_bar.dart';
import 'package:beauty_saloon/components/custom_button_1.dart';
import 'package:beauty_saloon/components/custom_textfield.dart';
import 'package:beauty_saloon/components/custom_widgets.dart';
import 'package:beauty_saloon/localization/language/languages.dart';
import 'package:beauty_saloon/model/CountriesAndCitiesModel.dart';
import 'package:beauty_saloon/model/SignUpFormData.dart';
import 'package:beauty_saloon/model/city_model.dart';
import 'package:beauty_saloon/model/countries_model.dart';
import 'package:beauty_saloon/model/sign_up_response.dart';
import 'package:beauty_saloon/screens/otp/otp_screen.dart';
import 'package:beauty_saloon/utils/app_constants.dart';
import 'package:beauty_saloon/utils/color_constants.dart';
import 'package:beauty_saloon/utils/static_data.dart';
import 'package:beauty_saloon/utils/styles.dart';
import 'package:beauty_saloon/utils/utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart' as myPath;


class SignUpScreen extends StatefulWidget {
  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {

  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _emailController = TextEditingController();
  /*final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();*/
  final _countryCodeController = TextEditingController();
  final _phoneNoController = TextEditingController();

  String currentDate;

  String gender;
  String country;
  CountriesModel selectedCountry;
  String city;
  CityModel selectedCity;

  DateTime selectedDate;

  Dialog genderDialog;
  Dialog countryDialog;
  Dialog cityDialog;

  List<String> genderList = [];
  List<String> countryList = [];
  List<String> cityList = [];


  bool formValidate = false;
  bool isLoading = true;
  bool isLoading2 = false;
  bool isCountrySelectedMsg = false;
  bool didPasswordMatched = true;

  //countries and cities
  CountriesAndCitiesModel countriesAndCitiesModel;
  List<CityModel> _citiesList = [];

  //image
  File _image;

  bool setInitialValue = false;

  @override
  void initState() {

    /*currentDate = 'Birthday';
    gender = 'Gender';
    country = 'Country';
    city = 'City';*/



    _getCountriesAndCities();

    getGendersList();

    /*getCountryList();
    getCityList();*/




    super.initState();
  }

  @override
  void didChangeDependencies() {

    super.didChangeDependencies();

    if(!setInitialValue) {

      currentDate = Languages.of(context).currentDateValue;
      gender = Languages.of(context).genderValue;
      country = Languages.of(context).countryValue;
      city = Languages.of(context).cityValue;

    }


  }

  @override
  Widget build(BuildContext context) {

    setInitialValue = true;

    return Scaffold(
      appBar: CustomAppBar(
        title: Languages.of(context).createAccountTitle,
      ),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: isLoading ? Utils.buildLoading() : Form(
              key: formKey,
              child: Builder(
                builder: (cxt) => Stack(
                  alignment: AlignmentDirectional.center,
                  children: [

                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        //avatar row
                        InkWell(
                          onTap: () {
                            //take picture from camera or from gallery
                            _showPicker(context);
                          },
                          child: Padding(
                            padding:
                            EdgeInsets.symmetric(vertical: 16.0, horizontal: 8.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                _image != null ? Container(
                                  width: 70.0,
                                  height: 70.0,
                                  decoration: new BoxDecoration(
                                    shape: BoxShape.circle,
                                    image: new DecorationImage(
                                      fit: BoxFit.fill,
                                      image: FileImage(_image),),
                                  ),) :
                                Container(
                                  width: 70,
                                  height: 70,
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      width: 2,
                                      color: ColorConstants.greyColor,
                                    ),
                                    borderRadius:
                                    BorderRadius.all(Radius.circular(60)),
                                  ),
                                  child: Icon(
                                    Icons.add,
                                    color: ColorConstants.primaryColor,
                                    size: 32,
                                  ),
                                ),
                                SizedBox(
                                  width: 16,
                                ),
                                Text(
                                  Languages.of(context).uploadAnAvatar,
                                  style: normalTextStyleGrey,
                                ),
                              ],
                            ),
                          ),
                        ),

                        CustomWidgets.customDivider(),

                        SizedBox(
                          height: 24,
                        ),

                        //first name, last name row
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 16.0),
                          child: Row(
                            children: [

                              /*Expanded(
                                child: CustomTextField(
                                    _firstNameController,
                                    Languages.of(context).firstNameHint,
                                    Languages.of(context).firstNameHint,
                                    TextInputType.text,
                                    validateFirstName
                                ),
                              ),*/

                              Expanded(
                                child: TextFormField(
                                  controller: _firstNameController,
                                  keyboardType: TextInputType.text,
                                  obscureText: false,
                                  validator: (value) {
                                    if (value.isEmpty) {
                                      //return 'First Name empty';
                                      return Languages.of(context).firstNameEmptyText;
                                    } else if (value.length < 3) {
                                      //return 'First Name short';
                                      return Languages.of(context).firstNameShortText;
                                    }

                                    return null;
                                  },
                                  decoration: InputDecoration(
                                    border: new OutlineInputBorder(
                                    ),
                                    labelText: Languages.of(context).firstNameHint,
                                    hintText: Languages.of(context).firstNameHint,
                                    hintStyle: TextStyle(
                                        color: ColorConstants.lightGreyTextColor, fontSize: 13),
                                    labelStyle: TextStyle(
                                        color: ColorConstants.lightGreyTextColor, fontSize: 13),
                                  ),
                                ),
                              ),

                              SizedBox(
                                width: 8,
                              ),
                              /*Expanded(
                                child: CustomTextField(
                                    _lastNameController,
                                    Languages.of(context).lastNameHint,
                                    Languages.of(context).lastNameHint,
                                    TextInputType.text,
                                    //validateLastName(_lastNameController.text, context)
                                    validateLastName
                                ),
                              ),*/

                              Expanded(
                                child: TextFormField(
                                  controller: _lastNameController,
                                  keyboardType: TextInputType.text,
                                  obscureText: false,
                                  validator: (value) {
                                    if (value.isEmpty) {
                                      //return 'Last Name empty';
                                      return Languages.of(context).lastNameEmptyText;
                                    } else if (value.length < 3) {
                                      //return 'Last Name short';
                                      return Languages.of(context).lastNameShortText;
                                    }

                                    return null;
                                  },
                                  decoration: InputDecoration(
                                    border: new OutlineInputBorder(
                                    ),
                                    labelText: Languages.of(context).lastNameHint,
                                    hintText: Languages.of(context).lastNameHint,
                                    hintStyle: TextStyle(
                                        color: ColorConstants.lightGreyTextColor, fontSize: 13),
                                    labelStyle: TextStyle(
                                        color: ColorConstants.lightGreyTextColor, fontSize: 13),
                                  ),
                                ),
                              ),




                            ],
                          ),
                        ),

                        SizedBox(
                          height: 12,
                        ),

                        //email row
                        /*Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8.0),
                    child: CustomTextfield(
                      _emailController,
                      'Emaiil *',
                      TextInputType.emailAddress,
                    ),
                  ),*/

                        //email field
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 16.0),
                          child: /*CustomTextField(
                              _emailController,
                              Languages.of(context).emailHint,
                              Languages.of(context).emailHint,
                              TextInputType.emailAddress,
                              //validateEmail(_emailController.text, context)
                              validateEmail
                          ),*/
                          TextFormField(
                            controller: _emailController,
                            keyboardType: TextInputType.emailAddress,
                            obscureText: false,
                            validator: (value) {

                              if (value.isEmpty) {
                                return Languages.of(context).emailEmptyText;
                                //return 'Email empty';
                              } else if (Utils.isEmail(value) == false) {
                                return Languages.of(context).invalidEmailText;
                                //return 'Invalid email';
                              }

                              return null;
                            },
                            decoration: InputDecoration(
                              border: new OutlineInputBorder(
                              ),
                              labelText: Languages.of(context).emailHint,
                              hintText: Languages.of(context).emailHint,
                              hintStyle: TextStyle(
                                  color: ColorConstants.lightGreyTextColor, fontSize: 13),
                              labelStyle: TextStyle(
                                  color: ColorConstants.lightGreyTextColor, fontSize: 13),
                            ),
                          ),
                        ),

                        SizedBox(
                          height: 12,
                        ),

                        //password row
                        /*Padding(
                          padding: EdgeInsets.symmetric(horizontal: 16.0),
                          child: CustomTextField(
                            _passwordController,
                            'Password',
                            'Password',
                            TextInputType.text,
                            validatePassword,
                            obscureText: true,
                            onEditingCompleted: () {

                              if(_passwordController.text.isNotEmpty) {

                                if(_passwordController.text != _confirmPasswordController.text) {
                                  setState(() {
                                    didPasswordMatched = false;
                                  });
                                }
                                else {
                                  setState(() {
                                    didPasswordMatched = true;
                                  });
                                }
                              }
                            },
                          ),
                        ),

                        SizedBox(
                          height: 4,
                        ),

                        Visibility(
                          visible: formValidate && !didPasswordMatched  ? true : false,
                          child: Padding(
                            padding: EdgeInsets.symmetric(horizontal: 28.0),
                            child: Text(
                              'Password did not matched with Confirm Password !',
                              style: TextStyle(
                                fontSize: 12,
                                color: ColorConstants.redColor,
                              ),
                            ),
                          ),
                        ),

                        SizedBox(
                          height: 12,
                        ),

                        //confirm password row
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 16.0),
                          child: CustomTextField(
                            _confirmPasswordController,
                            'Confirm Password',
                            'Confirm Password',
                            TextInputType.text,
                            validateConfirmPassword,
                            obscureText: true,
                            onEditingCompleted: () {

                              if(_confirmPasswordController.text.isNotEmpty) {

                                if(_passwordController.text != _confirmPasswordController.text) {
                                  setState(() {
                                    didPasswordMatched = false;
                                  });
                                }
                                else {
                                  setState(() {
                                    didPasswordMatched = true;
                                  });
                                }

                              }

                            },
                          ),
                        ),

                        SizedBox(height: 4,),

                        Visibility(
                          visible: formValidate && !didPasswordMatched  ? true : false,
                          child: Padding(
                            padding: EdgeInsets.symmetric(horizontal: 28.0),
                            child: Text(
                              'Password did not matched with Confirm Password ',
                              style: TextStyle(
                                fontSize: 12,
                                color: ColorConstants.redColor,
                              ),
                            ),
                          ),
                        ),*/



                        SizedBox(
                          height: 12,
                        ),

                        //date of birth
              /*
                      Container(
                          height: 56,
                          padding: EdgeInsets.symmetric(horizontal: 16.0),
                          margin: EdgeInsets.symmetric(horizontal: 16),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8.0),
                            border: Border.all(
                                color: (formValidate && currentDate == Languages.of(context).currentDateValue) ? ColorConstants.redColor : ColorConstants.dividerColor,
                                style: BorderStyle.solid,
                                width: 0.80),
                          ),
                          child: InkWell(
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

                                selectedDate = picked;
                                getCurrentDate(selectedDate);

                              }
                            },
                            child: Row(
                              children: [
                                Text(
                                  currentDate,
                                  style: TextStyle(
                                      color: (currentDate != Languages.of(context).currentDateValue) ? ColorConstants.black : ColorConstants.lightGreyTextColor),
                                ),
                              ],
                            ),
                          ),
                        ),

                        SizedBox(
                          height: 4,
                        ),


                        Visibility(
                          visible: (formValidate && currentDate == Languages.of(context).currentDateValue) ? true : false,
                          child: Padding(
                            padding: EdgeInsets.symmetric(horizontal: 28.0),
                            child: Text(
                              Languages.of(context).pleaseSelectDOB,
                              style: TextStyle(
                                fontSize: 12,
                                color: ColorConstants.redColor,
                              ),
                            ),
                          ),
                        ),


                        SizedBox(
                          height: 12,
                        ),

                        //gender
                        Container(
                          height: 56,
                          padding: EdgeInsets.symmetric(horizontal: 16.0),
                          margin: EdgeInsets.symmetric(horizontal: 16),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8.0),
                            border: Border.all(
                                //color: formValidate && gender == 'Gender' ? ColorConstants.redColor : ColorConstants.dividerColor,
                                color: (formValidate && gender == Languages.of(context).genderValue) ? ColorConstants.redColor : ColorConstants.dividerColor,
                                style: BorderStyle.solid,
                                width: 0.80),
                          ),
                          child: InkWell(
                            onTap: () {
                              //open gender dialog box
                              displayGenderDialog();

                              print('selected gender value: $gender');

                            },
                            child: Row(
                              children: [
                                Text(
                                  gender,
                                  style: TextStyle(
                                      color: gender != Languages.of(context).genderValue ? ColorConstants.black : ColorConstants.lightGreyTextColor),
                                ),
                              ],
                            ),
                          ),
                        ),

                        SizedBox(
                          height: 4,
                        ),

                        Visibility(
                          visible: (formValidate && gender == Languages.of(context).genderValue) ? true : false,
                          child: Padding(
                            padding: EdgeInsets.symmetric(horizontal: 28.0),
                            child: Text(
                              Languages.of(context).pleaseSelectGender,
                              style: TextStyle(
                                fontSize: 12,
                                color: ColorConstants.redColor,
                              ),
                            ),
                          ),
                        ),


                        SizedBox(
                          height: 12,
                        ),
                        */

                        //country
                        Container(
                          height: 56,
                          padding: EdgeInsets.symmetric(horizontal: 16.0),
                          margin: EdgeInsets.symmetric(horizontal: 16),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8.0),
                            border: Border.all(
                                //color:  formValidate && country == 'Country' ? ColorConstants.redColor : ColorConstants.dividerColor,
                                color:  (formValidate && country == Languages.of(context).countryValue) ? ColorConstants.redColor : ColorConstants.dividerColor,
                                style: BorderStyle.solid,
                                width: 0.80),
                          ),
                          child: InkWell(
                            onTap: () {
                              //open country dialog box
                              displayCountryDialog();
                            },
                            child: Row(
                              children: [
                                Text(
                                  country,
                                  style: TextStyle(
                                      //color: country != 'Country' ? ColorConstants.black : ColorConstants.lightGreyTextColor),
                                      color: country != Languages.of(context).countryValue ? ColorConstants.black : ColorConstants.lightGreyTextColor),
                                ),
                              ],
                            ),
                          ),
                        ),

                        SizedBox(
                          height: 4,
                        ),

                        Visibility(
                          //visible: formValidate && country == 'Country' ? true : false,
                          visible: (formValidate && country == Languages.of(context).countryValue) ? true : false,
                          child: Padding(
                            padding: EdgeInsets.symmetric(horizontal: 28.0),
                            child: Text(
                              Languages.of(context).pleaseSelectCountry,
                              style: TextStyle(
                                fontSize: 12,
                                color: ColorConstants.redColor,
                              ),
                            ),
                          ),
                        ),


                        SizedBox(
                          height: 12,
                        ),

                        //city
                        Container(
                          height: 56,
                          padding: EdgeInsets.symmetric(horizontal: 16.0),
                          margin: EdgeInsets.symmetric(horizontal: 16),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8.0),
                            border: Border.all(
                                //color: formValidate && city == 'City' ? ColorConstants.redColor : ColorConstants.dividerColor,
                                color: formValidate && city == Languages.of(context).cityValue ? ColorConstants.redColor : ColorConstants.dividerColor,
                                style: BorderStyle.solid,
                                width: 0.80),
                          ),
                          child: InkWell(
                            onTap: () {
                              //open city dialog box

                              //if(country == 'Country' {
                              if(country == Languages.of(context).countryValue) {
                                setState(() {
                                  isCountrySelectedMsg = true;
                                });
                              }
                              else {
                                displayCityDialog();
                              }

                            },
                            child: Row(
                              children: [
                                Text(
                                  city,
                                  style: TextStyle(
                                      //color: city != 'City' ? ColorConstants.black : ColorConstants.lightGreyTextColor),
                                      color: city != Languages.of(context).cityValue ? ColorConstants.black : ColorConstants.lightGreyTextColor),
                                ),
                              ],
                            ),
                          ),
                        ),


                        SizedBox(
                          height: 4,
                        ),

                        Visibility(
                          //visible: formValidate && city == 'City' ? true : false,
                          visible: (formValidate && city == Languages.of(context).cityValue) ? true : false,
                          child: Padding(
                            padding: EdgeInsets.symmetric(horizontal: 28.0),
                            child: Text(
                              Languages.of(context).pleaseSelectCity,
                              style: TextStyle(
                                fontSize: 12,
                                color: ColorConstants.redColor,
                              ),
                            ),
                          ),
                        ),

                        Visibility(
                          //visible: isCountrySelectedMsg && country == 'Country' ? true : false,
                          visible: (isCountrySelectedMsg && country == Languages.of(context).countryValue) ? true : false,
                          child: Padding(
                            padding: EdgeInsets.symmetric(horizontal: 28.0),
                            child: Text(
                              Languages.of(context).pleaseFirstSelectCountry,
                              style: TextStyle(
                                fontSize: 12,
                                color: ColorConstants.redColor,
                              ),
                            ),
                          ),
                        ),

                        SizedBox(
                          height: 12,
                        ),

                        //phone no
                        Container(
                          padding: EdgeInsets.symmetric(vertical: 2, horizontal: 8),
                          margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                          /*decoration: BoxDecoration(
                            border: Border.all(
                              color: ColorConstants.dividerColor,
                            ),
                            borderRadius: BorderRadius.all(
                              Radius.circular(8.0),
                            ),
                          ),*/
                          child: Row(
                            children: [
                              //country code picker
                              Expanded(
                                flex: 2,
                                child: /*TextFormField(
                                  controller: _countryCodeController,
                                  validator: validateCountryCode,
                                  keyboardType: TextInputType.phone,
                                  onChanged: (value) {
                                    print(_phoneNoController.text.length);
                                    setState(() {});
                                  },
                                  decoration: new InputDecoration(
                                      border: InputBorder.none,
                                      filled: true,
                                      contentPadding: EdgeInsets.only(
                                        top: 0,
                                        left: 10,
                                        right: 10,
                                      ),
                                      hintStyle: new TextStyle(
                                          color: ColorConstants.lightGreyTextColor),
                                      hintText: Languages.of(context).codeText,
                                      fillColor: Colors.white70),
                                ),*/
                                TextFormField(
                                  controller: _countryCodeController,
                                  keyboardType: TextInputType.text,
                                  obscureText: false,
                                  validator: (value) {

                                    if (value.isEmpty) {
                                      return Languages.of(context).countryCodeEmptyText;
                                      //return 'CC empty';
                                    } else
                                      return null;
                                  },
                                  decoration: InputDecoration(
                                    border: new OutlineInputBorder(
                                    ),
                                    labelText: Languages.of(context).codeText,
                                    hintText: Languages.of(context).codeText,
                                    hintStyle: TextStyle(
                                        color: ColorConstants.lightGreyTextColor, fontSize: 13),
                                    labelStyle: TextStyle(
                                        color: ColorConstants.lightGreyTextColor, fontSize: 13),
                                  ),
                                ),
                              ),

                              /*Expanded(
                          flex: 2,
                          child: TextField(
                            controller: _phoneNoController,
                            keyboardType: TextInputType.phone,
                            onChanged: (value) {
                              print(_phoneNoController.text.length);
                              setState(() {});
                            },
                            decoration: new InputDecoration(
                                border: InputBorder.none,
                                filled: true,
                                contentPadding: EdgeInsets.only(
                                  top: 0,
                                  left: 10,
                                  right: 10,
                                ),
                                hintStyle: new TextStyle(
                                    color: ColorConstants.lightGreyTextColor),
                                hintText: 'xxxxxxx-xxxx',
                                fillColor: Colors.white70),
                          ),
                        ),*/

                              Text("|", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),

                              Expanded(
                                flex: 4,
                                child: /*TextFormField(
                                  controller: _phoneNoController,
                                  validator: validatePhoneNo,
                                  keyboardType: TextInputType.phone,
                                  onChanged: (value) {
                                    print(_phoneNoController.text.length);
                                    setState(() {});
                                  },
                                  decoration: new InputDecoration(
                                      border: InputBorder.none,
                                      filled: true,
                                      contentPadding: EdgeInsets.only(
                                        top: 0,
                                        left: 10,
                                        right: 10,
                                      ),
                                      hintStyle: new TextStyle(
                                          color: ColorConstants.lightGreyTextColor),
                                      hintText: 'xxxxxxx-xxxx',
                                      fillColor: Colors.white70),
                                ),*/

                                TextFormField(
                                  controller: _phoneNoController,
                                  keyboardType: TextInputType.phone,
                                  obscureText: false,
                                  validator: (value) {

                                    if (value.isEmpty) {
                                      return Languages.of(context).phoneNoEmptyText;
                                      //return 'Phone number empty';
                                    } else
                                      return null;

                                  },
                                  decoration: InputDecoration(
                                    border: new OutlineInputBorder(
                                    ),
                                    labelText: 'xxxxxxx-xxxx',
                                    hintText: 'xxxxxxx-xxxx',
                                    hintStyle: TextStyle(
                                        color: ColorConstants.lightGreyTextColor, fontSize: 13),
                                    labelStyle: TextStyle(
                                        color: ColorConstants.lightGreyTextColor, fontSize: 13),
                                  ),
                                ),


                              ),
                            ],
                          ),
                        ),

                        SizedBox(
                          height: 12,
                        ),

                        //create account button
                        Padding(
                          padding:
                          EdgeInsets.symmetric(horizontal: 8.0, vertical: 16),
                          child: CustomButton1(
                            text: Languages.of(context).createAnAccountButtonText,
                            callback: () {

                              print('firstName: ${_firstNameController.text}');
                              print('lastName: ${_lastNameController.text}');
                              print('email: ${_emailController.text}');

                              /*print('password: ${_passwordController.text}');
                              print('confirm password: ${_confirmPasswordController.text}');*/

                              print('dob: $currentDate');
                              print('gender: $gender');
                              print('country: $country');
                              print('city: $city');
                              print('country code: ${_countryCodeController.text}');
                              print('phoneNo: ${_phoneNoController.text}');

                              setState(() {
                                formValidate = true;
                              });

                              print('formValidate: $formValidate');
                              print('current date: $currentDate');
                              print('current date lang: ${Languages.of(context).currentDateValue}');

                              //form validation
                              //validateAndSave(cxt);

                              if(_image == null) {
                                Utils.displaySnackBar(cxt, Languages.of(context).pleaseSelectImage, 2);
                              }


                              if(_firstNameController.text.isEmpty || _lastNameController.text.isEmpty ||
                                  _emailController.text.isEmpty || currentDate == Languages.of(context).currentDateValue ||
                                  gender == Languages.of(context).genderValue || country == Languages.of(context).countryValue ||
                                  city == Languages.of(context).cityValue || _countryCodeController.text.isNotEmpty ||
                                  _phoneNoController.text.isNotEmpty || _image != null) {

                                //form validation
                                validateAndSave(cxt);

                              }

                              /*if(_firstNameController.text.isNotEmpty && _lastNameController.text.isNotEmpty &&
                              _emailController.text.isNotEmpty && currentDate != Languages.of(context).currentDateValue &&
                              gender != Languages.of(context).genderValue && country != Languages.of(context).countryValue &&
                                  city != Languages.of(context).cityValue && _countryCodeController.text.isNotEmpty &&
                              _phoneNoController.text.isNotEmpty && _image != null) {

                                //form validation
                                validateAndSave(cxt);

                              }*/


                              /*if(_passwordController.text != _confirmPasswordController.text) {
                                setState(() {
                                  didPasswordMatched = false;
                                });
                              }
                              else {

                                setState(() {
                                  didPasswordMatched = true;
                                });


                                //form validation
                                validateAndSave(cxt);

                                if(_image == null) {
                                  Utils.displaySnackBar(cxt, 'Please select image !', 2);
                                }

                              }*/


                            },
                          ),
                        ),
                      ],
                    ),

                    Visibility(
                      visible: isLoading2,
                      child: Utils.buildLoading(),
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

  getCurrentDate(DateTime now) {
    var formatter = new DateFormat('yyyy-MM-dd');
    String formattedDate = formatter.format(now);

    setState(() {
      currentDate = formattedDate;
    });
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
                  Languages.of(context).selectGender,
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


  getGendersList() {
    genderList.add(
      'Male',
    );

    genderList.add(
      'Female',
    );
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
                  Languages.of(context).selectCountry,
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

  getCountryList() {
    countryList.add(
      'Saudi Arabia',
    );
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
                    Languages.of(context).selectCity,
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

  getCityList() {
    cityList.add('Al Khobar');
    cityList.add('Dammam');
    cityList.add(
      'Al Qatif - Sihat',
    );
  }

  Function(String) validateFirstName = (String fristName) {
  //Function(String, BuildContext) validateFirstName = (String fristName, BuildContext context) {
    if (fristName.isEmpty) {
      return 'First Name empty';
      //return Languages.of(context).firstNameEmptyText;
    } else if (fristName.length < 3) {
      return 'First Name short';
      //return Languages.of(context).firstNameShortText;
    }

    return null;
  };

  //Function(String, BuildContext) validateLastName = (String lastName, BuildContext context) {
  Function(String) validateLastName = (String lastName) {
    if (lastName.isEmpty) {
      //return Languages.of(context).lastNameEmptyText;
      return 'Last Name empty';
    } else if (lastName.length < 3) {
      //return Languages.of(context).lastNameShortText;
      return 'Last Name short';
    }

    return null;
  };

  //Function(String, BuildContext) validateEmail = (String email, BuildContext context) {
  Function(String) validateEmail = (String email) {
    if (email.isEmpty) {
      //return Languages.of(context).emailEmptyText;
      return 'Email empty';
    } else if (Utils.isEmail(email) == false) {
      //return Languages.of(context).invalidEmailText;
      return 'Invalid email';
    }

    return null;
  };

  Function(String) validatePassword = (String value) {
    if (value.isEmpty) {
      return "Password empty";
    } else if (value.length < 6) {
      return "Password should be at least 6 characters";
    } else if (value.length > 15) {
      return "Password should not be greater than 15 characters";
    } else
      return null;
  };

  Function(String) validateConfirmPassword = (String confirmPasswordValue) {
    if (confirmPasswordValue.isEmpty) {
      return "Confirm Password empty";
    } else if (confirmPasswordValue.length < 6) {
      return "Confirm Password should be at least 6 characters";
    } else if (confirmPasswordValue.length > 15) {
      return "Confirm Password should not be greater than 15 characters";
    } else
      return null;
  };

  //Function(String, BuildContext) validateCountryCode = (String value, BuildContext context) {
  Function(String) validateCountryCode = (String value) {
    if (value.isEmpty) {
      //return Languages.of(context).countryCodeEmptyText;
      return 'CC empty';
    } else
      return null;
  };

  //Function(String, BuildContext) validatePhoneNo = (String value, BuildContext context) {
  Function(String) validatePhoneNo = (String value) {
    if (value.isEmpty) {
      //return Languages.of(context).phoneNoEmptyText;
      return 'Phone number empty';
    } else
      return null;
  };


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
                      title: new Text(Languages.of(context).photoLibraryImagePickerText),
                      onTap: () {
                        _imgFromGallery();
                        Navigator.of(context).pop();
                      }),
                  new ListTile(
                    leading: new Icon(Icons.photo_camera),
                    title: new Text(Languages.of(context).cameraImagePickerText),
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

  void validateAndSave(BuildContext cxt) {

    setState(() {
      isLoading2 = true;
    });

    final form = formKey.currentState;


/*
    if (form.validate() && _firstNameController.text.isNotEmpty && _lastNameController.text.isNotEmpty &&
    _emailController.text.isNotEmpty && currentDate != Languages.of(context).currentDateValue &&
    gender != Languages.of(context).genderValue && country != Languages.of(context).countryValue &&
    city != Languages.of(context).cityValue && _countryCodeController.text.isNotEmpty &&
    _phoneNoController.text.isNotEmpty && _image != null) {
*/

    if (form.validate() && _firstNameController.text.isNotEmpty && _lastNameController.text.isNotEmpty &&
        _emailController.text.isNotEmpty && country != Languages.of(context).countryValue &&
        city != Languages.of(context).cityValue && _countryCodeController.text.isNotEmpty &&
        _phoneNoController.text.isNotEmpty && _image != null) {


      form.save();

      String phoneNo = '${_countryCodeController.text}${_phoneNoController.text}';
      print('complete phone no: $phoneNo');

      ///to-do sign-up api call
      SignUpFormData signUpFormData = SignUpFormData(
          _firstNameController.text,
          _lastNameController.text,
          _emailController.text,
          phoneNo,
          currentDate,
          gender,
          selectedCountry.id.toString(),
          selectedCity.id.toString(),
          //_passwordController.text,
          myPath.basename(_image.path)
      );

      _signUpUser(signUpFormData).then((value) => {

          if(value.status == true) {

              Utils.displaySnackBar(cxt, value.message, 2),
              Future.delayed(const Duration(milliseconds: 2000), () async  {

                /*Navigator.of(context).pushReplacement(
                  MaterialPageRoute(
                    builder: (context) => SignInScreen(),
                  ),
                );*/

                int result = await Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => OTPScreen(phoneNo),
                  ),
                );

                if(result == 1) {
                  Navigator.pop(context, 1);
                }
                else {
                  Navigator.pop(context, 0);
                }


              }),
          }
          else {
            Utils.displaySnackBar(cxt, value.message, 2),
          },


          setState(() {
            formValidate = false;
          }),

      });

    }
    else {
      setState(() {
        //formValidate = false;
        isLoading2 = false;
      });
    }


  }


  Future<SignUpResponse> _signUpUser(SignUpFormData signUpFormData) async {

    print( " in signup user service");
    SignUpResponse signUpResponse;

    print('image path: ${signUpFormData.image}');
    print('playerId: ${StaticData.playerId}');

    try {
      var request = http.MultipartRequest('POST', Uri.parse('${AppConstants.baseURL}/api/userSignup'));
      request.fields.addAll({
          "fname":signUpFormData.firstName,
          "lname":signUpFormData.lastName,
          "email":signUpFormData.email,
          "phone":signUpFormData.phoneNo,
          //"birth_date":signUpFormData.dob,
          "birth_date":'2020-03-03',
          //"gender":signUpFormData.gender,
          "gender":'male',
          "country_id":signUpFormData.countryId,
          "city_id":signUpFormData.cityId,
          "player_id": StaticData.playerId,
          //"password":signUpFormData.password,
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

        signUpResponse = (SignUpResponse.fromJson(json.decode(v)));
        return signUpResponse;

      }
      else {


        setState(() {
          isLoading2 = false;
        });

        print(response.reasonPhrase);
        signUpResponse = (SignUpResponse.fromJson(json.decode(v)));
        return signUpResponse;

      }


  }
  catch(e) {
    print( "in exception ->$e" );

    Fluttertoast.showToast(
        msg: "Something went wrong !",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.blue,
        textColor: Colors.white,
        fontSize: 16.0
    );

  }

  return signUpResponse;

  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    /*_passwordController.dispose();
    _confirmPasswordController.dispose();*/
    super.dispose();
  }

}
