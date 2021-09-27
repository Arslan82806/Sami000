class ReviewsModel {
  String message;
  bool status;
  List<ReivewsData> data;

  ReviewsModel({this.message, this.status, this.data});

  ReviewsModel.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    status = json['status'];
    if (json['data'] != null) {
      data = new List<ReivewsData>();
      json['data'].forEach((v) {
        data.add(new ReivewsData.fromJson(v));
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

class ReivewsData {
  int id;
  String userId;
  String salonId;
  String rating;
  String description;
  String createdAt;
  String updatedAt;
  String userName;
  User user;

  ReivewsData(
      {this.id,
        this.userId,
        this.salonId,
        this.rating,
        this.description,
        this.createdAt,
        this.updatedAt,
        this.userName,
        this.user});

  ReivewsData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'].toString();
    salonId = json['salon_id'].toString();
    rating = json['rating'].toString();
    description = json['description'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    userName = json['user_name'];
    user = json['user'] != null ? new User.fromJson(json['user']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['user_id'] = this.userId;
    data['salon_id'] = this.salonId;
    data['rating'] = this.rating;
    data['description'] = this.description;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['user_name'] = this.userName;
    if (this.user != null) {
      data['user'] = this.user.toJson();
    }
    return data;
  }
}

class User {
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

  User(
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
        this.updatedAt});

  User.fromJson(Map<String, dynamic> json) {
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
    return data;
  }
}
