import 'package:beauty_saloon/components/custom_button_2.dart';
import 'package:beauty_saloon/localization/language/languages.dart';
import 'package:beauty_saloon/model/otp_response.dart';
import 'package:beauty_saloon/model/sliders_response.dart';
import 'package:beauty_saloon/pages/about/about_page.dart';
import 'package:beauty_saloon/pages/appointments/appointments_page.dart';
import 'package:beauty_saloon/pages/favourite_salons/favourite_salons_page.dart';
import 'package:beauty_saloon/pages/home_page/home_page.dart';
import 'package:beauty_saloon/pages/notifications/notifications_page.dart';
import 'package:beauty_saloon/pages/profile/profile_page.dart';
import 'package:beauty_saloon/screens/search_salon/search_salon_screen.dart';
import 'package:beauty_saloon/screens/settings/settings_screen.dart';
import 'package:beauty_saloon/screens/sign_in/sign_in_screen.dart';
import 'package:beauty_saloon/utils/app_constants.dart';
import 'package:beauty_saloon/utils/color_constants.dart';
import 'package:beauty_saloon/utils/shared_prefs.dart';
import 'package:beauty_saloon/utils/static_data.dart';
import 'package:beauty_saloon/utils/utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:share/share.dart';
import 'package:url_launcher/url_launcher.dart';

class HomeScreen extends StatefulWidget {

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  //persistant bottom navigation
  PersistentTabController controller = PersistentTabController(initialIndex: 0);

  String appbarTitle;
  bool isUserLoggedIn = false;
  bool rememberMeStatus;

  bool isLoading = true;

  //OTPResponse userData;

  List<Widget> _pages = <Widget>[

    HomePage(),
    AppointmentsPage(),
    FavouriteSalonsPage(),
    NotificationsPage(),
    ProfilePage(),

  ];


  @override
  void initState() {

    _getRememberMeStatus();
    _getUserDataFromSharedPref().then((value) => {

      setState(() {
        StaticData.userData = value;
        isLoading = false;
      }),

    });


    /*print('remember me status outside: $rememberMeStatus');
    print('user data outside: ${signInResponse.data.name}');*/

    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    appbarTitle = Languages.of(context).homeScreenTitle;

    print('is user logged in: $isUserLoggedIn');
    print('user data: ${StaticData.userData}');

  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text(appbarTitle, style: TextStyle(fontFamily: 'Quicksand', color: ColorConstants.whiteColor)),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {

              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => SearchSalonScreen(),
                ),
              );

            },
          ),
        ],
      ),
      drawer: Drawer(
        child: SafeArea(
          child: ListView(
            padding: EdgeInsets.zero,
            children: <Widget>[

              Column(
                children: [

                  Image.asset(
                    'assets/images/salon_logo.png',
                    width: 140,
                  ),

                  SizedBox(
                    height: 8,
                  ),

                  //isUserLoggedIn ? welcomeUser() : Container(),
                  //isUserLoggedIn || signInResponse != null ? welcomeUser() : Container(),
                  (isUserLoggedIn || StaticData.userData != null) ? welcomeUser() : Container(),
                  SizedBox(height: 16,),

                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
                    //child: isUserLoggedIn || signInResponse != null ? CustomButton2(
                    child: (isUserLoggedIn || StaticData.userData != null)  ? CustomButton2(
                      text: Languages.of(context).navBarLogoutButtonText,
                      callback: () async {

                        //logout button

                        int result = await Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => SignInScreen(),
                          ),
                        );

                        print('result: $result');

                        if(result != 1) {

                          setState(() {
                            isUserLoggedIn = false;
                            //signInResponse = null;
                            StaticData.userData = null;
                          });

                          //clear user data on logout
                          //SharedPref.save(AppConstants.user_data, '');
                          SharedPref.remove(AppConstants.user_data);

                          controller.jumpToTab(0);


                        }
                      else {

                        //signInResponse = SignInResponse.fromJson(await SharedPref.read(AppConstants.user_data));
                          StaticData.userData = OTPResponse.fromJson(await SharedPref.read(AppConstants.user_data));
                        setState(() {
                          isUserLoggedIn = true;
                        });
                      }


                      },
                    ) : CustomButton2(
                      text: Languages.of(context).navBarLoginSignUp,
                      callback: () async {

                        int result  = await Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => SignInScreen(),
                          ),
                        );

                        print('result from sign in screen: $result');

                        if(result == 1) {

                          //signInResponse = SignInResponse.fromJson(await SharedPref.read(AppConstants.user_data));
                          StaticData.userData = OTPResponse.fromJson(await SharedPref.read(AppConstants.user_data));

                          //print('loginData: ${signInResponse.data.name}');


                          setState(() {
                            isUserLoggedIn = true;
                          });
                        }

                      },
                    ),
                  ),

                  /*Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
                    child: CustomButton3(
                      text: Languages.of(context).navBarLoginAsPartener,
                      callback: () {

                      },
                    ),
                  ),*/



                ],
              ),

              ListTile(
                leading: Icon(Icons.home),
                title: Text(Languages.of(context).navBarBeautyNews),
                onTap: () {

                  // Then close the drawer
                  Navigator.pop(context);



                  //controller.jumpToTab(0);

                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(
                      builder: (context) => HomeScreen(),
                    ),
                  );




                },
              ),
              ListTile(
                leading: Icon(Icons.info_outline),
                title: Text(Languages.of(context).navBarAbout),
                onTap: () {
                  // Then close the drawer

                  Navigator.pop(context);

                  pushNewScreen(
                    context,
                    screen: AboutPage(),
                    withNavBar: true, // OPTIONAL VALUE. True by default.
                    pageTransitionAnimation: PageTransitionAnimation.cupertino,
                  );

                },
              ),

              ListTile(
                leading: Icon(Icons.settings),
                title: Text(Languages.of(context).navBarSettings),
                onTap: () {

                  Navigator.pop(context);

                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => SettingsScreen(),
                    ),
                  );


                },
              ),


              ListTile(
                leading: Icon(Icons.share),
                title: Text(Languages.of(context).navBarShare),
                onTap: () {
                  // Then close the drawer
                  Navigator.pop(context);

                  Share.share('check out Sami Salon Application', subject: 'Sami');

                },
              ),


              ListTile(
                leading: Icon(Icons.star),
                title: Text(Languages.of(context).navBarRateApp),
                onTap: () {
                  // Then close the drawer
                  Navigator.pop(context);

                  try {
                    launch("market://details?id=" + 'com.test.beauty_saloon');
                  } on PlatformException catch(e) {
                    launch("https://play.google.com/store/apps/details?id=" + 'com.test.beauty_saloon');
                  } finally {
                    launch("https://play.google.com/store/apps/details?id=" + 'com.test.beauty_saloon');
                  }

                },
              ),


            ],
          ),
        ),
      ),
      body: isLoading ? Utils.buildLoading() : PersistentTabView(
        controller: controller,
        navBarHeight: MediaQuery.of(context).size.width > 768 ?  90 : 64,
        onItemSelected: (item) {
          int index = controller.index;

          //_onItemTapped(index);

          if(index == 0) {

            setState(() {
              appbarTitle = Languages.of(context).homeScreenTitle;
            });

          }
          else if(index == 1) {

            setState(() {
              appbarTitle = Languages.of(context).appointmentsScreenTitle;
            });

          }
          else if(index == 2) {

            setState(() {
              appbarTitle = Languages.of(context).favouriteScreenTitle;
            });

          }
          else if(index == 3) {

            setState(() {
              appbarTitle = Languages.of(context).notificationsScreenTitle;
            });

          }
          else if(index == 4) {

            setState(() {
              appbarTitle = Languages.of(context).accountScreenTitle;
            });
          }


        },
        screens: _pages,
        items: [

          PersistentBottomNavBarItem(
              /*icon: Column(
                children: [
                  Icon(Icons.home_outlined),
                  SizedBox(
                    height: 4,
                  ),
                  Text(Languages.of(context).bottomNavHome, style: TextStyle(fontSize: 10, color: _selectedIndex == 0 ? ColorConstants.primaryColor : ColorConstants.iconColor)),
                ],
              ),*/
              icon: Icon(Icons.home_outlined, size: MediaQuery.of(context).size.width > 768 ?  40 : 24,),
              title: Languages.of(context).bottomNavHome,
              activeColor: ColorConstants.primaryColor,
              inactiveColor: ColorConstants.iconColor,
              titleStyle: TextStyle(fontSize: MediaQuery.of(context).size.width > 768 ?  20 : 12)),

          PersistentBottomNavBarItem(
              icon: Icon(Icons.calendar_today_outlined, size: MediaQuery.of(context).size.width > 768 ?  40 : 24,),
              title: Languages.of(context).bottomNavAppointments,
              activeColor: ColorConstants.primaryColor,
              inactiveColor: ColorConstants.iconColor,
              titleStyle: TextStyle(fontSize: MediaQuery.of(context).size.width > 768 ?  20 : 12)),

          PersistentBottomNavBarItem(
              icon: Icon(Icons.favorite_border, size: MediaQuery.of(context).size.width > 768 ?  40 : 24,),
              title: Languages.of(context).bottomNavFavourites,
              activeColor: ColorConstants.primaryColor,
              inactiveColor: ColorConstants.iconColor,
              titleStyle: TextStyle(fontSize: MediaQuery.of(context).size.width > 768 ?  20 : 12)),

          PersistentBottomNavBarItem(
              icon: Icon(Icons.notifications, size: MediaQuery.of(context).size.width > 768 ?  40 : 24,),
              title: Languages.of(context).bottomNavNotifications,
              activeColor: ColorConstants.primaryColor,
              inactiveColor: ColorConstants.iconColor,
              titleStyle: TextStyle(fontSize: MediaQuery.of(context).size.width > 768 ?  20 : 12)),

          PersistentBottomNavBarItem(
              icon: Icon(Icons.person_outline, size: MediaQuery.of(context).size.width > 768 ?  40 : 24,),
              title: Languages.of(context).bottomNavAccount,
              activeColor: ColorConstants.primaryColor,
              inactiveColor: ColorConstants.iconColor,
              titleStyle: TextStyle(fontSize: MediaQuery.of(context).size.width > 768 ?  20 : 12)),

        ],
        confineInSafeArea: true,
        backgroundColor: Colors.white,
        handleAndroidBackButtonPress: true,
        resizeToAvoidBottomInset: true,
        // This needs to be true if you want to move up the screen when keyboard appears.
        stateManagement: false,
        hideNavigationBarWhenKeyboardShows: true,
        // Recommended to set 'resizeToAvoidBottomInset' as true while using this argument.
        decoration: NavBarDecoration(
          border: Border.all(color: Colors.white),
          borderRadius: BorderRadius.circular(1.0),
          colorBehindNavBar: Colors.black,
        ),
        popAllScreensOnTapOfSelectedTab: true,
        popActionScreens: PopActionScreensType.all,
        itemAnimationProperties: ItemAnimationProperties(
          // Navigation Bar's items animation properties.
          duration: Duration(milliseconds: 200),
          curve: Curves.ease,
        ),
        screenTransitionAnimation: ScreenTransitionAnimation(
          // Screen transition animation on change of selected tab.
          animateTabTransition: true,
          curve: Curves.ease,
          duration: Duration(milliseconds: 200),
        ),
        navBarStyle: NavBarStyle.style6,

      ),
    );
  }

  Widget welcomeUser() {

    //return Text('Welcome ${signInResponse.data.name}');
    return Text(Languages.of(context).welcomeHeaderText +' ${StaticData.userData.data.name}');
  }

  _getRememberMeStatus() async {
    rememberMeStatus = await SharedPref.read(AppConstants.prefRememberMe);
    print('remember me status: $rememberMeStatus');
  }

  //Future<SignInResponse> _getUserDataFromSharedPref() async {
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

}
