class SalonCategoriesServicesModel {
  String message;
  bool status;
  List<SalonCatServData> data;

  SalonCategoriesServicesModel({this.message, this.status, this.data});

  SalonCategoriesServicesModel.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    status = json['status'];
    if (json['data'] != null) {
      data = new List<SalonCatServData>();
      json['data'].forEach((v) {
        data.add(new SalonCatServData.fromJson(v));
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

class SalonCatServData {
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
  CategoryInfo category;

  bool isSelected = false;

  SalonCatServData(
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
        this.category});

  SalonCatServData.fromJson(Map<String, dynamic> json) {
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
    category = json['category'] != null
        ? new CategoryInfo.fromJson(json['category'])
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
    if (this.category != null) {
      data['category'] = this.category.toJson();
    }
    return data;
  }
}

class CategoryInfo {
  int id;
  String categoryName;
  String image;
  String status;
  String createdAt;
  String updatedAt;

  CategoryInfo(
      {this.id,
        this.categoryName,
        this.image,
        this.status,
        this.createdAt,
        this.updatedAt});

  CategoryInfo.fromJson(Map<String, dynamic> json) {
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
