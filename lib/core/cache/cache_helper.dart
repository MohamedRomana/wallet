import 'package:shared_preferences/shared_preferences.dart';

class CacheHelper {
  static late SharedPreferences _preferences;
  static const _userId = 'id';
  static const _language = 'lang';
  // static const _token = 'token';
  static const _deviceToken = 'deviceToken';
  static const _type = 'type';

  static Future<void> init() async {
    _preferences = await SharedPreferences.getInstance();
  }

  static Future<bool> saveData({
    required String key,
    required dynamic value,
  }) async {
    if (value is String) return await _preferences.setString(key, value);
    if (value is int) return await _preferences.setInt(key, value);
    if (value is bool) return await _preferences.setBool(key, value);

    return false;
  }

  static dynamic getData({required String key}) {
    return _preferences.get(key);
  }

  static Future<bool> removeData({required String key}) async {
    return await _preferences.remove(key);
  }

  static Future<void> setUserId(String? id) async {
    await _preferences.setString(_userId, id ?? '');
  }

  static String getUserId() {
    return _preferences.getString(_userId) ?? '';
  }

  // static setUserToken(String? token) async {
  //   await _preferences.setString(_token, token ?? '');
  // }

  // static String getUserToken() {
  //   return _preferences.getString(_token) ?? '';
  // }

  static Future<void> setDeviceToken(String? deviceToken) async {
    await _preferences.setString(_deviceToken, deviceToken ?? '');
  }

  static String getDeviceToken() {
    return _preferences.getString(_deviceToken) ?? '';
  }

  static Future<void> setUserType(String? type) async {
    await _preferences.setString(_type, type ?? '');
  }

  static String getUserType() {
    return _preferences.getString(_type) ?? '';
  }

  static Future<void> removeUserId(String key) async {
    await _preferences.remove(_userId);
  }

  static Future<void> clearData() async {
    await _preferences.clear();
  }

  static Future<void> setLang(String lang) async {
    await _preferences.setString(_language, lang);
  }

  static String getLang() {
    return _preferences.getString(_language) ?? "";
  }
}
