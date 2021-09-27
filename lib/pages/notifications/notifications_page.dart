import 'package:beauty_saloon/components/custom_app_bar.dart';
import 'package:beauty_saloon/components/custom_button_2.dart';
import 'package:beauty_saloon/localization/language/languages.dart';
import 'package:beauty_saloon/model/notifications_model.dart';
import 'package:beauty_saloon/screens/sign_in/sign_in_screen.dart';
import 'package:beauty_saloon/utils/color_constants.dart';
import 'package:beauty_saloon/utils/utils.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:beauty_saloon/utils/app_constants.dart';
import 'package:beauty_saloon/model/otp_response.dart';
import 'package:beauty_saloon/utils/shared_prefs.dart';
import 'package:beauty_saloon/utils/static_data.dart';
import 'package:beauty_saloon/model/all_notifications_response.dart';
import 'package:http/http.dart' as http;
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';

class NotificationsPage extends StatefulWidget {
  @override
  _NotificationsPageState createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<NotificationsPage> {
  List<NotificationsModel> _notificationsList = [];

  AllNotificationsResponse allNotifications;
  bool isLoading = true;

  @override
  void initState() {
    //_getAllNotifications();

    _getUserDataFromSharedPref().then((value) => {
          if (value != null)
            {
              print('sending user id: ${value.data.id.toString()}'),
              StaticData.userData = value,
              _getAllNotifications(StaticData.userData.data.id.toString())
                  .then((value) => {
                        setState(() {
                          allNotifications = value;
                          isLoading = false;
                        }),
                      }),
            }
          else
            {
              setState(() {
                isLoading = false;
              }),
            }
        });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: isLoading
          ? Utils.buildLoading()
          : StaticData.userData == null
              ? signedOutLayout()
              : SingleChildScrollView(
                  child: allNotifications == null
                      ? Utils.emptyLayout('No notifications')
                      : Container(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              ListView.builder(
                                scrollDirection: Axis.vertical,
                                itemCount: allNotifications.data.length,
                                shrinkWrap: true,
                                primary: false,
                                padding: EdgeInsets.all(16.0),
                                itemBuilder: (BuildContext context, int index) {
                                  return Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        SizedBox(
                                          width: MediaQuery.of(context).size.width > 768 ? 100 : 70,
                                          height: MediaQuery.of(context).size.width > 768 ? 100 : 70,
                                          child: Icon(Icons.info_outline,
                                              color: ColorConstants
                                                  .primaryColor, size: MediaQuery.of(context).size.width > 768 ? 50 : 24,), /*ClipRRect(
                            borderRadius: BorderRadius.circular(8.0),
                            child: CachedNetworkImage(
                              fit: BoxFit.cover,
                              imageUrl: _notificationsList[index].image,
                              progressIndicatorBuilder: (context, url, downloadProgress) =>
                                  CupertinoActivityIndicator(),
                              errorWidget: (context, url, error) => Icon(Icons.error),
                            ),
                          ),*/
                                        ),
                                        SizedBox(
                                          width: 16,
                                        ),
                                        Expanded(
                                          flex: 3,
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                allNotifications
                                                    .data[index].title
                                                    .toUpperCase(),
                                                overflow: TextOverflow.ellipsis,
                                                maxLines: 2,
                                                style: TextStyle(
                                                  fontFamily: 'Quicksand',
                                                  fontSize: MediaQuery.of(context).size.width > 768 ? 22 : 15,
                                                  fontWeight: FontWeight.bold,
                                                  color: ColorConstants.black,
                                                ),
                                              ),
                                              SizedBox(
                                                height: 4,
                                              ),
                                              Text(
                                                allNotifications
                                                    .data[index].message
                                                    .toUpperCase(),
                                                overflow: TextOverflow.ellipsis,
                                                maxLines: 4,
                                                style: TextStyle(
                                                  fontFamily: 'Quicksand',
                                                  fontSize: MediaQuery.of(context).size.width > 768 ? 18 : 12,
                                                  fontWeight: FontWeight.normal,
                                                  color: ColorConstants.black,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              ),
                            ],
                          ),
                        ),
                ),
    );
  }

  /*_getAllNotifications() {

    _notificationsList.add(NotificationsModel('https://picsum.photos/200', 'Booking Status', 'Lorem ipsum dolor sit amet, consectetur adipiscing elit. In non finibus justo, sed semper orci. Class aptent taciti sociosqu ad litora torquent per conubia nostra, per inceptos himenaeos. Phasellus bibendum ligula eget condimentum consequat.'));
    _notificationsList.add(NotificationsModel('https://picsum.photos/200', 'Booking Status', 'Lorem ipsum dolor sit amet, consectetur adipiscing elit. In non finibus justo, sed semper orci. Class aptent taciti sociosqu ad litora torquent per conubia nostra, per inceptos himenaeos. Phasellus bibendum ligula eget condimentum consequat.'));
    _notificationsList.add(NotificationsModel('https://picsum.photos/200', 'Booking Status', 'Lorem ipsum dolor sit amet, consectetur adipiscing elit. In non finibus justo, sed semper orci. Class aptent taciti sociosqu ad litora torquent per conubia nostra, per inceptos himenaeos. Phasellus bibendum ligula eget condimentum consequat.'));
    _notificationsList.add(NotificationsModel('https://picsum.photos/200', 'Booking Status', 'Lorem ipsum dolor sit amet, consectetur adipiscing elit. In non finibus justo, sed semper orci. Class aptent taciti sociosqu ad litora torquent per conubia nostra, per inceptos himenaeos. Phasellus bibendum ligula eget condimentum consequat.'));
    _notificationsList.add(NotificationsModel('https://picsum.photos/200', 'Booking Status', 'Lorem ipsum dolor sit amet, consectetur adipiscing elit. In non finibus justo, sed semper orci. Class aptent taciti sociosqu ad litora torquent per conubia nostra, per inceptos himenaeos. Phasellus bibendum ligula eget condimentum consequat.'));
    _notificationsList.add(NotificationsModel('https://picsum.photos/200', 'Booking Status', 'Lorem ipsum dolor sit amet, consectetur adipiscing elit. In non finibus justo, sed semper orci. Class aptent taciti sociosqu ad litora torquent per conubia nostra, per inceptos himenaeos. Phasellus bibendum ligula eget condimentum consequat.'));
    _notificationsList.add(NotificationsModel('https://picsum.photos/200', 'Booking Status', 'Lorem ipsum dolor sit amet, consectetur adipiscing elit. In non finibus justo, sed semper orci. Class aptent taciti sociosqu ad litora torquent per conubia nostra, per inceptos himenaeos. Phasellus bibendum ligula eget condimentum consequat.'));
    _notificationsList.add(NotificationsModel('https://picsum.photos/200', 'Booking Status', 'Lorem ipsum dolor sit amet, consectetur adipiscing elit. In non finibus justo, sed semper orci. Class aptent taciti sociosqu ad litora torquent per conubia nostra, per inceptos himenaeos. Phasellus bibendum ligula eget condimentum consequat.'));

  }*/

  Future<AllNotificationsResponse> _getAllNotifications(String userId) async {
    String url = '${AppConstants.baseURL}/api/specific-notifications';
    AllNotificationsResponse allNotificationsResponse;

    setState(() {
      isLoading = true;
    });

    var response = await http.post(url, headers: {
      "APP_KEY": AppConstants.APP_KEY,
    }, body: {
      "user_id": userId,
    });

    // check the status code for the result
    int statusCode = response.statusCode;

    if (statusCode == 200) {
      allNotificationsResponse =
          AllNotificationsResponse.fromJson(jsonDecode(response.body));

      /*setState(() {
        isLoading = false;
      });*/

      return allNotificationsResponse;
    } else {
      //display something went wrong message
      print('status code: $statusCode');
      print('something went wrong ! ${response.body}');

      setState(() {
        isLoading = false;
      });

      return allNotificationsResponse;
    }
    //end if
  }

  Future<OTPResponse> _getUserDataFromSharedPref() async {
    //SignInResponse userData;
    OTPResponse userData;

    if (await SharedPref.checkIfKeyExistsInSharedPref(AppConstants.user_data)) {
      userData =
          OTPResponse.fromJson(await SharedPref.read(AppConstants.user_data));
    } else {
      userData = null;
    }

    return userData;
  }

  Widget signedOutLayout() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(Languages.of(context).userNotLoggedInText,
              style: TextStyle(
                fontFamily: 'Quicksand',
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: ColorConstants.black,
              )),
          SizedBox(
            height: 8,
          ),
          Text(
              Languages.of(context).pleaseLoginText,
              style: TextStyle(
                fontFamily: 'Quicksand',
                fontSize: 18,
                color: ColorConstants.black,
              )),
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

                      setState(() {
                        isLoading = true;
                      }),

                      _getUserDataFromSharedPref().then((value) => {
                            if (value != null)
                              {

                                StaticData.userData = value,
                                _getAllNotifications(
                                        StaticData.userData.data.id.toString())
                                    .then((value) => {
                                          setState(() {
                                            allNotifications = value;
                                            isLoading = false;
                                          }),
                                        }),
                              }
                            else
                              {
                                setState(() {
                                  isLoading = false;
                                }),
                              }
                          }),

                    });

              }),
        ],
      ),
    );
  }
}
