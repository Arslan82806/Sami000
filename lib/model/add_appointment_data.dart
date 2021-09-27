class AddAppointmentData {

  String userId;
  String salonId;
  String countryName;
  String cityName;
  String appointmentDate;
  String appointmentTime;
  String paymentMethod;
  String totalCharges;
  List<String> servicesList;
  String isCompleted;
  String isCanceled;
  String transactionreference;

  AddAppointmentData(
      this.userId,
      this.salonId,
      this.countryName,
      this.cityName,
      this.appointmentDate,
      this.appointmentTime,
      this.paymentMethod,
      this.totalCharges,
      this.servicesList,
      this.isCompleted,
      this.isCanceled,
      this.transactionreference
      );

}