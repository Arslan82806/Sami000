import 'package:beauty_saloon/model/payment_info.dart';
import 'package:beauty_saloon/model/payment_result.dart';

class PaytabsResponse {

  String cartDescription;
  String cartID;
  BillingDetailsResponse billingDetails;
  BillingDetailsResponse shippingDetails;
  String cartAmount;
  String transactionType;
  String payResponseReturn;
  String transactionReference;
  String cartCurrency;
  PaymentResult paymentResult;
  PaymentInfo paymentInfo;

  PaytabsResponse(
      {
        this.cartDescription,
        this.cartID,
        this.billingDetails,
        this.shippingDetails,
        this.cartAmount,
        this.transactionType,
        this.payResponseReturn,
        this.transactionReference,
        this.cartCurrency,
        this.paymentResult,
        this.paymentInfo
      });

  PaytabsResponse.fromJson(Map<String, dynamic> json) {
    cartDescription = json['cartDescription'].toString();
    cartID = json['cartID'].toString();
    billingDetails = json['billingDetails'] != null
        ? new BillingDetailsResponse.fromJson(json['billingDetails'])
        : null;
    shippingDetails = json['shippingDetails'] != null
        ? new BillingDetailsResponse.fromJson(json['shippingDetails'])
        : null;
    cartAmount = json['cartAmount'].toString();
    transactionType = json['transactionType'].toString();
    payResponseReturn = json['payResponseReturn'].toString();
    transactionReference = json['transactionReference'].toString();
    cartCurrency = json['cartCurrency'].toString();
    paymentResult = json['paymentResult'] != null
        ? new PaymentResult.fromJson(json['paymentResult'])
        : null;
    paymentInfo = json['paymentInfo'] != null
        ? new PaymentInfo.fromJson(json['paymentInfo'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['cartDescription'] = this.cartDescription;
    data['cartID'] = this.cartID;
    if (this.billingDetails != null) {
      data['billingDetails'] = this.billingDetails.toJson();
    }
    if (this.shippingDetails != null) {
      data['shippingDetails'] = this.shippingDetails.toJson();
    }
    data['cartAmount'] = this.cartAmount;
    data['transactionType'] = this.transactionType;
    data['payResponseReturn'] = this.payResponseReturn;
    data['transactionReference'] = this.transactionReference;
    data['cartCurrency'] = this.cartCurrency;
    if (this.paymentResult != null) {
      data['paymentResult'] = this.paymentResult.toJson();
    }
    if (this.paymentInfo != null) {
      data['paymentInfo'] = this.paymentInfo.toJson();
    }
    return data;
  }
}

class BillingDetailsResponse {
  String addressLine;
  String city;
  String countryCode;
  String email;
  String name;
  String phone;
  String zip;

  BillingDetailsResponse(
      {this.addressLine,
        this.city,
        this.countryCode,
        this.email,
        this.name,
        this.phone,
        this.zip});

  BillingDetailsResponse.fromJson(Map<String, dynamic> json) {
    addressLine = json['addressLine'].toString();
    city = json['city'].toString();
    countryCode = json['countryCode'].toString();
    email = json['email'].toString();
    name = json['name'].toString();
    phone = json['phone'].toString();
    zip = json['zip'].toString();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['addressLine'] = this.addressLine;
    data['city'] = this.city;
    data['countryCode'] = this.countryCode;
    data['email'] = this.email;
    data['name'] = this.name;
    data['phone'] = this.phone;
    data['zip'] = this.zip;
    return data;
  }
}


