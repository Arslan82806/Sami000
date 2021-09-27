import 'package:beauty_saloon/model/salon_model.dart';
import 'package:beauty_saloon/repository/api_repository.dart';
import 'package:beauty_saloon/screens/all_salon/bloc/get_all_salons_event.dart';
import 'package:beauty_saloon/screens/all_salon/bloc/get_all_salons_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';


class GetAllSalonsBloc extends Bloc<GetAllSalonEvent, GetAllSalonState>{

  final ApiRepository _apiRepository = ApiRepository();
  SalonModel salonModel;

  @override
  GetAllSalonState get initialState => GetAllSalonInitial();


  @override
  Stream<GetAllSalonState> mapEventToState(GetAllSalonEvent event) async* {

    if (event is GetAllMySalons) {
      try {

        yield GetAllSalonLoading();
        salonModel = await _apiRepository.fetchSalonsList(event.countryId, event.cityId, event.serviceType);
        yield GetAllSalonLoaded(salonModel);

        if (salonModel.error != null) {
          yield GetAllSalonError(salonModel.error);
        }

      } catch(e) {
        yield GetAllSalonError("Failed to fetch all salons data. Is your device online ?");
      }
    }

  }//end mapEventToState()




}