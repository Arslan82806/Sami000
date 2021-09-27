import 'package:beauty_saloon/components/custom_button_2.dart';
import 'package:beauty_saloon/localization/language/languages.dart';
import 'package:beauty_saloon/model/otp_response.dart';
import 'package:beauty_saloon/pages/appointments/tabs/canceled_tab.dart';
import 'package:beauty_saloon/pages/appointments/tabs/completed_tab.dart';
import 'package:beauty_saloon/pages/appointments/tabs/upcoming_tab.dart';
import 'package:beauty_saloon/screens/sign_in/sign_in_screen.dart';
import 'package:beauty_saloon/utils/app_constants.dart';
import 'package:beauty_saloon/utils/color_constants.dart';
import 'package:beauty_saloon/utils/shared_prefs.dart';
import 'package:beauty_saloon/utils/static_data.dart';
import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';

class AppointmentsPage extends StatefulWidget {
  @override
  _AppointmentsPageState createState() => _AppointmentsPageState();
}

class _AppointmentsPageState extends State<AppointmentsPage>
    with SingleTickerProviderStateMixin {

  TabController _controller;

  List<Widget> list = [];

  bool isLoading = true;


  @override
  void initState() {
    _controller = TabController(length: list.length, vsync: this);

    _controller.addListener(() {
      print("Selected Index: " + _controller.index.toString());
    });

    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    getTabTitles();

  }

  @override
  Widget build(BuildContext context) {
    return StaticData.userData == null ? signedOutLayout() : DefaultTabController(
      length: list.length,
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(kToolbarHeight * 1.2),
          child: Container(
            color: ColorConstants.whiteColor,
            child: SafeArea(
              child: Column(
                children: <Widget>[
                  Expanded(child: Container()),
                  TabBar(
                    labelColor: ColorConstants.primaryColor,
                    unselectedLabelColor: ColorConstants.iconColor,
                    unselectedLabelStyle: TextStyle(fontSize: 13),
                    labelStyle: TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
                    indicatorColor: ColorConstants.primaryColor,
                    tabs: list,
                  ),
                ],
              ),
            ),
          ),
        ),
        body: TabBarView(
          children: <Widget>[

            UpcomingTab(),
            CompletedTab(),
            CanceledTab(),

          ],
        ),
      ),
    );
  }

  getTabTitles() {

    if(list != null && list.length != 0)
      list.clear();

    list.add(Tab(text: Languages.of(context).upcomingTabTitle));
    list.add(Tab(text: Languages.of(context).completedTabTitle));
    list.add(Tab(text: Languages.of(context).canceledTabTitle));

  }


  Widget signedOutLayout() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [

          Text(Languages.of(context).userNotLoggedInText, style: TextStyle(fontFamily: 'Quicksand', fontSize: 20, fontWeight: FontWeight.bold, color: ColorConstants.black,)),
          SizedBox(
            height: 8,
          ),
          Text(Languages.of(context).pleaseLoginText, style: TextStyle(fontFamily: 'Quicksand', fontSize: 18, color: ColorConstants.black,)),
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



  Future<OTPResponse> _getUserDataFromSharedPref() async {

    OTPResponse userData;

    if(await SharedPref.checkIfKeyExistsInSharedPref(AppConstants.user_data)) {
      userData = OTPResponse.fromJson(await SharedPref.read(AppConstants.user_data));
    }
    else {
      userData = null;
    }

    return userData;
  }


}
