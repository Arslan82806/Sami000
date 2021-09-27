import 'dart:convert';
import 'package:beauty_saloon/localization/language/languages.dart';
import 'package:beauty_saloon/model/cancel_appointment_response.dart';
import 'package:beauty_saloon/model/otp_response.dart';
import 'package:beauty_saloon/model/upcoming_appointments_model.dart';
import 'package:beauty_saloon/utils/app_constants.dart';
import 'package:beauty_saloon/utils/color_constants.dart';
import 'package:beauty_saloon/utils/shared_prefs.dart';
import 'package:beauty_saloon/utils/static_data.dart';
import 'package:beauty_saloon/utils/styles.dart';
import 'package:beauty_saloon/utils/utils.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;

class UpcomingTab extends StatefulWidget {

  /*final String userId;
  UpcomingTab(this.userId);*/

  @override
  _UpcomingTabState createState() => _UpcomingTabState();
}

class _UpcomingTabState extends State<UpcomingTab> {

  UpcomingAppointmentsModel upcomingAppointments;
  //List<UpcomingAppointmentsModel> _upcomingAppointmentsList = [];
  CancelAppointmentResponse cancelAppointment;

  bool isLoading = true;
  bool isLoading2 = false;
  bool hasUpcomingAppoint = false;

  @override
  void initState() {
    //_getAllUpcomingAppointments();

    _getUserDataFromSharedPref().then((value) => {

      print('sending user id: ${value.data.id.toString()}'),
      StaticData.userData = value,

      _getUpcomingAppointments(StaticData.userData.data.id.toString()).then((value) => {


        setState(() {
          upcomingAppointments = value;
          isLoading = false;
        }),


      }),

    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return isLoading ? Utils.buildLoading() : SingleChildScrollView(
      child: Center(
        child: upcomingAppointments == null ? Padding(
          padding: EdgeInsets.symmetric(vertical: 80.0),
          child: Utils.emptyLayout(Languages.of(context).noUpcomingAppointmentsText),
        ) :
        Stack(
          alignment: AlignmentDirectional.center,
          children: [

            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [

                ListView.builder(
                  scrollDirection: Axis.vertical,
                  itemCount: upcomingAppointments.data.length,
                  shrinkWrap: true,
                  primary: false,
                  padding: EdgeInsets.all(8.0),
                  itemBuilder: (BuildContext context, int index) {

                    return Container(
                      padding: EdgeInsets.all(16.0),
                      margin: EdgeInsets.symmetric(vertical: 4.0),
                      decoration: BoxDecoration(
                          border: Border.all(
                            color: Colors.grey.withOpacity(0.4),
                            width: 2.0,
                          ),
                          borderRadius: BorderRadius.all(Radius.circular(8.0))),
                      child: Column(
                        children: [
                          //first row
                          Row(
                            children: [
                              SizedBox(
                                width: 60,
                                height: 60,
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(8.0),
                                  child: CachedNetworkImage(
                                    fit: BoxFit.cover,
                                    imageUrl: upcomingAppointments.data[index].salon.image,
                                    progressIndicatorBuilder:
                                        (context, url, downloadProgress) =>
                                        CupertinoActivityIndicator(),
                                    errorWidget: (context, url, error) =>
                                        Icon(Icons.error),
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: 16,
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [

                                  Text(upcomingAppointments.data[index].salon.salonName,
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                      style: listViewItemHeading
                                  ),

                                  SizedBox(
                                    height: 8.0,
                                  ),

                                  Row(
                                    children: [

                                      Icon(Icons.star, color: ColorConstants.ratingStarColor, size: 16,),

                                      SizedBox(
                                        width: 4,
                                      ),

                                      Text('${double.parse(upcomingAppointments.data[index].salon.ratings).toStringAsFixed(1)}', style: TextStyle(fontSize: 12,)),
                                      SizedBox(
                                        width: 8,
                                      ),

                                      Icon(Icons.circle, size: 4,),

                                      SizedBox(
                                        width: 8,
                                      ),

                                      Icon(Icons.calendar_today_outlined, size: 16),

                                      SizedBox(
                                        width: 4,
                                      ),

                                      Text('${upcomingAppointments.data[index].appointmentDate} ${upcomingAppointments.data[index].appointmentTime}', style: TextStyle(fontSize: 12,),),

                                    ],
                                  ),


                                  SizedBox(
                                    height: 8.0,
                                  ),

                                  Row(
                                    children: [
                                      Text(Languages.of(context).totalPriceUpcoming +': '),
                                      Text(upcomingAppointments.data[index].totalPrice +' SAR',
                                        style: TextStyle(color: ColorConstants.greenColor),
                                      ),
                                    ],
                                  ),

                                  SizedBox(
                                    height: 8.0,
                                  ),

                                  Row(
                                    children: [
                                      Text(Languages.of(context).statusUpcoming +': '),
                                      Text(upcomingAppointments.data[index].isApproved == '1' ? 'Approved' : 'Not approved',
                                          style: TextStyle(color: upcomingAppointments.data[index].isApproved == '1' ? ColorConstants.greenColor :
                                            ColorConstants.redColor),
                                      ),
                                    ],
                                  ),


                                ],
                              ),
                            ],
                          ),

                          Divider(
                            height: 32,
                            color: ColorConstants.greyColor,
                          ),

                          //2nd row
                          Row(
                            children: [

                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [

                                    Text(Languages.of(context).serviceTypeUpcoming, style: smallTextStyleGrey),

                                    SizedBox(
                                      height: 8.0,
                                    ),

                                    ListView.builder(
                                      scrollDirection: Axis.vertical,
                                      itemCount: upcomingAppointments.data[index].appointment.length,
                                      shrinkWrap: true,
                                      primary: false,
                                      itemBuilder: (BuildContext context, int servicesIndex) {
                                        return Text(upcomingAppointments.data[index].appointment[servicesIndex].serviceName, style: smallTextStyleBlack,);
                                      },),


                                  ],
                                ),
                              ),

                              InkWell(
                                onTap: () {

                                  //call cancel booking api
                                  _cancelAppointment(upcomingAppointments.data[index].id.toString()).then((value) => {

                                    if(value.status) {

                                      _removeCanceledAppointmentFromList(
                                          upcomingAppointments.data[index].id
                                              .toString()),
                                      setState(() {
                                        isLoading2 = false;
                                      }),

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

                                  });

                                },
                                child: Row(
                                  children: [
                                    Icon(Icons.delete_outline, color: ColorConstants.redColor),
                                    SizedBox(width: 8),
                                    Text(Languages.of(context).cancelBookingUpcoming, style: TextStyle(fontFamily: 'Quicksand', color: ColorConstants.redColor, fontWeight: FontWeight.bold)),
                                  ],
                                ),
                              ),


                            ],
                          ),

                        ],
                      ),
                    );
                  },
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
    );
  }

  /*_getAllUpcomingAppointments() {
    List<String> services = [];
    services.add('Hair Color');
    services.add('Manicure');
    services.add('Pedicure');

    _upcomingAppointmentsList.add(UpcomingAppointmentsModel(
        'https://picsum.photos/seed/picsum/200/300',
        'Barberque Nation',
        '4.5',
        '2021/4/3 5:00pm',
        'Cancel Booking',
        services));

    List<String> services2 = [];
    services2.add('Party Makeup');
    services2.add('Manicure');

    _upcomingAppointmentsList.add(UpcomingAppointmentsModel(
        'https://picsum.photos/seed/picsum/200/300',
        'Barberque Nation',
        '4.5',
        '2021/4/3 1:15pm',
        'Cancel Booking',
        services2));

    List<String> services3 = [];
    services3.add('Hair Color');

    _upcomingAppointmentsList.add(UpcomingAppointmentsModel(
        'https://picsum.photos/seed/picsum/200/300',
        'Barberque Nation',
        '4.0',
        '2021/5/8 2:30pm',
        'Cancel Booking',
        services3));

    List<String> services4 = [];
    services4.add('Hair Color');

    _upcomingAppointmentsList.add(UpcomingAppointmentsModel(
        'https://picsum.photos/seed/picsum/200/300',
        'Barberque Nation',
        '5.0',
        '2021/1/6 3:00pm',
        'Cancel Booking',
        services4));

    List<String> services5 = [];
    services5.add('Party Makeup');
    _upcomingAppointmentsList.add(UpcomingAppointmentsModel(
        'https://picsum.photos/seed/picsum/200/300',
        'Barberque Nation',
        '4.6',
        '2021/2/2 2:45pm',
        'Cancel Booking',
        services5));
  }*/

  Future<UpcomingAppointmentsModel> _getUpcomingAppointments(String userId) async {

    String url = '${AppConstants.baseURL}/api/get-appointment';
    UpcomingAppointmentsModel upcomingAppointmentsModel;

    setState(() {
      isLoading = true;
    });

    var response = await http.post(
        url,
        headers: {
          "APP_KEY": AppConstants.APP_KEY,
        },
        body: {
          "user_id": userId,
        });


    // check the status code for the result
    int statusCode = response.statusCode;

    if (statusCode == 200) {

      upcomingAppointmentsModel = UpcomingAppointmentsModel.fromJson(jsonDecode(response.body));

      /*setState(() {
        isLoading = false;
      });*/

      return upcomingAppointmentsModel;

    }
    else {

      //display something went wrong message
      print('status code: $statusCode');
      print('something went wrong ! ${response.body}');

      /*setState(() {
        isLoading = false;
      });*/

      return upcomingAppointmentsModel;
    }
    //end if

  }

  Future<OTPResponse> _getUserDataFromSharedPref() async {

    //SignInResponse userData;
    OTPResponse userData;

    if(await SharedPref.checkIfKeyExistsInSharedPref(AppConstants.user_data)) {
      userData = OTPResponse.fromJson(await SharedPref.read(AppConstants.user_data));
    }
    else {
      userData = null;
    }

    return userData;
  }


  Future<CancelAppointmentResponse> _cancelAppointment(String receiptId) async {

    String url = '${AppConstants.baseURL}/api/cancel-appointment';
    CancelAppointmentResponse cancelAppointmentResponse;

    setState(() {
      isLoading2 = true;
    });

    var response = await http.post(
        url,
        headers: {
          "APP_KEY": AppConstants.APP_KEY,
        },
        body: {
          "recipt_id": receiptId,
        });


    // check the status code for the result
    int statusCode = response.statusCode;

    if (statusCode == 200) {

      cancelAppointmentResponse = CancelAppointmentResponse.fromJson(jsonDecode(response.body));

      return cancelAppointmentResponse;

    }
    else {

      //display something went wrong message
      print('status code: $statusCode');
      print('something went wrong ! ${response.body}');


      return cancelAppointmentResponse;
    }
    //end if

  }

  _removeCanceledAppointmentFromList(String id) {

    for(int i=0; i<upcomingAppointments.data.length; i++) {
      if(upcomingAppointments.data[i].id.toString() == id) {
        upcomingAppointments.data.removeAt(i);

        //break out of loop
        i = upcomingAppointments.data.length;
      }
    }

  }

}
