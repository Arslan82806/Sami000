import 'package:beauty_saloon/model/categories_model.dart';
import 'package:beauty_saloon/model/category_salon_model.dart';
import 'package:beauty_saloon/model/salon_by_country_city_service_model.dart';
import 'package:beauty_saloon/model/salon_model.dart';
import 'package:beauty_saloon/repository/api_provider.dart';
import 'package:flutter/cupertino.dart';

class ApiRepository {

  final _provider = ApiProvider();

  Future<CategoriesModel> fetchCategoriesList() {
    return _provider.fetchAllCategoriesList();
  }

  Future<SalonModel> fetchSalonsList(String country, String city, String serviceType) {
    return _provider.fetchAllSalonsList(country, city, serviceType);
  }

  Future<SalonByCountryCityServiceModel> fetchSalonsByCountryCityAndServiceTypeList(String countryId, String cityId, String serviceType,
      String startPrice, String endPrice) {
    return _provider.fetchSalonsByCountryCityAndServiceTypeList(countryId, cityId, serviceType, startPrice, endPrice);
  }

  Future<CategorySalonModel> fetchCategorySalons(String categoryId, String countryId, String cityId) {
    return _provider.fetchCategorySalons(categoryId, countryId, cityId);
  }

}