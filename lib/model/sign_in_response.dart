class SignInResponse {
  String message;
  bool status;

  SignInResponse({this.message, this.status});

  SignInResponse.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['message'] = this.message;
    data['status'] = this.status;
    return data;
  }
}


/*
class SignInResponse {

  String message;
  String token;
  bool status;
  LoginData data;

  SignInResponse({this.message, this.token, this.status, this.data});

  SignInResponse.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    token = json['Token'];
    status = json['status'];
    data = json['data'] != null ? new LoginData.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['message'] = this.message;
    data['Token'] = this.token;
    data['status'] = this.status;
    if (this.data != null) {
      data['data'] = this.data.toJson();
    }
    return data;
  }

}
*/

