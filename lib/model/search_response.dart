import 'package:beauty_saloon/model/salon.dart';

class SearchResponse {
  String message;
  bool status;
  List<Salon> data;

  SearchResponse({this.message, this.status, this.data});

  SearchResponse.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    status = json['status'];
    if (json['data'] != null) {
      data = new List<Salon>();
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
}

