import 'package:beauty_saloon/components/custom_app_bar.dart';
import 'package:beauty_saloon/components/custom_button_1.dart';
import 'package:beauty_saloon/localization/language/languages.dart';
import 'package:beauty_saloon/screens/home/home_screen.dart';
import 'package:beauty_saloon/screens/loading_screen/loading_screen.dart';
import 'package:beauty_saloon/utils/app_constants.dart';
import 'package:beauty_saloon/utils/color_constants.dart';
import 'package:beauty_saloon/utils/shared_prefs.dart';
import 'package:flutter/material.dart';

class ServiceTypeScreen extends StatefulWidget {

  @override
  _ServiceTypeScreenState createState() => _ServiceTypeScreenState();
}

class _ServiceTypeScreenState extends State<ServiceTypeScreen> {

  bool salonChecked = true;
  bool homeChecked = false;

  @override
  void initState() {

    SharedPref.save(AppConstants.prefServiceType, 'salon');

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: CustomAppBar(
          title: Languages.of(context).serviceTypeScreenTitle,
          showBackButton: false,
        ),
        body: SafeArea(
          child: Center(
            child: Container(
              padding: EdgeInsets.all(24),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [


                    Image.asset(
                      'assets/images/salon_logo.png',
                      width: MediaQuery.of(context).size.width > 768 ? 300 : 220,
                    ),


                    Text(
                      Languages.of(context).serviceTypeHeading,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 30,
                        fontFamily: 'Quicksand',
                      ),
                    ),

                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.1,
                    ),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [

                        InkWell(
                          onTap: () {

                            setState(() {
                              salonChecked = true;
                              homeChecked = false;
                            });

                            SharedPref.save(AppConstants.prefServiceType, 'salon');

                          },
                          child: Container(
                            width: 30,
                            height: 30,
                            decoration: BoxDecoration(
                              color: salonChecked ? ColorConstants.black : ColorConstants.whiteColor,
                                border: Border.all(
                                  color: ColorConstants.black,
                                ),
                                shape: BoxShape.circle),
                          ),
                        ),

                        SizedBox(
                          width: 16.0,
                        ),

                        Text(Languages.of(context).radioSalonServiceType, style: TextStyle(fontSize: 24, fontFamily: 'Quicksand', color: ColorConstants.black,),),

                        SizedBox(
                          width: 50,
                        ),

                        InkWell(
                          onTap: () {

                            setState(() {
                              salonChecked = false;
                              homeChecked = true;
                            });

                            SharedPref.save(AppConstants.prefServiceType, 'home');

                          },
                          child: Container(
                            width: 30,
                            height: 30,
                            decoration: BoxDecoration(
                                color: salonChecked ? ColorConstants.whiteColor : ColorConstants.black,
                                border: Border.all(
                                  color: ColorConstants.black,
                                ),
                                shape: BoxShape.circle),
                          ),
                        ),

                        SizedBox(
                          width: 16.0,
                        ),

                        Text(Languages.of(context).radioHomeServiceType, style: TextStyle(fontSize: 24, fontFamily: 'Quicksand', color: ColorConstants.black,),),

                      ],
                    ),

                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.05,
                    ),


                    //button
                    CustomButton1(text: Languages.of(context).serviceTypeContinueButtonText, callback: () {

                      /*Navigator.of(context).pushReplacement(
                        MaterialPageRoute(
                          builder: (context) => HomeScreen(),
                        ),
                      );*/

                      Navigator.of(context).pushReplacement(
                        MaterialPageRoute(
                          builder: (context) => LoadingScreen(),
                        ),
                      );


                    }),


                  ],
                ),
              ),
            ),
          ),
        ));
  }
}
