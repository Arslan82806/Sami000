import 'package:beauty_saloon/model/salon_model.dart';
import 'package:equatable/equatable.dart';

abstract class GetAllSalonState extends Equatable {
  const GetAllSalonState();
}

class GetAllSalonInitial extends GetAllSalonState {
  GetAllSalonInitial();

  @override
  List<Object> get props => [];
}

class GetAllSalonLoading extends GetAllSalonState {
  const GetAllSalonLoading();
  @override
  List<Object> get props => null;
}

class GetAllSalonLoaded extends GetAllSalonState {

  final SalonModel salonModel;
  const GetAllSalonLoaded(this.salonModel);

  @override
  List<Object> get props => [salonModel];
}

class GetAllSalonError extends GetAllSalonState {

  final String message;
  const GetAllSalonError(this.message);

  @override
  List<Object> get props => [message];
}

