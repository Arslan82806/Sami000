import 'package:beauty_saloon/model/category_salon_model.dart';
import 'package:beauty_saloon/repository/api_repository.dart';
import 'package:beauty_saloon/screens/all_salon/bloc/get_all_salons_event.dart';
import 'package:beauty_saloon/screens/category_salons/bloc/category_salons_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'category_salons_event.dart';


class CategorySalonsBloc extends Bloc<CategorySalonEvent, CategorySalonState>{

  final ApiRepository _apiRepository = ApiRepository();
  CategorySalonModel categorySalonModel;

  @override
  CategorySalonState get initialState => CategorySalonInitial();


  @override
  Stream<CategorySalonState> mapEventToState(CategorySalonEvent event) async* {

    if (event is GetCategorySalons) {
      try {

        yield CategorySalonLoading();
        categorySalonModel = await _apiRepository.fetchCategorySalons(event.categoryId, event.countryId, event.cityId);
        yield CategorySalonLoaded(categorySalonModel);

        if (categorySalonModel.error != null) {
          yield CategorySalonError(categorySalonModel.error);
        }

      } catch(e) {
        yield CategorySalonError("Failed to fetch all category salons data. Is your device online ?");
      }
    }

  }//end mapEventToState()




}