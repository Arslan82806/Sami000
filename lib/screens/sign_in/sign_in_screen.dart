import 'dart:convert';
import 'package:beauty_saloon/components/custom_app_bar.dart';
import 'package:beauty_saloon/components/custom_border_button.dart';
import 'package:beauty_saloon/components/custom_button_1.dart';
import 'package:beauty_saloon/components/custom_textfield.dart';
import 'package:beauty_saloon/localization/language/languages.dart';
import 'package:beauty_saloon/model/sign_in_response.dart';
import 'package:beauty_saloon/screens/otp/otp_screen.dart';
import 'package:beauty_saloon/screens/sign_up/sign_up_screen.dart';
import 'package:beauty_saloon/utils/app_constants.dart';
import 'package:beauty_saloon/utils/color_constants.dart';
import 'package:beauty_saloon/utils/shared_prefs.dart';
import 'package:beauty_saloon/utils/static_data.dart';
import 'package:beauty_saloon/utils/styles.dart';
import 'package:beauty_saloon/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;


class SignInScreen extends StatefulWidget {

  @override
  _SignInScreenState createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {

  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  var _mobileController = TextEditingController();

  bool rememberMeCheckedValue = false;
  bool isLoading = false;

  String userCred;

  Future<String> _getUserCredentials() async {

    userCred = await SharedPref.read(AppConstants.user_credentials);

    print('user cred: $userCred');


    return userCred;
  }

  @override
  void initState() {

    StaticData.userData = null;
    SharedPref.remove(AppConstants.user_data);

    SharedPref.checkIfKeyExistsInSharedPref(AppConstants.user_credentials).then((credValue) => {

        if(credValue) {

            _getUserCredentials().then((value) => {

              if(value.isNotEmpty && value != null) {
                _mobileController = TextEditingController(text: value),

                setState(() {
                  rememberMeCheckedValue = true;
                }),

                print('user cred in init: $value'),
              }

            }),

        }



    });


 /*
      _getUserCredentials().then((value) => {

        if(value.isNotEmpty && value != null) {
          _mobileController = TextEditingController(text: value),

          setState(() {
            rememberMeCheckedValue = true;
          }),

          print('user cred in init: $value'),
        }

      });
*/


    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //appBar: CustomAppBar(title: Languages.of(context).labelSignIn,),
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: ColorConstants.whiteColor),
          onPressed: () {
            Navigator.pop(context, 1);
          },
        ),
        title: Text(Languages.of(context).labelSignIn,
            style: TextStyle(
                fontFamily: 'Quicksand', color: ColorConstants.whiteColor)),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Container(
          padding: EdgeInsets.all(16),
          child: SingleChildScrollView(
            child: Builder(
              builder: (cxt) => Form(
                key: formKey,
                child: Stack(
                  alignment: AlignmentDirectional.center,
                  children: [

                    Column(
                      children: [

                        Image.asset(
                          'assets/images/salon_logo.png',
                          width: MediaQuery.of(context).size.width > 768 ? 300 : 220,
                        ),

                        /*CustomTextfield(
                      _emailMobileController,
                      Languages.of(context).hintEmailMobileNo,
                      TextInputType.text),*/

                        CustomTextField(_mobileController, Languages.of(context).hintEmailMobileNo,
                            Languages.of(context).hintEmailMobileNo, TextInputType.phone, validateMobileNo),


                        SizedBox(
                          height: 8,
                        ),

                        //remember me and forgot password row
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            FlatButton(
                                onPressed: () => setState(() =>
                                rememberMeCheckedValue = !rememberMeCheckedValue),
                                child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      SizedBox(
                                        height: 24.0,
                                        width: 24.0,
                                        child: Checkbox(
                                          activeColor: ColorConstants.primaryColor,
                                          value: rememberMeCheckedValue,
                                          onChanged: (value) {
                                            setState(
                                                    () => rememberMeCheckedValue = value);

                                            _saveUserCredentials();

                                          },
                                        ),
                                      ),
                                      // You can play with the width to adjust your
                                      // desired spacing
                                      SizedBox(width: 10.0),
                                      Text(
                                        Languages.of(context).lableRememberMeCheckbox,
                                        style: TextStyle(
                                            fontFamily: 'Quicksand',
                                            fontSize: MediaQuery.of(context).size.width > 768 ? 20 : 15,
                                            fontWeight: FontWeight.normal,
                                            color: ColorConstants.greyColor),
                                      ),
                                    ])),
                            /*InkWell(
                              onTap: () {
                                //navigate to forgot password screen
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (context) => ForgotPasswordScreen(),
                                  ),
                                );
                              },
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  Languages.of(context).lableForgotPasswordButton,
                                  style: forgotPasswordStyle,
                                ),
                              ),
                            ),*/
                          ],
                        ),

                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.03,
                        ),

                        //sign in button
                        CustomButton1(
                          text: Languages.of(context).buttonLabelSignIn.toUpperCase(),
                          callback: () {

                            //form validate
                            validateAndSave(cxt, _mobileController.text);

                          },
                        ),

                        SizedBox(
                          height: 8,
                        ),

                        //create account button
                        CustomBorderButton(
                            Languages.of(context)
                                .buttonLabelCreateAccountIn
                                .toUpperCase(), () async {
                          //navigate to sign up screen
                          int result = await Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => SignUpScreen(),
                            ),
                          );

                          if(result == 1) {
                            Navigator.pop(context, 1);
                          }
                          else {
                            Navigator.pop(context, 0);
                          }

                        }),
                      ],
                    ),

                    Visibility(
                      visible: isLoading,
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

  Function(String) validateMobileNo = (String mobileNo) {
    if (mobileNo.isEmpty) {
      return 'Mobile no empty';
    }

    return null;
  };

  Function(String) validateEmail = (String email) {
    if (email.isEmpty) {
      return 'Email empty';
    }
    else if(Utils.isEmail(email) == false) {
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


  void validateAndSave(BuildContext cxt, String email) async  {
    final form = formKey.currentState;

    if (form.validate()) {
      form.save();

      ///to-do sign in api call
      _signInUser(email).then((value) => {

        if(value != null && value.status) {
          //Utils.displaySnackBar(cxt, 'success !', 2),

          Fluttertoast.showToast(
          msg: "Success !",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.blue,
          textColor: Colors.white,
          fontSize: 16.0
          ),


          print('user to json: ${value.toJson()}'),



          //SharedPref.save(AppConstants.user_data, value.toJson()),

          //save user credentials check
          _saveUserCredentials(),


          _navigateToOTPScreen(),


          /*Future.delayed(const Duration(milliseconds: 2000), () async {

            int result = await Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => OTPScreen(_mobileController.text),
              ),
            );

            if(result == 1)
              Navigator.pop(context, 1);
            else
              Navigator.pop(context, 0);

          }),*/


        }
        else {
          //clear user data from shared preferences
          SharedPref.save(AppConstants.user_data, ''),
          Utils.displaySnackBar(cxt, 'mobile number not registered !', 2),
        }


      });


      /*int result = await Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => OTPScreen(_mobileController.text),
        ),
      );

      if(result == 1)
        Navigator.pop(context, 1);
      else
        Navigator.pop(context, 0);*/


    }
  }

  _navigateToOTPScreen() async {

    int result = await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => OTPScreen(_mobileController.text),
      ),
    );

    print('result from otp: $result');

    if(result == 1)
      Navigator.pop(context, 1);
    else
      Navigator.pop(context, 0);

  }

  Future<SignInResponse> _signInUser(String email) async {

    String url = '${AppConstants.baseURL}/api/userLogin';
    SignInResponse signInResponse;

    print('email: $email');
    print('url: $url');

    setState(() {
      isLoading = true;
    });


    var response = await http.post(
        url,
        headers: {
          "APP_KEY": AppConstants.APP_KEY,
        },
        body: {
          "phone": email,
        });


    // check the status code for the result
    int statusCode = response.statusCode;

    if (statusCode == 200) {

      String body = response.body;
      print('sign in response $body');

      signInResponse = SignInResponse.fromJson(jsonDecode(response.body));

      setState(() {
        isLoading = false;
      });

      return signInResponse;

    }
    else {

      //display something went wrong message
      print('status code: $statusCode');
      print('something went wrong !');

      setState(() {
        isLoading = false;
      });

      return signInResponse;
    }
    //end if


  }

  _saveUserCredentials() {

    print('remember check value: $rememberMeCheckedValue');

    //remember me is check, save credentials
    if(rememberMeCheckedValue) {

      //remember is checked
      SharedPref.save(AppConstants.user_credentials, _mobileController.text);
    }
    else {

      //remember is not checked
      SharedPref.save(AppConstants.user_credentials, '');
    }

    //save remember me check status in shared preferences
    SharedPref.save(AppConstants.prefRememberMe, rememberMeCheckedValue);

  }



  @override
  void dispose() {
    _mobileController.dispose();
    super.dispose();
  }


}
