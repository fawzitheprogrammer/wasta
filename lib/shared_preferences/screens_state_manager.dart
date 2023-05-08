import 'package:shared_preferences/shared_preferences.dart';

class ScreenStateManager {
  // OnBoarding Screen shared preferences key
  static const String onBoardingScreenKey = 'OnBoardingScreen';
  //static const String loginScreenKey = 'LoginKey';

  // An object of shared preferences
  static SharedPreferences? _preferences;

  // Intializing shared preferences
  static Future init() async {
    _preferences = await SharedPreferences.getInstance();
  }

  static setPageOrderID(isOnBoardingCompleted) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    pref.setInt(onBoardingScreenKey, isOnBoardingCompleted);
  }

  static int getPageID() => _preferences!.getInt(onBoardingScreenKey) ?? 0;
}
