class PaymentResult {
  String responseCode;
  String responseMessage;
  String responseStatus;
  String transactionTime;

  PaymentResult(
      {this.responseCode,
        this.responseMessage,
        this.responseStatus,
        this.transactionTime});

  PaymentResult.fromJson(Map<String, dynamic> json) {
    responseCode = json['responseCode'].toString();
    responseMessage = json['responseMessage'].toString();
    responseStatus = json['responseStatus'].toString();
    transactionTime = json['transactionTime'].toString();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['responseCode'] = this.responseCode;
    data['responseMessage'] = this.responseMessage;
    data['responseStatus'] = this.responseStatus;
    data['transactionTime'] = this.transactionTime;
    return data;
  }
}
