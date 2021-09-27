class CompletedAppointmentsModel {

  String message;
  List<CompletedAppointmentsData> data;
  bool status;

  CompletedAppointmentsModel({this.message, this.data, this.status});

  CompletedAppointmentsModel.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    if (json['data'] != null) {
      data = new List<CompletedAppointmentsData>();
      json['data'].forEach((v) {
        data.add(new CompletedAppointmentsData.fromJson(v));
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

class CompletedAppointmentsData {
  int id;
  String cityName;
  String countryName;
  String userId;
  String salonId;
  String appointmentDate;
  String appointmentTime;
  String totalPrice;
  String isCompleted;
  String isCanceled;
  String paymentMethod;
  String createdAt;
  String updatedAt;
  Salon salon;
  List<Appointment> appointment;

  CompletedAppointmentsData(
      {this.id,
        this.cityName,
        this.countryName,
        this.userId,
        this.salonId,
        this.appointmentDate,
        this.appointmentTime,
        this.totalPrice,
        this.isCompleted,
        this.isCanceled,
        this.paymentMethod,
        this.createdAt,
        this.updatedAt,
        this.salon,
        this.appointment});

  CompletedAppointmentsData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    cityName = json['city_name'];
    countryName = json['country_name'];
    userId = json['user_id'].toString();
    salonId = json['salon_id'].toString();
    appointmentDate = json['appointment_date'];
    appointmentTime = json['appointment_time'];
    totalPrice = json['total_price'].toString();
    isCompleted = json['is_completed'].toString();
    isCanceled = json['is_canceled'].toString();
    paymentMethod = json['payment_method'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    salon = json['salon'] != null ? new Salon.fromJson(json['salon']) : null;
    if (json['appointment'] != null) {
      appointment = new List<Appointment>();
      json['appointment'].forEach((v) {
        appointment.add(new Appointment.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['city_name'] = this.cityName;
    data['country_name'] = this.countryName;
    data['user_id'] = this.userId;
    data['salon_id'] = this.salonId;
    data['appointment_date'] = this.appointmentDate;
    data['appointment_time'] = this.appointmentTime;
    data['total_price'] = this.totalPrice;
    data['is_completed'] = this.isCompleted;
    data['is_canceled'] = this.isCanceled;
    data['payment_method'] = this.paymentMethod;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    if (this.salon != null) {
      data['salon'] = this.salon.toJson();
    }
    if (this.appointment != null) {
      data['appointment'] = this.appointment.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

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

  String ratings;


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
        this.ratings});

  Salon.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    role = json['role'].toString();
    firstName = json['first_name'];
    lastName = json['last_name'];
    salonName = json['salon_name'];
    email = json['email'];
    phone = json['phone'];
    countryId = json['country_id'].toString();
    cityId = json['city_id'].toString();
    image = json['image'];
    status = json['status'].toString();
    giveService = json['give_service'].toString();
    serviceCharges = json['service_charges'].toString();
    wallet = json['wallet'].toString();
    timing = json['timing'];
    description = json['description'];
    website = json['website'];
    lat = json['lat'].toString();
    lng = json['lng'].toString();
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    ratings = json['rating'].toString();
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
    data['rating'] = this.ratings;

    return data;
  }
}

class Appointment {
  int id;
  String reciptId;
  String serviceName;
  String serviceId;
  String createdAt;
  String updatedAt;

  Appointment(
      {this.id,
        this.reciptId,
        this.serviceName,
        this.serviceId,
        this.createdAt,
        this.updatedAt});

  Appointment.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    reciptId = json['recipt_id'].toString();
    serviceName = json['service_name'];
    serviceId = json['service_id'].toString();
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['recipt_id'] = this.reciptId;
    data['service_name'] = this.serviceName;
    data['service_id'] = this.serviceId;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}






/*
class CompletedAppointmentsModel {

  String image;
  String title;
  String rating;
  String dateTime;

  String serviceStatus;

  String givenRating;

  List<String> serviceTypesList = [];

  CompletedAppointmentsModel(this.image, this.title, this.rating, this.dateTime,
      this.serviceStatus, this.givenRating, this.serviceTypesList);

}*/
