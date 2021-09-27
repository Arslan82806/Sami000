import 'package:beauty_saloon/model/salon_by_country_city_service_model.dart';
import 'package:equatable/equatable.dart';

abstract class AllSalonState extends Equatable {
  const AllSalonState();
}

class AllSalonInitial extends AllSalonState {
  AllSalonInitial();

  @override
  List<Object> get props => [];
}

class AllSalonLoading extends AllSalonState {
  const AllSalonLoading();
  @override
  List<Object> get props => null;
}

class AllSalonLoaded extends AllSalonState {

  //final SalonModel salonModel;
  final SalonByCountryCityServiceModel salonModel;
  const AllSalonLoaded(this.salonModel);

  @override
  List<Object> get props => [salonModel];
}

class AllSalonError extends AllSalonState {

  final String message;
  const AllSalonError(this.message);

  @override
  List<Object> get props => [message];
}

