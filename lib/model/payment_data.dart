import 'package:beauty_saloon/model/payment_info.dart';
import 'package:beauty_saloon/model/payment_result.dart';

class PaymentData {

/*  String cartAmount;
  String transactionType;
  String payResponseReturn;
  String transactionReference;
  String cartCurrency;

  PaymentResult paymentResult;
  PaymentInfo paymentInfo;

  PaymentData({
    this.cartAmount,
    this.transactionType,
    this.payResponseReturn,
    this.transactionReference,
    this.cartCurrency,
    this.paymentResult,
    this.paymentInfo
  });*/


  String cartAmount;
  String transactionType;
  String payResponseReturn;
  String transactionReference;
  String cartCurrency;


  PaymentResult paymentResult;
  PaymentInfo paymentInfo;

  PaymentData(
      {
        this.cartAmount,
        this.transactionType,
        this.payResponseReturn,
        this.transactionReference,
        this.cartCurrency,
        this.paymentResult,
        this.paymentInfo
      });

  PaymentData.fromJson(Map<String, dynamic> json) {
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


/*
class PaymentResultData {

  String responseCode;
  String responseMessage;
  String responseStatus;
  String transactionTime;

  PaymentResultData(this.responseCode, this.responseMessage,
      this.responseStatus, this.transactionTime);
}

class PaymentInfo {

  String cardScheme;
  String cardType;
  String paymentDescription;

  PaymentInfo(this.cardScheme, this.cardType, this.paymentDescription);

}*/
