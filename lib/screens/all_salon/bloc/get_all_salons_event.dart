import 'package:equatable/equatable.dart';

abstract class GetAllSalonEvent extends Equatable {
  GetAllSalonEvent();
}

class GetAllMySalons extends GetAllSalonEvent {

  final String countryId, cityId, serviceType;
  GetAllMySalons(this.countryId, this.cityId, this.serviceType);

  @override
  List<Object> get props => null;

}