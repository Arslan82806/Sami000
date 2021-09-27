import 'package:beauty_saloon/model/salon.dart';

class SalonByCountryCityServiceModel {
  String message;
  bool status;
  List<Salon> data;

  SalonByCountryCityServiceModel({this.message, this.status, this.data});

  String error;

  SalonByCountryCityServiceModel.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    status = json['status'];
    if (json['data'] != null) {
      data = [];
      json['data'].forEach((v) {
        data.add(new Salon.fromJson(v));
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

  SalonByCountryCityServiceModel.withError(String errorMessage) {
    error = errorMessage;
  }

}

/*class SalonByCountryCityServiceTyeData {

  int id;
  String role;
  String firstName;
  String lastName;

  String salonName;
  String email;
  String phone;
  String countryId;

  String cityId;
  String image;
  String status;
  String giveService;

  String serviceCharges;
  String wallet;
  String timing;
  String description;

  String website;
  String lat;
  String lng;
  String createdAt;

  String updatedAt;
  City city;
  Country country;
  String ratings;

  bool isFavourite = false;

  SalonByCountryCityServiceTyeData(
      {this.id,
        this.role,
        this.firstName,
        this.lastName,
        this.salonName,
        this.email,
        this.phone,
        this.countryId,
        this.cityId,
        this.image,
        this.status,
        this.giveService,
        this.serviceCharges,
        this.wallet,
        this.timing,
        this.description,
        this.website,
        this.lat,
        this.lng,
        this.createdAt,
        this.updatedAt,
        this.city,
        this.country,
        this.ratings});

  SalonByCountryCityServiceTyeData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    role = json['role'];
    firstName = json['first_name'];
    lastName = json['last_name'];
    salonName = json['salon_name'];
    email = json['email'];
    phone = json['phone'];
    countryId = json['country_id'];
    cityId = json['city_id'];
    image = json['image'];
    status = json['status'];
    giveService = json['give_service'];
    serviceCharges = json['service_charges'];
    wallet = json['wallet'];
    timing = json['timing'];
    description = json['description'];
    website = json['website'];
    lat = json['lat'];
    lng = json['lng'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    city = json['city'] != null ? new City.fromJson(json['city']) : null;
    country =
    json['country'] != null ? new Country.fromJson(json['country']) : null;
    ratings = json['ratings'].toString();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['role'] = this.role;
    data['first_name'] = this.firstName;
    data['last_name'] = this.lastName;
    data['salon_name'] = this.salonName;
    data['email'] = this.email;
    data['phone'] = this.phone;
    data['country_id'] = this.countryId;
    data['city_id'] = this.cityId;
    data['image'] = this.image;
    data['status'] = this.status;
    data['give_service'] = this.giveService;
    data['service_charges'] = this.serviceCharges;
    data['wallet'] = this.wallet;
    data['timing'] = this.timing;
    data['description'] = this.description;
    data['website'] = this.website;
    data['lat'] = this.lat;
    data['lng'] = this.lng;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    if (this.city != null) {
      data['city'] = this.city.toJson();
    }
    if (this.country != null) {
      data['country'] = this.country.toJson();
    }
    data['ratings'] = this.ratings;
    return data;
  }
}*/



