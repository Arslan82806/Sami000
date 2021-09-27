class SalonCity {
  int id;
  String countryId;
  String cityName;
  String status;
  String createdAt;
  String updatedAt;

  SalonCity(
      {this.id,
        this.countryId,
        this.cityName,
        this.status,
        this.createdAt,
        this.updatedAt});

  SalonCity.fromJson(Map<String, dynamic> json) {
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

