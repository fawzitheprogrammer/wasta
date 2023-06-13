import 'package:flutter/material.dart';

Map<int, Color> colorScheme = {
  50: const Color.fromRGBO(0, 162, 255, .1),
  100: const Color.fromRGBO(0, 162, 255, .2),
  200: const Color.fromRGBO(0, 162, 255, .3),
  300: const Color.fromRGBO(0, 162, 255, .4),
  400: const Color.fromRGBO(0, 162, 255, .5),
  500: const Color.fromRGBO(0, 162, 255, .6),
  600: const Color.fromRGBO(0, 162, 255, .7),
  700: const Color.fromRGBO(0, 162, 255, .8),
  800: const Color.fromRGBO(0, 162, 255, .9),
  900: const Color.fromRGBO(0, 162, 255, 1),
};

MaterialColor primaryBlue = MaterialColor(0xff00a2ff, colorScheme);

Color primaryBlue40Percent = const Color.fromARGB(255, 101, 199, 255);

Color primaryBlue70Percent = const Color.fromARGB(255, 89, 191, 251);

Color bottomNavbarBg = const Color.fromARGB(255, 212, 237, 252);

Color secondaryColor = const Color(0xffF48C00);

List<Color> gradient = [
  // Top or left
  const Color(0xffF48C00),
  // bottom or right
  const Color(0xffFFA833),
];

Color red = const Color(0xffeb5757);

Color lightGrey = const Color(0xffffffff);

Color backgroundGrey1 = const Color(0xffeaeaea);

Color backgroundGrey2 = const Color(0xfff6f6f6);

Color backgroundGrey3 = const Color(0xfffafafa);

Color darkGrey1 = const Color(
  0xff333333,
);

Color darkGrey2 = const Color(
  0xff525252,
);

Color midGrey1 = const Color(
  0xff666666,
);

Color midGrey2 = const Color(
  0xff959595,
);

Color midGrey3 = const Color(
  0xffc4c4c4,
);
