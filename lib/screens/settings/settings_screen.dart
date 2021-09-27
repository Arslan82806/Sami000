import 'package:beauty_saloon/components/custom_app_bar.dart';
import 'package:beauty_saloon/components/custom_widgets.dart';
import 'package:beauty_saloon/localization/language/languages.dart';
import 'package:beauty_saloon/localization/locale_constants.dart';
import 'package:beauty_saloon/model/language_data.dart';
import 'package:beauty_saloon/utils/color_constants.dart';
import 'package:beauty_saloon/utils/styles.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';


class SettingsScreen extends StatefulWidget {

  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {

  Dialog languageDialog;
  bool _switchValue = true;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorConstants.bgColor,
      appBar: CustomAppBar(title: Languages.of(context).labelSettingsScreen,),
      /*AppBar(
        backgroundColor: ColorConstants.primaryColor,
        leading: IconButton(icon: Icon(Icons.arrow_back, color: ColorConstants.whiteColor), onPressed: () {Navigator.pop(context);},),
        title: Text('Settings'),
        centerTitle: true,
      ),*/
      body: SafeArea(
        child: Container(
          child: Column(
            children: [

              //select language row
              InkWell(
                onTap: () {

                  //open language dialog
                  displayLanguageDialog();

                },
                child: Container(
                  color: ColorConstants.rowColor,
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 24),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        Languages.of(context).settingsScreenSelectLanguage,
                        style: settingsRowTextStyle,
                      ),

                      Row(
                        children: [

                          Text(
                            Languages.of(context).getSelectedLanguageValue == 'Select Language' ? 'English' : Languages.of(context).getSelectedLanguageValue,
                            style: normalTextStyleBlack,
                          ),

                          SizedBox(width: 8,),

                          Icon(Icons.keyboard_arrow_down_outlined, color: ColorConstants.iconColor),
                        ],
                      ),

                    ],
                  ),
                ),
              ),

              //divider
              CustomWidgets.customDivider(),

              //push notifications row
              Container(
                color: ColorConstants.rowColor,
                padding: EdgeInsets.all(16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      Languages.of(context).lablePushNotification,
                      style: settingsRowTextStyle,
                    ),

                    //switch
                    CupertinoSwitch(
                      value: _switchValue,
                      activeColor: ColorConstants.primaryColor,
                      onChanged: (value) {
                        setState(() {
                          _switchValue = value;
                        });
                      },
                    ),


                  ],
                ),
              ),

              //feedback email address row
              Container(
                padding: EdgeInsets.symmetric(vertical: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [

                    Text(Languages.of(context).feedbackAndSupport, style: settingsRowTextStyle),
                    SizedBox(height: 8,),
                    Text('support@samisalon.com', style: TextStyle(fontFamily: 'Quicksand',
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: ColorConstants.black)),

                  ],
                ),
              ),

              //divider
              CustomWidgets.customDivider(),

              //email intent row
              InkWell(
                onTap: () {

                  _sendMail();

                },
                child: Container(
                  color: ColorConstants.whiteColor,
                  padding: EdgeInsets.symmetric(vertical: 16),
                  child: Center(child: Text(Languages.of(context).emailCustomerService, style: TextStyle(
                      fontFamily: 'Quicksand',
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: ColorConstants.primaryColor
                  ))),
                ),
              ),

              //divider
              CustomWidgets.customDivider(),

            ],
          ),
        ),
      ),
    );
  }

  _sendMail() async {
    // Android and iOS
    const uri =
        'mailto:test@example.org?subject=Greetings&body=Dear%20Customer';
    if (await canLaunch(uri)) {
      await launch(uri);
    } else {
      throw 'Could not launch $uri';
    }
  }

  displayLanguageDialog() {

    languageDialog = Dialog(
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
                    //'Select Language',
                    Languages.of(context).settingsScreenSelectLanguage,
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

                        setState(() {
                          Languages.of(context).setLanguageValue(LanguageData.languageList()[index].name);
                        });

                        changeLanguage(context, LanguageData.languageList()[index].languageCode);

                        Navigator.pop(context);
                      },
                      child: Center(child: Text(LanguageData.languageList()[index].name, style: TextStyle(fontFamily: 'Quicksand', fontSize: 20, ),)),
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
        context: context, builder: (BuildContext context) => languageDialog);
  }


  /*getLanguageCode(String language) {
    String code;
    if(language == 'English') {
      code = 'en';
    }
    else if(language == 'اَلْعَرَبِيَّةُ') {
      code = 'ar';
    }

  }*/

}
