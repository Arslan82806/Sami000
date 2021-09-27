import 'package:beauty_saloon/model/salon_city.dart';
import 'package:beauty_saloon/model/salon_country.dart';

class Salon {
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
  SalonCity city;
  SalonCountry country;
  String ratings;

  bool isFavourite = false;

  Salon(
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
        this.ratings,
        this.country,
        this.city});

  Salon.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    role = json['role'].toString();
    firstName = json['first_name'];
    lastName = json['last_name'];
    salonName = json['salon_name'];
    email = json['email'];
    phone = json['phone'];
    countryId = json['country_id'].toString();
    cityId = json['city_id'].toString();
    image = json['image'];
    status = json['status'].toString();
    giveService = json['give_service'].toString();
    serviceCharges = json['service_charges'].toString();
    wallet = json['wallet'].toString();
    timing = json['timing'];
    description = json['description'];
    website = json['website'];
    lat = json['lat'].toString();
    lng = json['lng'].toString();
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    ratings = json['ratings'].toString();
    country =
    json['country'] != null ? new SalonCountry.fromJson(json['country']) : null;
    city = json['city'] != null ? new SalonCity.fromJson(json['city']) : null;
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
    data['ratings'] = this.ratings;
    if (this.country != null) {
      data['country'] = this.country.toJson();
    }
    if (this.city != null) {
      data['city'] = this.city.toJson();
    }
    return data;
  }
}
