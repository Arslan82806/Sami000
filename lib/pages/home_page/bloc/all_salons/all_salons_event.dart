import 'package:equatable/equatable.dart';

abstract class AllSalonEvent extends Equatable {
  AllSalonEvent();
}

class GetAllSalons extends AllSalonEvent {

  final String countryId, cityId, serviceType, startPrice, endPrice;
  GetAllSalons(this.countryId, this.cityId, this.serviceType, this.startPrice, this.endPrice);

  @override
  List<Object> get props => null;

}

class GetAllCityBasedSalons extends AllSalonEvent {

  final String countryId, cityId, serviceType, startPrice, endPrice;
  GetAllCityBasedSalons(this.countryId, this.cityId, this.serviceType, this.startPrice, this.endPrice);

  @override
  List<Object> get props => null;

}