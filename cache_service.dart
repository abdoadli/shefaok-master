import 'package:shared_preferences/shared_preferences.dart';

class CacheService {
  static SharedPreferences? sharedPreferences;
  static init() async {
    sharedPreferences = await SharedPreferences.getInstance();
  }

  static Future<bool> setData({
    required dynamic key,
    required dynamic value,
  }) async {
    if (value is bool) {
      return await sharedPreferences!.setBool(key, value);
    }
    if (value is double) {
      return await sharedPreferences!.setDouble(key, value);
    }
    if (value is int) {
      return await sharedPreferences!.setInt(key, value);
    }
    if (value is String) {
      return await sharedPreferences!.setString(key, value);
    }
    if (value is List<String>) {
      return await sharedPreferences!.setStringList(key, value);
    }
    return true;
  }

  static getData({required dynamic key}) {
    return sharedPreferences!.get(key);
  }

  static Future<bool> removeData({required dynamic key}) {
    return sharedPreferences!.remove(key);
  }

  static Future<bool> clearData() {
    return sharedPreferences!.clear();
  }
}
