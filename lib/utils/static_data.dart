import 'package:beauty_saloon/model/about_response.dart';
import 'package:beauty_saloon/model/otp_response.dart';
import 'package:beauty_saloon/model/salon.dart';
import 'package:beauty_saloon/model/salon_by_country_city_service_model.dart';
import 'package:beauty_saloon/model/salon_model.dart';
import 'package:beauty_saloon/model/sliders_response.dart';

class StaticData {

  static SalonModel salonModel;
  static SalonByCountryCityServiceModel salonByCountryCityServiceModel;

  static List<Salon> favouriteSalonsList = [];

  static OTPResponse userData;

  static SlidersResponse slidersResponse;
  static AboutResponse aboutResponse;

  static String countryId = '';
  static String countryName = '';

  static String cityId = '';
  static String cityName = '';

  static String serviceType = '';
  static String serviceTypeName = '';

  static String startPrice = '0';
  static String endPrice = '1000';
  static String playerId = '';



}