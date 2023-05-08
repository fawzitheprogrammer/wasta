import 'package:wasta/shared_preferences/screens_state_manager.dart';
import 'package:wasta/screens/login_screen.dart';
import 'package:wasta/screens/onboarding_screens.dart';

import 'main.dart';
import 'screens/role_screen.dart';

class AppRouter {
  // A static-dynamic function to get screens based on their id to be shown
  static dynamic getPage() {
    int pageID = ScreenStateManager.getPageID();

    switch (pageID) {
      case 0:
        return const OnboardingScreen();
      case 1:
        return const RoleScreen();
      case 2:
        return const LoginScreen();
      case 3:
        return const AllScreens();
    }
  }
}


/*

0 - OnboardingScreen
1 - RoleScreen
2 - LoginScreen
3 - AllScreen

*/