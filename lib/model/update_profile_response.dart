class UpdateProfileResponse {
  String message;
  UpdateProfileData data;
  bool status;

  UpdateProfileResponse({this.message, this.data, this.status});

  UpdateProfileResponse.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    data = json['data'] != null ? new UpdateProfileData.fromJson(json['data']) : null;
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['message'] = this.message;
    if (this.data != null) {
      data['data'] = this.data.toJson();
    }
    data['status'] = this.status;
    return data;
  }
}

class UpdateProfileData {
  int id;
  String name;
  String role;
  String email;
  String phone;
  String image;
  String birthDate;
  String gender;
  String countryId;
  String cityId;
  Null emailVerifiedAt;
  String apiToken;
  Null smsToken;
  String isVerify;
  String createdAt;
  String updatedAt;
  City city;
  Country country;

  UpdateProfileData(
      {this.id,
        this.name,
        this.role,
        this.email,
        this.phone,
        this.image,
        this.birthDate,
        this.gender,
        this.countryId,
        this.cityId,
        this.emailVerifiedAt,
        this.apiToken,
        this.smsToken,
        this.isVerify,
        this.createdAt,
        this.updatedAt,
        this.city,
        this.country});

  UpdateProfileData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    role = json['role'].toString();
    email = json['email'];
    phone = json['phone'];
    image = json['image'];
    birthDate = json['birth_date'];
    gender = json['gender'];
    countryId = json['country_id'].toString();
    cityId = json['city_id'].toString();
    emailVerifiedAt = json['email_verified_at'];
    apiToken = json['api_token'];
    smsToken = json['sms_token'];
    isVerify = json['is_verify'].toString();
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    city = json['city'] != null ? new City.fromJson(json['city']) : null;
    country =
    json['country'] != null ? new Country.fromJson(json['country']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['role'] = this.role;
    data['email'] = this.email;
    data['phone'] = this.phone;
    data['image'] = this.image;
    data['birth_date'] = this.birthDate;
    data['gender'] = this.gender;
    data['country_id'] = this.countryId;
    data['city_id'] = this.cityId;
    data['email_verified_at'] = this.emailVerifiedAt;
    data['api_token'] = this.apiToken;
    data['sms_token'] = this.smsToken;
    data['is_verify'] = this.isVerify;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    if (this.city != null) {
      data['city'] = this.city.toJson();
    }
    if (this.country != null) {
      data['country'] = this.country.toJson();
    }
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
    countryId = json['country_id'].toString();
    cityName = json['city_name'];
    status = json['status'].toString();
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
    status = json['status'].toString();
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
