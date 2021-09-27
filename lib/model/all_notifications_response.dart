class AllNotificationsResponse {

  String message;
  List<NotificationData> data;
  bool status;

  AllNotificationsResponse({this.message, this.data, this.status});

  AllNotificationsResponse.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    if (json['data'] != null) {
      data = new List<NotificationData>();
      json['data'].forEach((v) {
        data.add(new NotificationData.fromJson(v));
      });
    }
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['message'] = this.message;
    if (this.data != null) {
      data['data'] = this.data.map((v) => v.toJson()).toList();
    }
    data['status'] = this.status;
    return data;
  }
}

class NotificationData {
  int id;
  Null salonId;
  String userId;
  String title;
  String message;
  Null image;
  String createdAt;
  String updatedAt;

  NotificationData(
      {this.id,
        this.salonId,
        this.userId,
        this.title,
        this.message,
        this.image,
        this.createdAt,
        this.updatedAt});

  NotificationData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    salonId = json['salon_id'];
    userId = json['user_id'].toString();
    title = json['title'];
    message = json['message'];
    image = json['image'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['salon_id'] = this.salonId;
    data['user_id'] = this.userId;
    data['title'] = this.title;
    data['message'] = this.message;
    data['image'] = this.image;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}
