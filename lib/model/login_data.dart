class LoginData {

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
  String createdAt;
  String updatedAt;

  LoginData(
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
        this.createdAt,
        this.updatedAt});

  LoginData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    role = json['role'];
    email = json['email'];
    phone = json['phone'];
    image = json['image'];
    birthDate = json['birth_date'];
    gender = json['gender'];
    countryId = json['country_id'];
    cityId = json['city_id'];
    emailVerifiedAt = json['email_verified_at'];
    apiToken = json['api_token'];
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
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;

    return data;
  }
}
