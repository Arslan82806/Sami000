import 'package:beauty_saloon/model/city_model.dart';

class CountriesModel {
  int id;
  String countryName;
  String status;
  String createdAt;
  String updatedAt;
  List<CityModel> city;

  CountriesModel(
      {this.id,
        this.countryName,
        this.status,
        this.createdAt,
        this.updatedAt,
        this.city});

  CountriesModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    countryName = json['country_name'];
    status = json['status'].toString();
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    if (json['city'] != null) {
      city = [];
      json['city'].forEach((v) {
        city.add(new CityModel.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['country_name'] = this.countryName;
    data['status'] = this.status;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    if (this.city != null) {
      data['city'] = this.city.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
