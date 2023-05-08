import 'package:wasta/components/colors.dart';
import 'package:wasta/public_packages.dart';

// class Styles {
//   static ThemeData themeData(bool isDarkTheme, BuildContext context) {
//     return ThemeData(
//       primarySwatch: Green,
//       scaffoldBackgroundColor:
//           isDarkTheme ? const Color(0xfff1b1b1b) : BackgroundGrey2,
//       primaryColor: isDarkTheme ? const Color(0xfff1b1b1b) : Colors.white,
//       backgroundColor:
//           isDarkTheme ? const Color(0xfff1b1b1b) : const Color(0xffF1F5FB),
//       indicatorColor:
//           isDarkTheme ? const Color(0xff0E1D36) : const Color(0xffCBDCF8),
//       //buttonColor: isDarkTheme ? Color(0xff3B3B3B) : Color(0xffF1F5FB),
//       hintColor:
//           isDarkTheme ? const Color(0xff280C0B) : const Color(0xffEECED3),
//       highlightColor:
//           isDarkTheme ? const Color(0xff372901) : const Color(0xffFCE192),
//       hoverColor:
//           isDarkTheme ? const Color(0xff3A3A3B) : const Color(0xff4285F4),
//       focusColor:
//           isDarkTheme ? const Color(0xff0B2512) : const Color(0xffA8DAB5),
//       disabledColor: Colors.grey,
//       cardColor: isDarkTheme ? const Color(0xFF151515) : Colors.white,
//       canvasColor: isDarkTheme ? Colors.black : Colors.grey[50],
//       brightness: isDarkTheme ? Brightness.dark : Brightness.light,
//       buttonTheme: Theme.of(context).buttonTheme.copyWith(
//           colorScheme: isDarkTheme
//               ? const ColorScheme.dark()
//               : const ColorScheme.light()),
//       appBarTheme: const AppBarTheme(
//         elevation: 0.0,
//       ),
//       textTheme: TextTheme(
//           headline1: GoogleFonts.poppins(
//         fontSize: 14.sp,
//         color: isDarkTheme ? BackgroundGrey1 : Green,
//         fontWeight: FontWeight.w500,
//         letterSpacing: 0,
//       )),
//       // textSelectionTheme: TextSelectionThemeData(
//       //   selectionColor: isDarkTheme ? Colors.white : Colors.black,
//       // ),
//     );
//   }
// }

class MyTheme {
  static final lightTheme = ThemeData.light().copyWith(
    // primaryColor: Colors.blue,
    //primarySwatch: Green,
    scaffoldBackgroundColor: backgroundGrey2,
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      backgroundColor: backgroundGrey2,
      // selectedLabelStyle: GoogleFonts.poppins(
      //   fontSize: 12.sp,
      //   color: DarkGrey2,
      //   //fontWeight: FontWeight.bold,
      // ),
      // unselectedLabelStyle: GoogleFonts.poppins(
      //   fontSize: 12.sp,
      //   color: DarkGrey2,
      //   //fontWeight: FontWeight.w600,
      // ),
    ),
    colorScheme: ColorScheme.dark(
      onPrimary: darkGrey2,
      primary: backgroundGrey2,
      primaryContainer: const Color.fromARGB(255, 236, 236, 236),
      background: primaryBlue,
    ),
    textSelectionTheme: TextSelectionThemeData(
      //cursorColor: Green,
      selectionHandleColor: primaryBlue,
      selectionColor: primaryBlue,
    ),
  );

  static final darkTheme = ThemeData.dark().copyWith(
    primaryColor: primaryBlue,
    scaffoldBackgroundColor: const Color(0xff242124),
    colorScheme: ColorScheme.light(
      onPrimary: backgroundGrey1,
      primary: const Color(
        0xff242124,
      ),
      primaryContainer: const Color.fromARGB(255, 31, 31, 31),
      //background: primaryBlue,
    ),
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      backgroundColor: const Color(0xff242124),
      selectedLabelStyle: GoogleFonts.poppins(
        fontSize: 12.sp,
        color: darkGrey2,
        //fontWeight: FontWeight.bold,
      ),
      // unselectedLabelStyle: GoogleFonts.poppins(
      //   fontSize: 12.sp,
      //   color: DarkGrey2,
      //   //fontWeight: FontWeight.w600,
      // ),
    ),
  );
}
