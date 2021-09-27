import 'dart:convert';
import 'package:beauty_saloon/model/categories_model.dart';
import 'package:beauty_saloon/model/category_salon_model.dart';
import 'package:beauty_saloon/model/salon_by_country_city_service_model.dart';
import 'package:beauty_saloon/model/salon_model.dart';
import 'package:beauty_saloon/utils/app_constants.dart';
import 'package:http/http.dart' as http;


class ApiProvider {

  final String _allCategoriesUrl = AppConstants.baseURL+'/api/category';
  final String _allSalonsUrl = AppConstants.baseURL+'/api/salons';
  final String _salonsByCountryCityAndServiceTypeUrl = AppConstants.baseURL+'/api/getSalonsByCountryCityAndServiceType';
  final String _categorySalonUrl = AppConstants.baseURL+'/api/getServiceByCategory';

  Future<CategoriesModel> fetchAllCategoriesList() async {

    CategoriesModel categoriesModel;

    try {

      var response = await http.get(_allCategoriesUrl, headers: {"APP_KEY": AppConstants.APP_KEY});

      /*print(response.statusCode.toString());
      print(response.body.toString());*/

      categoriesModel = (CategoriesModel.fromJson(json.decode(response.body)));

      return categoriesModel;
    }
    catch (error, stacktrace)
    {
      print("Exception occurred: $error stackTrace: $stacktrace");
      return categoriesModel;
    }

  }//end fetchAllCategoriesList()

  Future<SalonModel> fetchAllSalonsList(String countryId, String cityId, String serviceType) async {

    SalonModel salonModel;

    try {

      /*var response = await http.get(
          _allSalonsUrl,
          headers: {
            "APP_KEY": AppConstants.APP_KEY
          },

      );*/

      var response = await http.post(
          _salonsByCountryCityAndServiceTypeUrl,
        headers: {
          "APP_KEY": AppConstants.APP_KEY
        },
        body: {
          "country_id": countryId,
          "city_id": cityId,
          "service_type": serviceType
        }
      );

      salonModel = (SalonModel.fromJson(json.decode(response.body)));

      return salonModel;
    }
    catch (error, stacktrace)
    {
      print("Exception occurred: $error stackTrace: $stacktrace");
      return salonModel;
    }

  }//end fetchAllSalonsList()

  Future<SalonByCountryCityServiceModel> fetchSalonsByCountryCityAndServiceTypeList(
      String countryId,
      String cityId,
      String serviceType,
      String startPrice,
      String endPrice
    ) async {

    SalonByCountryCityServiceModel salonModel;

    print('countryId recieved: $countryId');
    print('cityId recieved: $cityId');
    print('service type recieved: $serviceType');
    print('start price recieved: $startPrice');
    print('end price received: $endPrice');


    try {
      var response;

      if(startPrice == '' && endPrice == '') {

        response = await http.post(
            _salonsByCountryCityAndServiceTypeUrl,
            headers: {
              "APP_KEY": AppConstants.APP_KEY,
            },
            body: {
              "country_id": countryId,
              "city_id": cityId,
              "service_type": serviceType
            }
        );

      }
      else {
        response = await http.post(
            _salonsByCountryCityAndServiceTypeUrl,
            headers: {
              "APP_KEY": AppConstants.APP_KEY,
            },
            body: {
              "country_id": countryId,
              "city_id": cityId,
              "service_type": serviceType,
              "startPrice": startPrice,
              "endPrice": endPrice
            }
        );
      }

      /*print(response.statusCode.toString());
      print(response.body.toString());*/

      salonModel = (SalonByCountryCityServiceModel.fromJson(json.decode(response.body)));

      return salonModel;
    }
    catch (error, stacktrace)
    {
      print("Exception occurred: $error stackTrace: $stacktrace");
      return salonModel;
    }

  }//end fetchSalonsByCountryCityAndServiceTypeList()


  Future<CategorySalonModel> fetchCategorySalons(String categoryId, String countryId, String cityId) async {

    CategorySalonModel categorySalonModel;

    try {

      var response = await http.post(
          _categorySalonUrl,
          headers: {
            "APP_KEY": AppConstants.APP_KEY,
          },
          body: {
            "category_id": categoryId,
            "country_id": countryId,
            "city_id": cityId,
          }
      );


      categorySalonModel = (CategorySalonModel.fromJson(json.decode(response.body)));

      return categorySalonModel;
    }
    catch (error, stacktrace)
    {
      print("Exception occurred: $error stackTrace: $stacktrace");
      return categorySalonModel;
    }

  }//end fetchCategorySalons()



}