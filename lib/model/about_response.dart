class AboutResponse {
  String message;
  bool status;
  AboutData data;

  AboutResponse({this.message, this.status, this.data});

  AboutResponse.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    status = json['status'];
    data = json['data'] != null ? new AboutData.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['message'] = this.message;
    data['status'] = this.status;
    if (this.data != null) {
      data['data'] = this.data.toJson();
    }
    return data;
  }
}

class AboutData {
  int id;
  String siteName;
  String amount;
  String commission;
  String currency;
  String aboutUs;
  Null createdAt;
  String updatedAt;

  AboutData(
      {this.id,
        this.siteName,
        this.amount,
        this.commission,
        this.currency,
        this.aboutUs,
        this.createdAt,
        this.updatedAt});

  AboutData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    siteName = json['site_name'];
    amount = json['amount'].toString();
    commission = json['commission'].toString();
    currency = json['currency'];
    aboutUs = json['about_us'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['site_name'] = this.siteName;
    data['amount'] = this.amount;
    data['commission'] = this.commission;
    data['currency'] = this.currency;
    data['about_us'] = this.aboutUs;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}



/*
class AboutResponse {
  String message;
  bool status;
  Data data;

  AboutResponse({this.message, this.status, this.data});

  AboutResponse.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    status = json['status'];
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['message'] = this.message;
    data['status'] = this.status;
    if (this.data != null) {
      data['data'] = this.data.toJson();
    }
    return data;
  }
}

class Data {
  int id;
  String siteName;
  String amount;
  String aboutUs;
  Null createdAt;
  String updatedAt;

  Data(
      {this.id,
        this.siteName,
        this.amount,
        this.aboutUs,
        this.createdAt,
        this.updatedAt});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    siteName = json['site_name'];
    amount = json['amount'];
    aboutUs = json['about_us'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['site_name'] = this.siteName;
    data['amount'] = this.amount;
    data['about_us'] = this.aboutUs;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}
*/
