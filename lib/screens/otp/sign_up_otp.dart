import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:beauty_saloon/components/custom_app_bar.dart';
import 'package:beauty_saloon/components/custom_button_1.dart';
import 'package:beauty_saloon/localization/language/languages.dart';
import 'package:beauty_saloon/model/otp_response.dart';
import 'package:beauty_saloon/utils/app_constants.dart';
import 'package:beauty_saloon/utils/shared_prefs.dart';
import 'package:beauty_saloon/utils/utils.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:otp_text_field/otp_field.dart';
import 'package:otp_text_field/style.dart';

class SignUpOTP extends StatefulWidget {

  final String phoneNo;
  SignUpOTP(this.phoneNo);


  @override
  _SignUpOTPState createState() => _SignUpOTPState();
}

class _SignUpOTPState extends State<SignUpOTP> {

  bool isLoading = false;
  String otpCode;

  @override
  void initState() {

    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: Languages.of(context).otpScreenTitle,),
      body: Builder(
        builder: (cxt) => Stack(
          children: [

            Container(
              padding: EdgeInsets.all(16),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [

                  OTPTextField(
                    length: 4,
                    width: MediaQuery.of(context).size.width,
                    fieldWidth: 80,
                    style: TextStyle(
                        fontSize: 17
                    ),
                    textFieldAlignment: MainAxisAlignment.spaceAround,
                    fieldStyle: FieldStyle.underline,
                    onCompleted: (pin) {
                      print("Completed: " + pin);
                      setState(() {
                        otpCode = pin;
                      });

                    },
                  ),

                  SizedBox(
                      height: 20
                  ),


                  CustomButton1(
                    text: Languages.of(context).buttonLabelOTPSubmit,
                    callback: () {

                      if(!isLoading) {
                        _verifyOTPApiCall(cxt);
                      }


                    },
                  ),


                ],
              ),
            ),


            Visibility(
              visible: isLoading,
              child: Align(
                alignment: Alignment.center,
                child: CircularProgressIndicator(valueColor: new AlwaysStoppedAnimation<Color>(Color(0xFF8D72B7)),),
              ),
            ),

          ],
        ),
      ),
    );
  }

  _verifyOTPApiCall(BuildContext cxt) async {

    if( otpCode != null && otpCode.isNotEmpty )  {


      OTPResponse otpResponse = await checkOTPAPICall(otpCode, widget.phoneNo);

      if(otpResponse.status == true) {

        Fluttertoast.showToast(
            msg: "Login Successful",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.blue,
            textColor: Colors.white,
            fontSize: 16.0
        );


        Navigator.pop(cxt, 1);

      }
      else {
        Utils.displaySnackBar(cxt, otpResponse.message, 2);
      }

    }
    else {
      Utils.displaySnackBar(cxt, 'OTP is empty', 2);
    }


  }//end signUpChecksAndApiCall()

  Future<OTPResponse> checkOTPAPICall(String otp, String phoneNo) async {

    print('phoneNo received: $phoneNo');

    setState(() {
      isLoading = true;
    });

    var response = await http.post(
        AppConstants.baseURL+'/api/verify-account',
        headers: {
          "APP_KEY": AppConstants.APP_KEY,
        },
        body: {
          "phone": phoneNo,
          "sms_token": otp
        }
    );

    print('otp res: ${response.body}');

    if (response.statusCode == 200) {

      setState(() {
        isLoading = false;
      });

      return OTPResponse.fromJson(jsonDecode(response.body));

    } else {

      setState(() {
        isLoading = false;
      });

      return OTPResponse.fromJson(jsonDecode(response.body));

    }

  }//end checkOTPAPICall()


}
