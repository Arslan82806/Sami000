import 'package:beauty_saloon/model/salon_by_country_city_service_model.dart';
import 'package:beauty_saloon/pages/home_page/bloc/all_salons/all_salon_state.dart';
import 'package:beauty_saloon/pages/home_page/bloc/all_salons/all_salons_event.dart';
import 'package:beauty_saloon/repository/api_repository.dart';
import 'package:beauty_saloon/utils/app_constants.dart';
import 'package:beauty_saloon/utils/shared_prefs.dart';
import 'package:beauty_saloon/utils/static_data.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AllSalonsBloc extends Bloc<AllSalonEvent, AllSalonState>{

  final ApiRepository _apiRepository = ApiRepository();
  SalonByCountryCityServiceModel salonByCountryCityServiceModel;

  @override
  AllSalonState get initialState => AllSalonInitial();

  @override
  Stream<AllSalonState> mapEventToState(AllSalonEvent event) async* {


    if (event is GetAllSalons) {
      try {

        yield AllSalonLoading();
        salonByCountryCityServiceModel = await _apiRepository.fetchSalonsByCountryCityAndServiceTypeList(event.countryId, event.cityId, event.serviceType,
        event.startPrice, event.endPrice);

        yield AllSalonLoaded(salonByCountryCityServiceModel);

        if (salonByCountryCityServiceModel.error != null) {
          yield AllSalonError(StaticData.salonModel.error);
        }

      } catch(e) {
        yield AllSalonError("Failed to fetch all salons data. Is your device online ?");
      }
    }
    else if(event is GetAllCityBasedSalons) {
      try {

        yield AllSalonLoading();


        if(StaticData.salonByCountryCityServiceModel == null)
          StaticData.salonByCountryCityServiceModel = await _apiRepository.fetchSalonsByCountryCityAndServiceTypeList(event.countryId,
              event.cityId, event.serviceType, event.startPrice, event.endPrice);

        yield AllSalonLoaded(StaticData.salonByCountryCityServiceModel);


        if (StaticData.salonByCountryCityServiceModel.error != null) {
          yield AllSalonError(StaticData.salonModel.error);
        }

      } catch(e) {
        yield AllSalonError("Failed to fetch all salons data. Is your device online ?");
      }
    }

  }//end mapEventToState()




}