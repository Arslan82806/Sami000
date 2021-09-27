import 'dart:convert';
import 'package:beauty_saloon/model/city_model.dart';
import 'package:beauty_saloon/model/salon.dart';
import 'package:beauty_saloon/model/sign_in_response.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPref {

  static read(String key) async {
    final prefs = await SharedPreferences.getInstance();
    dynamic data = prefs.getString(key);

    if (data != null) {

      return json.decode(prefs.getString(key));
    }
    return data;
  }

  static save(String key, value) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString(key, json.encode(value));
  }

  static saveUser(String key, SignInResponse userData) async {

    final prefs = await SharedPreferences.getInstance();
    prefs.setString(key, json.encode(userData));
    print(await prefs.getString(key));
  }

  static Future<bool> checkIfKeyExistsInSharedPref(String key) async {

    final prefs = await SharedPreferences.getInstance();
    if(prefs.containsKey(key)) {
      return true;
    }

    return false;
  }

  static saveCitiesList(String key, List<CityModel> citiesList) async {
    final prefs = await SharedPreferences.getInstance();

    prefs.setString(key, json.encode(citiesList));
    print(prefs.getString(key));
  }

  static saveFavSalonsList(String key, List<Salon> list) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString(key, json.encode(list));

  }


  static remove(String key) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.remove(key);
  }
}
