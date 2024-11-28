import 'package:shared_preferences/shared_preferences.dart';

class HelperFunctions {
  static const String _sharedPreferenceUserLoggedInKey = "ISLOGGEDIN";
  static const String _sharedPreferenceUserNameKey = "USERNAMEKEY";
  static const String _sharedPreferenceUserEmailKey = "USEREMAILKEY";
  static const String _sharedPreferenceUserAvatarKey = "USERAVATARKEY";

  static Future<SharedPreferences> _getPrefs() async {
    return await SharedPreferences.getInstance();
  }

  static Future<bool> _saveSharedPreference<T>(String key, T value) async {
    SharedPreferences prefs = await _getPrefs();
    if (value is bool) {
      return prefs.setBool(key, value);
    } else if (value is String) {
      return prefs.setString(key, value);
    }
    return false;
  }

  static Future<bool> saveUserLoggedInSharedPreference(
      bool isUserLoggedIn) async {
    return _saveSharedPreference(
        _sharedPreferenceUserLoggedInKey, isUserLoggedIn);
  }

  static Future<bool> saveUserNameSharedPreference(String userName) async {
    return _saveSharedPreference(_sharedPreferenceUserNameKey, userName);
  }

  static Future<bool> saveUserEmailSharedPreference(String userEmail) async {
    return _saveSharedPreference(_sharedPreferenceUserEmailKey, userEmail);
  }

  static Future<bool> saveUserAvatarSharedPreference(String userAvatar) async {
    return _saveSharedPreference(_sharedPreferenceUserAvatarKey, userAvatar);
  }

  static Future<T?> _getSharedPreference<T>(String key) async {
    SharedPreferences prefs = await _getPrefs();
    return prefs.get(key) as T?;
  }

  static Future<bool?> getUserLoggedInSharedPreference() async {
    return _getSharedPreference<bool>(_sharedPreferenceUserLoggedInKey);
  }

  static Future<String?> getUserNameSharedPreference() async {
    return _getSharedPreference<String>(_sharedPreferenceUserNameKey);
  }

  static Future<String?> getUserEmailSharedPreference() async {
    return _getSharedPreference<String>(_sharedPreferenceUserEmailKey);
  }

  static Future<String?> getUserAvatarSharedPreference() async {
    return _getSharedPreference<String>(_sharedPreferenceUserAvatarKey);
  }
}
