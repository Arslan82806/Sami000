import 'package:beauty_saloon/model/salon.dart';

class CategorySalonModel {
  String message;
  bool status;
  List<CategorySalonData> data;

  String error;


  CategorySalonModel({this.message, this.status, this.data});

  CategorySalonModel.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    status = json['status'];
    if (json['data'] != null) {
      data = new List<CategorySalonData>();
      json['data'].forEach((v) {
        data.add(new CategorySalonData.fromJson(v));
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

  CategorySalonModel.withError(String errorMessage) {
    error = errorMessage;
  }


}

class CategorySalonData {
  int id;
  String categoryId;
  String salonId;
  String serviceName;
  String servicePrice;
  String serviceTime;
  String image;
  String status;
  String block;
  String isDiscount;
  String discount;
  String createdAt;
  String updatedAt;
  String categoryName;
  Salon salon;
  Category category;


  CategorySalonData(
      {this.id,
        this.categoryId,
        this.salonId,
        this.serviceName,
        this.servicePrice,
        this.serviceTime,
        this.image,
        this.status,
        this.block,
        this.isDiscount,
        this.discount,
        this.createdAt,
        this.updatedAt,
        this.categoryName,
        this.salon,
        this.category});

  CategorySalonData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    categoryId = json['category_id'];
    salonId = json['salon_id'].toString();
    serviceName = json['service_name'];
    servicePrice = json['service_price'];
    serviceTime = json['service_time'];
    image = json['image'];
    status = json['status'].toString();
    block = json['block'].toString();
    isDiscount = json['is_discount'].toString();
    discount = json['discount'].toString();
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    categoryName = json['category_name'];
    salon = json['salon'] != null ? new Salon.fromJson(json['salon']) : null;
    category = json['category'] != null
        ? new Category.fromJson(json['category'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['category_id'] = this.categoryId;
    data['salon_id'] = this.salonId;
    data['service_name'] = this.serviceName;
    data['service_price'] = this.servicePrice;
    data['service_time'] = this.serviceTime;
    data['image'] = this.image;
    data['status'] = this.status;
    data['block'] = this.block;
    data['is_discount'] = this.isDiscount;
    data['discount'] = this.discount;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['category_name'] = this.categoryName;
    if (this.salon != null) {
      data['salon'] = this.salon.toJson();
    }
    if (this.category != null) {
      data['category'] = this.category.toJson();
    }
    return data;
  }
}

/*
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
  City city;
  Country country;
  String ratings;

  bool isFavourite;

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
    ratings = json['ratings'];
    country =
    json['country'] != null ? new Country.fromJson(json['country']) : null;
    city = json['city'] != null ? new City.fromJson(json['city']) : null;
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
*/



/*
class Country {
  int id;
  String countryName;
  String status;
  String createdAt;
  String updatedAt;

  Country(
      {this.id, this.countryName, this.status, this.createdAt, this.updatedAt});

  Country.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    countryName = json['country_name'];
    status = json['status'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['country_name'] = this.countryName;
    data['status'] = this.status;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}

class City {
  int id;
  String countryId;
  String cityName;
  String status;
  String createdAt;
  String updatedAt;

  City(
      {this.id,
        this.countryId,
        this.cityName,
        this.status,
        this.createdAt,
        this.updatedAt});

  City.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    countryId = json['country_id'];
    cityName = json['city_name'];
    status = json['status'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['country_id'] = this.countryId;
    data['city_name'] = this.cityName;
    data['status'] = this.status;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}
*/

class Category {
  int id;
  String categoryName;
  String image;
  String status;
  String createdAt;
  String updatedAt;

  Category(
      {this.id,
        this.categoryName,
        this.image,
        this.status,
        this.createdAt,
        this.updatedAt});

  Category.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    categoryName = json['category_name'];
    image = json['image'];
    status = json['status'].toString();
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['category_name'] = this.categoryName;
    data['image'] = this.image;
    data['status'] = this.status;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}



/*
class CategorySalonModel {

  String image;
  String rating;
  String name;
  String location;

  CategorySalonModel(this.image, this.rating, this.name, this.location);

}*/
