import 'package:beauty_saloon/model/countries_model.dart';

class CountriesAndCitiesModel {

  String message;
  bool status;
  List<CountriesModel> data;

  CountriesAndCitiesModel({this.message, this.status, this.data});

  CountriesAndCitiesModel.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    status = json['status'];
    if (json['data'] != null) {
      data = new List<CountriesModel>();
      json['data'].forEach((v) {
        data.add(new CountriesModel.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['message'] = this.message;
    data['status'] = this.status;
    if (this.data != null) {
      data['data'] = this.data.map((v) => v.toJson()).toList();
    }
    return data;
  }
}


