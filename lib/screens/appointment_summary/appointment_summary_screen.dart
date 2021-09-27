import 'dart:convert';
import 'dart:io';
import 'package:beauty_saloon/components/custom_button_2.dart';
import 'package:beauty_saloon/localization/language/languages.dart';
import 'package:beauty_saloon/model/add_appointment_data.dart';
import 'package:beauty_saloon/model/add_appointment_response.dart';
import 'package:beauty_saloon/model/payment_data.dart';
import 'package:beauty_saloon/model/paytabs_response.dart';
import 'package:beauty_saloon/model/salon.dart';
import 'package:beauty_saloon/model/salon_categories_services_model.dart';
import 'package:beauty_saloon/utils/app_constants.dart';
import 'package:beauty_saloon/utils/color_constants.dart';
import 'package:beauty_saloon/utils/static_data.dart';
import 'package:beauty_saloon/utils/styles.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_paytabs_bridge/BaseBillingShippingInfo.dart';
import 'package:flutter_paytabs_bridge/PaymentSdkConfigurationDetails.dart';
import 'package:flutter_paytabs_bridge/PaymentSdkTokeniseType.dart';
import 'package:flutter_paytabs_bridge/PaymentSdkTransactionType.dart';
import 'package:flutter_paytabs_bridge/flutter_paytabs_bridge.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;

class AppointmentSummaryScreen extends StatefulWidget {

  final Salon salon;
  final SalonCategoriesServicesModel salonCategoriesAndServices;
  final String selectedDate;
  final String selectedTime;
  final double totalCharges;
  final String address;

  AppointmentSummaryScreen({@required this.salon, @required this.salonCategoriesAndServices,
    @required this.selectedDate, @required this.selectedTime, @required this.totalCharges, this.address});

  @override
  _AppointmentSummaryScreenState createState() => _AppointmentSummaryScreenState();
}

class _AppointmentSummaryScreenState extends State<AppointmentSummaryScreen> {

  AddAppointmentResponse appointmentResponse;
  List<ServicesList> services = [];
  bool isLoading = false;

  double homeServiceCharges = 0.0;
  double grandTotal = 0.0;

  PaytabsResponse paytabsResponse;
  PaymentData paymentData;

  @override
  void initState() {

    _getServicesNamesAndIds();

    print('userId: ${StaticData.userData.data.id.toString()}');


    print('address: ${widget.address}');
    if(widget.address.isNotEmpty) {

      //service type is home
      homeServiceCharges = double.parse(widget.salon.serviceCharges);
      grandTotal = widget.totalCharges + homeServiceCharges;

      print('has address');
      print('service charges: ${widget.salon.serviceCharges}');
      print('grand total: $grandTotal');
    }
    else {
      //service type is salon
      grandTotal = widget.totalCharges;

      print('no address');
    }


    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                Text(Languages.of(context).summaryHeadingText, style: TextStyle(fontFamily: 'Quicksand', fontSize: 24, fontWeight: FontWeight.bold)),

                SizedBox(height: 16,),

                Card(
                  elevation: 4.0,
                  child: Container(
                    padding: EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [

                        Text(Languages.of(context).salonNameSummary, style: normalTextStyleBlack),
                        Text(widget.salon.salonName, style: headingTextStyleBlack),

                        SizedBox(
                          height: 16,
                        ),

                        Text(Languages.of(context).countrySummary, style: normalTextStyleBlack),
                        Text(widget.salon.country.countryName, style: headingTextStyleBlack),

                        SizedBox(
                          height: 16,
                        ),

                        Text(Languages.of(context).citySummary, style: normalTextStyleBlack),
                        Text(widget.salon.city.cityName, style: headingTextStyleBlack),

                        SizedBox(
                          height: 16,
                        ),

                        Text(Languages.of(context).servicesSummary, style: headingTextStyleBlack),

                        SizedBox(
                          height: 4,
                        ),


                        ListView.builder(
                          scrollDirection: Axis.vertical,
                          itemCount: widget.salonCategoriesAndServices.data.length,
                          shrinkWrap: true,
                          primary: false,
                          itemBuilder: (BuildContext context, int index) {
                            return widget.salonCategoriesAndServices.data[index].isSelected ? Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text('${index+1}: ${widget.salonCategoriesAndServices.data[index].serviceName}'
                                      ' (${widget.salonCategoriesAndServices.data[index].serviceTime} min)',
                                  style: normalTextStyleBlack,),

                                  Text('${widget.salonCategoriesAndServices.data[index].servicePrice} SAR',
                                  style: normalTextStyleBlack,),

                                ],
                              ),

                            ) : Container();
                          },),


                        SizedBox(
                          height: 16,
                        ),

                        Text(Languages.of(context).dateSummary, style: normalTextStyleBlack),
                        Text(widget.selectedDate, style: headingTextStyleBlack),

                        SizedBox(
                          height: 16,
                        ),

                        Text(Languages.of(context).timeSummary, style: normalTextStyleBlack),
                        Text(widget.selectedTime, style: headingTextStyleBlack),

                        SizedBox(
                          height: 16,
                        ),

                        //address
                        Visibility(
                          visible: widget.address.isNotEmpty ? true : false,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [

                              Text(Languages.of(context).addressSummary, style: normalTextStyleBlack),
                              Text(widget.address, style: headingTextStyleBlack),

                            ],
                          ),
                        ),

                        SizedBox(
                          height: 16,
                        ),

                        Visibility(
                          visible: widget.address.isNotEmpty ? true : false,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(Languages.of(context).homeServiceChargesSummary, style: headingTextStyleBlack),

                                Text('\$${widget.salon.serviceCharges}', style: TextStyle(
                                    fontFamily: 'Quicksand',
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: ColorConstants.greenColor)),
                              ],
                            ),
                        ),

                        SizedBox(
                          height: 16,
                        ),


                        Divider(
                          color: ColorConstants.dividerColor
                        ),

                        //grand total charges row
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [

                            Text(Languages.of(context).totalServiceChargesSummary, style: headingTextStyleBlack),

                            Text('${grandTotal.toString()} SAR', style: TextStyle(
                                fontFamily: 'Quicksand',
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: ColorConstants.greenColor),
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                            ),

                          ],
                        ),

                        SizedBox(
                          height: 8,
                        ),

                        //salon charges apart from services charges
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(Languages.of(context).reservationChargesSummary, style: headingTextStyleBlack),

                            Text('${double.parse(StaticData.aboutResponse.data.commission)} SAR', style: TextStyle(
                                fontFamily: 'Quicksand',
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: ColorConstants.greenColor)),
                          ],
                        ),

                        SizedBox(
                          height: 10,
                        ),


                        Row(
                          children: [

                            Text('*', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20, color: ColorConstants.redColor)),

                            Text(Languages.of(context).deductionNoteSummary, style: TextStyle(fontFamily: 'Quicksand',
                                fontSize: 12, fontWeight: FontWeight.normal, color: ColorConstants.redColor), ),


                          ],
                        ),


                      ],
                    ),
                  ),
                ),

                SizedBox(
                  height: 20,
                ),

                CustomButton2(
                  text: Languages.of(context).payWithCardButtonText,
                  callback: () {
                    payPressed();
                  },
                ),

                SizedBox(
                  height: 8,
                ),

                Platform.isIOS ? CustomButton2(
                  text: Languages.of(context).applePayButtonText,
                  callback: () {
                    applePayPressed();
                  },
                ) : Container(),


              ],
            ),
          ),
        ),
      ),
      /*bottomNavigationBar: Container(
        padding: EdgeInsets.all(16.0),
        child: CustomButton2(
          text: 'Book Appointment',
          callback: () {

            AddAppointmentData addAppointmentData = AddAppointmentData(StaticData.userData.data.id.toString(), widget.salon.id.toString(),
                widget.salon.country.countryName, widget.salon.city.cityName, widget.selectedDate, widget.selectedTime,
                'paytm', grandTotal.toString(), [], 'false', 'false');

            _addAppointment(addAppointmentData).then((value) => {

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
        ),
      ),*/
      /*bottomNavigationBar: Container(
        padding: EdgeInsets.all(16.0),
        child: payButton(),
      ),*/
    );
  }

  Widget payButton() {

    return
      Column(
        children: [

          CustomButton2(
            text: Languages.of(context).payWithCardButtonText,
            callback: () {
              payPressed();
            },
          ),

          SizedBox(
            height: 8,
          ),

          Platform.isIOS ? CustomButton2(
            text: Languages.of(context).applePayButtonText,
            callback: () {
              applePayPressed();
            },
          ) : Container(),


        ],
      );
  }


  Future<AddAppointmentResponse> _addAppointment(AddAppointmentData appointmentData) async {

    String url = '${AppConstants.baseURL}/api/add-appointment';
    AddAppointmentResponse addAppointmentResponse;

    print('tran ref received: ${appointmentData.transactionreference}');

    setState(() {
      isLoading = true;
    });

    var response;

    print(jsonEncode(services));

    if(widget.address.isNotEmpty) {
      response = await http.post(
          url,
          headers: {
            "APP_KEY": AppConstants.APP_KEY,
          },
          body: {
            "user_id": appointmentData.userId,
            "salon_id": appointmentData.salonId,
            "country_name": appointmentData.countryName,
            "city_name": appointmentData.cityName,
            "appointment_date": appointmentData.appointmentDate,
            "appointment_time": appointmentData.appointmentTime.split(' ')[0],
            "payment_method": appointmentData.paymentMethod,
            "total_price": appointmentData.totalCharges,
            "services": jsonEncode(services),
            "is_completed": 'false',
            "is_canceled": 'false',
            "address": widget.address,
            "given_at": '1',
            "transactionreference": appointmentData.transactionreference
          });
    }
    else {

      response = await http.post(
          url,
          headers: {
            "APP_KEY": AppConstants.APP_KEY,
          },
          body: {
            "user_id": appointmentData.userId,
            "salon_id": appointmentData.salonId,
            "country_name": appointmentData.countryName,
            "city_name": appointmentData.cityName,
            "appointment_date": appointmentData.appointmentDate,
            "appointment_time": appointmentData.appointmentTime.split(' ')[0],
            "payment_method": appointmentData.paymentMethod,
            "total_price": appointmentData.totalCharges,
            "services": jsonEncode(services),
            "is_completed": 'false',
            "is_canceled": 'false',
            "given_at": '0',
            "transactionreference": appointmentData.transactionreference
          });
    }


    // check the status code for the result
    int statusCode = response.statusCode;

    if (statusCode == 200) {

      addAppointmentResponse = AddAppointmentResponse.fromJson(jsonDecode(response.body));

      setState(() {
        isLoading = false;
      });

      return addAppointmentResponse;

    }
    else {

      //display something went wrong message
      print('status code: $statusCode');
      print('something went wrong !: ${response.body}');

      setState(() {
        isLoading = false;
      });

      return addAppointmentResponse;
    }
    //end if

  }


  _getServicesNamesAndIds() {
    for(int i=0; i<widget.salonCategoriesAndServices.data.length; i++) {

      if(widget.salonCategoriesAndServices.data[i].isSelected) {
        services.add(ServicesList(widget.salonCategoriesAndServices.data[i].id.toString(),
            widget.salonCategoriesAndServices.data[i].serviceName, widget.salonCategoriesAndServices.data[i].servicePrice) );
      }

    }

  }

  Widget applePayButton() {

    if (Platform.isIOS) {
      return TextButton(
        onPressed: () {
          applePayPressed();
        },
        child: Text('Pay with Apple Pay'),
      );
    }
    return SizedBox(height: 0);
  }

  Future<void> applePayPressed() async {


    var billingDetails = new BillingDetails(
        "Abdul Rahman",
        "abdul.rehmanpk21@gmail.com",
        "+201111111111",
        "st. 12",
        /*"pk",
        "pakistan",
        "pakistan",*/
        "sa",
        "saudi",
        "saudi",
        "12345");
    var shippingDetails = new ShippingDetails(
        "Abdul Rahman",
        "abdul.rehmanpk21@gmail.com",
        "+201111111111",
        "st. 12",
        //"pk",
        "sa",
        "saudi",
        "saudi",
        "12345");



    var configuration = PaymentSdkConfigurationDetails(
        //profileId: "68586",
        profileId: "72630",
        //serverKey: "S2JNRRBHDG-JB9KRLDNJK-DN2JLGBTNK",
        serverKey: "SWJNT9JM6Z-JBWG22ZBHN-LGG6RDHTJW",
        //clientKey: "CKKM6H-Q6QD62-PKRBDQ-PTT9MT",
        clientKey: "CPKMKT-7P2K62-VTMM92-N9V7N6",
        cartId: "12433",
        cartDescription: widget.salon.description,
        //merchantName: "MySalon",
        merchantName: "SAMI",
        amount: double.parse(StaticData.aboutResponse.data.commission),
        //currencyCode: "PKR",
        currencyCode: "SAR",
        //merchantCountryCode: "pk",
        merchantCountryCode: "sa",
        billingDetails: billingDetails,
        shippingDetails: shippingDetails,
        merchantApplePayIndentifier: "merchant.com.bunldeId",
        simplifyApplePayValidation: true);

    FlutterPaytabsBridge.startApplePayPayment(configuration, (event) {
      setState(() {
        if (event["status"] == "success") {

          // Handle transaction details here.
          var transactionDetails = event["data"];
          print(transactionDetails);

          String json = jsonEncode(event["data"]);

          print('transaction details: $transactionDetails');
          print('transaction json: $json');

          paytabsResponse = PaytabsResponse.fromJson(jsonDecode(json));

          print('transaction ref: ${paytabsResponse.transactionReference}');


          // Handle transaction details here.
          AddAppointmentData addAppointmentData = AddAppointmentData(StaticData.userData.data.id.toString(), widget.salon.id.toString(),
              widget.salon.country.countryName, widget.salon.city.cityName, widget.selectedDate, widget.selectedTime,
              'paytabs', grandTotal.toString(), [], 'false', 'false', paytabsResponse.transactionReference);


          _addAppointment(addAppointmentData).then((value) => {

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


        } else if (event["status"] == "error") {
          // Handle error here.
        } else if (event["status"] == "event") {
          // Handle events here.
        }
      });
    });
  }

  Future<void> payPressed() async {
    var billingDetails = new BillingDetails(
        "Abdul Rahman",
        "abdul.rehmanpk21@gmail.com",
        "+201111111111",
        "st. 12",
        /*"pk",
        "pakistan",
        "pakistan",*/
        "sa",
        "saudi",
        "saudi",
        "12345");
    var shippingDetails = new ShippingDetails(
        "Abdul Rahman",
        "abdul.rehmanpk21@gmail.com",
        "+201111111111",
        "st. 12",
        //"pk",
        "sa",
        "saudi",
        "saudi",
        "12345");

    var configuration = PaymentSdkConfigurationDetails(
      //profileId: "68586",
      profileId: "72630",
      //serverKey: "S2JNRRBHDG-JB9KRLDNJK-DN2JLGBTNK",
      serverKey: "SWJNT9JM6Z-JBWG22ZBHN-LGG6RDHTJW",
      //clientKey: "CKKM6H-Q6QD62-PKRBDQ-PTT9MT",
      clientKey: "CPKMKT-7P2K62-VTMM92-N9V7N6",
      cartId: "12500",
      cartDescription: widget.salon.description,
      //merchantName: "MySalon",
      merchantName: "SAMI",
      screentTitle: "Pay with Card",
      billingDetails: billingDetails,
      shippingDetails: shippingDetails,
      amount: double.parse(StaticData.aboutResponse.data.commission),
      //currencyCode: "PKR",
      currencyCode: "SAR",
      transactionType: PaymentSdkTransactionType.SALE,
      tokeniseType: PaymentSdkTokeniseType.NONE,
      //merchantCountryCode: "pk",
      merchantCountryCode: "sa",
    );
    if (Platform.isIOS) {
      // Set up here your custom theme
      // var theme = IOSThemeConfigurations();
      // configuration.iOSThemeConfigurations = theme;
    }
    FlutterPaytabsBridge.startCardPayment(configuration, (event) {

      /*if(this.mounted) {

        setState(() {

          if (event["status"] == "success") {
            // Handle transaction details here.
            var transactionDetails = event["data"];
            print('transaction details: $transactionDetails');

          } else if (event["status"] == "error") {
            // Handle error here.
            print('error $event["status"]');

          } else if (event["status"] == "event") {
            // Handle events here.

            print('event $event["status"]');

          }
        });

      }*/

      if (event["status"] == "success") {

        var transactionDetails = event["data"];

        String json = jsonEncode(event["data"]);

        print('transaction details: $transactionDetails');
        print('transaction json: $json');

        paytabsResponse = PaytabsResponse.fromJson(jsonDecode(json));

        print('transaction ref: ${paytabsResponse.transactionReference}');


        // Handle transaction details here.
        AddAppointmentData addAppointmentData = AddAppointmentData(StaticData.userData.data.id.toString(), widget.salon.id.toString(),
            widget.salon.country.countryName, widget.salon.city.cityName, widget.selectedDate, widget.selectedTime,
            'paytabs', grandTotal.toString(), [], 'false', 'false', paytabsResponse.transactionReference);




        paymentData = PaymentData(
          cartAmount: paytabsResponse.cartAmount,
          transactionType: paytabsResponse.transactionType,
          payResponseReturn: paytabsResponse.payResponseReturn,
          transactionReference: paytabsResponse.transactionReference,
          cartCurrency: paytabsResponse.cartCurrency,
          paymentResult: paytabsResponse.paymentResult,
          paymentInfo: paytabsResponse.paymentInfo,
        );

        String paymentDataJson = jsonEncode(paymentData.toJson());
        print('paymentDataJson: $paymentDataJson');

        _addAppointment(addAppointmentData).then((value) => {

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

      }else if (event["status"] == "error") {
        // Handle error here.
        print('error $event["status"]');

      } else if (event["status"] == "event") {
        // Handle events here.

        print('event $event["status"]');

      }

    });
  }


}


class ServicesList {
  String id;
  String name;
  String price;

  ServicesList(this.id, this.name, this.price);

  Map<String, dynamic> toJson(){
    return {
      "service_id": this.id,
      "service_name": this.name,
      "price": this.price
    };
  }

}