import 'dart:async';
import 'dart:io' show Platform;
import 'package:flutter/material.dart';
import 'package:flutter_paytabs_bridge/BaseBillingShippingInfo.dart';
import 'package:flutter_paytabs_bridge/IOSThemeConfiguration.dart';
import 'package:flutter_paytabs_bridge/PaymentSdkConfigurationDetails.dart';
import 'package:flutter_paytabs_bridge/PaymentSdkLocale.dart';
import 'package:flutter_paytabs_bridge/PaymentSdkTokenFormat.dart';
import 'package:flutter_paytabs_bridge/PaymentSdkTokeniseType.dart';
import 'package:flutter_paytabs_bridge/PaymentSdkTransactionType.dart';
import 'package:flutter_paytabs_bridge/flutter_paytabs_bridge.dart';
import 'package:flutter_paytabs_bridge/PaymentSdkTransactionClass.dart';


class PaytabsDemo extends StatefulWidget {
  @override
  _PaytabsDemoState createState() => _PaytabsDemoState();
}

class _PaytabsDemoState extends State<PaytabsDemo> {

  String _instructions = 'Tap on "Pay" Button to try PayTabs plugin';

  @override
  void initState() {
    super.initState();
  }

  Future<void> payPressed() async {
    var billingDetails = new BillingDetails(
        "Abdul Rahman",
        "abdul.rehmanpk21@gmail.com",
        "+201111111111",
        "st. 12",
        "pk",
        "pakistan",
        "pakistan",
        "12345");
    var shippingDetails = new ShippingDetails(
        "Abdul Rahman",
        "abdul.rehmanpk21@gmail.com",
        "+201111111111",
        "st. 12",
        "pk",
        "pakistan",
        "pakistan",
        "12345");
    var configuration = PaymentSdkConfigurationDetails(
      profileId: "68586",
      serverKey: "S2JNRRBHDG-JB9KRLDNJK-DN2JLGBTNK",
      clientKey: "CKKM6H-Q6QD62-PKRBDQ-PTT9MT",
      cartId: "12500",
      cartDescription: "makeup service",
      merchantName: "MySalon",
      screentTitle: "Pay with Card",
      billingDetails: billingDetails,
      shippingDetails: shippingDetails,
      amount: 599.0,
      currencyCode: "PKR",
      transactionType: PaymentSdkTransactionType.SALE,
      tokeniseType: PaymentSdkTokeniseType.NONE,
      merchantCountryCode: "pk",
    );
    if (Platform.isIOS) {
      // Set up here your custom theme
      // var theme = IOSThemeConfigurations();
      // configuration.iOSThemeConfigurations = theme;
    }
    FlutterPaytabsBridge.startCardPayment(configuration, (event) {
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
    });
  }

  Future<void> applePayPressed() async {
    var configuration = PaymentSdkConfigurationDetails(
        profileId: "*Your profile id*",
        serverKey: "*server key*",
        clientKey: "*client key*",
        cartId: "12433",
        cartDescription: "Flowers",
        merchantName: "Flowers Store",
        amount: 20.0,
        currencyCode: "AED",
        merchantCountryCode: "ae",
        merchantApplePayIndentifier: "merchant.com.bunldeId",
        simplifyApplePayValidation: true);
    FlutterPaytabsBridge.startApplePayPayment(configuration, (event) {
      setState(() {
        if (event["status"] == "success") {
          // Handle transaction details here.
          var transactionDetails = event["data"];
          print(transactionDetails);
        } else if (event["status"] == "error") {
          // Handle error here.
        } else if (event["status"] == "event") {
          // Handle events here.
        }
      });
    });
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
          child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text('$_instructions'),
                SizedBox(height: 16),
                TextButton(
                  onPressed: () {
                    payPressed();
                  },
                  child: Text('Pay with Card'),
                ),
                SizedBox(height: 16),
                applePayButton()
              ])),
    );
  }
}