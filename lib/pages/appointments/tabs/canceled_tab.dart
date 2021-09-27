import 'dart:convert';
import 'package:beauty_saloon/localization/language/languages.dart';
import 'package:beauty_saloon/model/canceled_appointments_model.dart';
import 'package:beauty_saloon/utils/app_constants.dart';
import 'package:beauty_saloon/utils/color_constants.dart';
import 'package:beauty_saloon/utils/static_data.dart';
import 'package:beauty_saloon/utils/styles.dart';
import 'package:beauty_saloon/utils/utils.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;


class CanceledTab extends StatefulWidget {
  @override
  _CanceledTabState createState() => _CanceledTabState();
}

class _CanceledTabState extends State<CanceledTab> {

  //List<CanceledAppointmentsModel> _canceledAppointmentsList = [];

  CanceledAppointmentsModel canceledAppointments;
  bool isLoading = true;

  @override
  void initState() {

    //_getAllCanceledAppointments();
    _getCanceledAppointments(StaticData.userData.data.id.toString()).then((value) => {

      setState(() {
        canceledAppointments = value;
        isLoading = false;
      }),

    });

    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return isLoading ? Utils.buildLoading() : SingleChildScrollView(
      child: Center(
        child: canceledAppointments == null ? Padding(
          padding: EdgeInsets.symmetric(vertical: 80.0),
          child: Utils.emptyLayout(Languages.of(context).noCanceledAppointmentsText),
        ) : Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            ListView.builder(
              scrollDirection: Axis.vertical,
              itemCount: canceledAppointments.data.length,
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
                                imageUrl: canceledAppointments.data[index].salon.image,
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

                              Text(canceledAppointments.data[index].salon.salonName,
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

                                  Text('${double.parse(canceledAppointments.data[index].salon.ratings).toStringAsFixed(1)}', style: TextStyle(fontSize: 12,)),
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

                                  Text('${canceledAppointments.data[index].appointmentDate} ${canceledAppointments.data[index].appointmentTime}', style: TextStyle(fontSize: 12,),),

                                ],
                              ),

                              SizedBox(
                                height: 8.0,
                              ),

                              Row(
                                children: [
                                  Text(Languages.of(context).totalPriceCancelled +': '),
                                  Text(canceledAppointments.data[index].totalPrice +' SAR',
                                    style: TextStyle(color: ColorConstants.greenColor),
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

                                Text(Languages.of(context).serviceTypeCancelled, style: smallTextStyleGrey),

                                SizedBox(
                                  height: 8.0,
                                ),

                                ListView.builder(
                                  scrollDirection: Axis.vertical,
                                  itemCount: canceledAppointments.data[index].appointment.length,
                                  shrinkWrap: true,
                                  primary: false,
                                  itemBuilder: (BuildContext context, int servicesIndex) {
                                    return Text(canceledAppointments.data[index].appointment[servicesIndex].serviceName, style: smallTextStyleBlack,);
                                  },),


                              ],
                            ),
                          ),

                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Row(
                                children: [

                                  Icon(Icons.delete_outline, color: ColorConstants.whiteColor, size: 16),

                                  SizedBox(width: 8),
                                  Text(Languages.of(context).cancelledText, style: TextStyle(fontFamily: 'Quicksand', color: ColorConstants.redColor, fontWeight: FontWeight.bold)),
                                ],
                              ),

                              /*Row(
                                children: [
                                  Text(_canceledAppointmentsList[index].givenRating, style: normalTextStyleBlack),
                                  SizedBox(width: 4.0),
                                  Icon(Icons.star, color: ColorConstants.ratingStarColor),
                                ],
                              ),*/


                            ],
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
      ),
    );
  }

  /*_getAllCanceledAppointments() {

    List<String> services = [];
    services.add('Hair Color');
    services.add('Manicure');
    services.add('Pedicure');

    _canceledAppointmentsList.add(CanceledAppointmentsModel(
        'https://picsum.photos/seed/picsum/200/300',
        'Barberque Nation',
        '4.5',
        '2021/4/3 5:00pm',
        'Cancel Booking',
        '4.0',
        services));

    List<String> services2 = [];
    services2.add('Party Makeup');
    services2.add('Manicure');

    _canceledAppointmentsList.add(CanceledAppointmentsModel(
        'https://picsum.photos/seed/picsum/200/300',
        'Barberque Nation',
        '4.5',
        '2021/4/3 1:15pm',
        'Cancel Booking',
        '4.5',
        services2));

    List<String> services3 = [];
    services3.add('Hair Color');

    _canceledAppointmentsList.add(CanceledAppointmentsModel(
        'https://picsum.photos/seed/picsum/200/300',
        'Barberque Nation',
        '4.0',
        '2021/5/8 2:30pm',
        'Cancel Booking',
        '5.0',
        services3));

    List<String> services4 = [];
    services4.add('Hair Color');

    _canceledAppointmentsList.add(CanceledAppointmentsModel(
        'https://picsum.photos/seed/picsum/200/300',
        'Barberque Nation',
        '5.0',
        '2021/1/6 3:00pm',
        'Cancel Booking',
        '4.5',
        services4));

    List<String> services5 = [];
    services5.add('Party Makeup');
    _canceledAppointmentsList.add(CanceledAppointmentsModel(
        'https://picsum.photos/seed/picsum/200/300',
        'Barberque Nation',
        '4.6',
        '2021/2/2 2:45pm',
        'Cancel Booking',
        '3.5',
        services5));
  }*/

  Future<CanceledAppointmentsModel> _getCanceledAppointments(String userId) async {

    String url = '${AppConstants.baseURL}/api/getcancel-appointment';
    CanceledAppointmentsModel canceledAppointmentsModel;

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

      canceledAppointmentsModel = CanceledAppointmentsModel.fromJson(jsonDecode(response.body));

      return canceledAppointmentsModel;

    }
    else {

      //display something went wrong message
      print('status code: $statusCode');
      print('something went wrong ! ${response.body}');


      return canceledAppointmentsModel;
    }
    //end if

  }



}
