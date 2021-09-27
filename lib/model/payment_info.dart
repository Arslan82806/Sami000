class PaymentInfo {
  String cardScheme;
  String cardType;
  String paymentDescription;

  PaymentInfo({this.cardScheme, this.cardType, this.paymentDescription});

  PaymentInfo.fromJson(Map<String, dynamic> json) {
    cardScheme = json['cardScheme'].toString();
    cardType = json['cardType'].toString();
    paymentDescription = json['paymentDescription'].toString();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['cardScheme'] = this.cardScheme;
    data['cardType'] = this.cardType;
    data['paymentDescription'] = this.paymentDescription;
    return data;
  }
}
