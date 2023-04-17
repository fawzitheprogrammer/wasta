import 'package:flutter/cupertino.dart';

class BottomNavBar extends ChangeNotifier {
  
  int index = 0;

  int get currentIndex => index;

  PageController pageController = PageController();

  PageController get pageAnimater => pageController;

  void bottomNavIndex(int value) {
    index = value;
    notifyListeners();
  }

  void animateToPage(PageController controller) {
    controller.animateToPage(
      currentIndex,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
    notifyListeners();
  }
}
