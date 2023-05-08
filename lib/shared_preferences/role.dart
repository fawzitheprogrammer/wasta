import 'package:shared_preferences/shared_preferences.dart';

class Role {
  // OnBoarding Screen shared preferences key
  static const String roleKey = 'roleKey';
  //static const String loginScreenKey = 'LoginKey';

  // An object of shared preferences
  static SharedPreferences? _preferences;

  // Intializing shared preferences
  static Future init() async {
    _preferences = await SharedPreferences.getInstance();
  }

  //bool isActive = true;

  static setIsUser({required bool isUser}) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    pref.setBool(roleKey, isUser);
  }

  static getRole() => _preferences!.getBool(roleKey) ?? false;
}

