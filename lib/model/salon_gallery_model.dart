class SalonGalleryModel {
  String message;
  bool status;
  List<SalonGalleryData> data;

  SalonGalleryModel({this.message, this.status, this.data});

  SalonGalleryModel.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    status = json['status'];
    if (json['data'] != null) {
      data = new List<SalonGalleryData>();
      json['data'].forEach((v) {
        data.add(new SalonGalleryData.fromJson(v));
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

class SalonGalleryData {
  int id;
  String salonId;
  String image;
  String status;
  String createdAt;
  String updatedAt;

  SalonGalleryData(
      {this.id,
        this.salonId,
        this.image,
        this.status,
        this.createdAt,
        this.updatedAt});

  SalonGalleryData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    salonId = json['salon_id'];
    image = json['image'];
    status = json['status'].toString();
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['salon_id'] = this.salonId;
    data['image'] = this.image;
    data['status'] = this.status;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}
