import 'package:beauty_saloon/model/categories_model.dart';
import 'package:beauty_saloon/pages/home_page/bloc/all_categories/all_categories_event.dart';
import 'package:beauty_saloon/pages/home_page/bloc/all_categories/all_categories_state.dart';
import 'package:beauty_saloon/repository/api_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AllCategoriesBloc extends Bloc<AllCategoriesEvent, AllCategoriesState> {

  final ApiRepository _apiRepository = ApiRepository();

  @override
  AllCategoriesState get initialState => AllCategoriesInitial();


  @override
  Stream<AllCategoriesState> mapEventToState(AllCategoriesEvent event) async* {

    CategoriesModel categoriesModel;

    if (event is GetAllCategories) {
      try {

        yield AllCategoriesLoading();

        categoriesModel = await _apiRepository.fetchCategoriesList();

        yield AllCategoriesLoaded(categoriesModel);

        if (categoriesModel.error != null) {
          yield AllCategoriesError(categoriesModel.error);
        }

      } catch(e) {
        yield AllCategoriesError("Failed to fetch all categories data. Is your device online ?");
      }
    }

  }//end mapEventToState()




}