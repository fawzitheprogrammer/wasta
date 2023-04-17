import 'package:wasta/components/components_barrel.dart';
import 'package:wasta/providers/providers_barrel.dart';
import 'package:wasta/providers/theme_provider.dart';
import 'package:wasta/public_packages.dart';
import 'package:wasta/screens/onboarding_screens.dart';
import 'package:wasta/theme/theme_style.dart';

import 'screens/role_screen.dart';
import 'screens/users_screen/home_screen.dart';

void main() {
  SystemChrome.setSystemUIOverlayStyle(
    SystemUiOverlayStyle(
        statusBarColor: primaryBlue, systemNavigationBarColor: primaryBlue),
  );

  runApp(MyApp());
}

// ignore: must_be_immutable
class MyApp extends StatelessWidget {
  MyApp({super.key});
  bool darkMode = false;

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => ThemeProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => BottomNavBar(),
        ),
      ],
      child: ScreenUtilInit(
        builder: (context, child) {
          final provider = Provider.of<ThemeProvider>(context);

          return MaterialApp(
            themeMode: provider.themeMode,
            debugShowCheckedModeBanner: false,
            theme: MyTheme.lightTheme,
            darkTheme: MyTheme.darkTheme,
            home: RoleScreen(),
          );
        },
        designSize: const Size(393, 851),
        minTextAdapt: true,
      ),
    );
  }
}

class AllScreens extends StatelessWidget {
  const AllScreens({super.key});

  @override
  Widget build(BuildContext context) {
    int currentIndex =
        Provider.of<BottomNavBar>(context, listen: true).currentIndex;
    final provider = Provider.of<BottomNavBar>(context, listen: false);

    return Scaffold(
      body: PageView(
        //: currentIndex,
        controller: provider.pageController,
        physics: const NeverScrollableScrollPhysics(),
        children: true
            ? [
                HomeScreen(),
                //AppointmentScreen(),
                //FavScreen(),
                //ProfileScreen(),
              ]
            : const [
                //DoctorAppointmentScreen(),
                //DoctorProfileScreen(),
              ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: bottomNavbarBg,
        onTap: (value) {
          provider.bottomNavIndex(value);
          provider.animateToPage(provider.pageController);
        },
        currentIndex: currentIndex,
        showSelectedLabels: true,
        showUnselectedLabels: true,
        selectedItemColor: primaryBlue,
        unselectedItemColor: midGrey2,
        selectedLabelStyle: GoogleFonts.poppins(
          fontSize: 12.sp,
          color: Theme.of(context).colorScheme.onPrimary,
          //fontWeight: FontWeight.bold,
        ),
        unselectedLabelStyle: GoogleFonts.poppins(
          fontSize: 12.sp,
          color: Theme.of(context).colorScheme.onPrimary,
          //fontWeight: FontWeight.w600,
        ),
        type: BottomNavigationBarType.fixed,
        items: true
            ? [
                navBarItem(
                  label: 'Home',
                  activeIconName: 'home.svg',
                  inActiveIconName: 'home_filled.svg',
                ),
                navBarItem(
                    label: 'Bookings',
                    activeIconName: 'calendar.svg',
                    inActiveIconName: 'calendar_filled.svg'),
                // navBarItem(
                //     label: 'Favourite',
                //     activeIconName: 'heart.svg',
                //     inActiveIconName: 'heart_filled.svg'),
                navBarItem(
                  label: 'Profile',
                  activeIconName: 'user_outlined.svg',
                  inActiveIconName: 'user_filled.svg',
                ),
              ]
            : [
                navBarItem(
                  label: 'Appointments',
                  activeIconName: 'calendar.svg',
                  inActiveIconName: 'calendar_filled.svg',
                ),
                navBarItem(
                  label: 'Profile',
                  activeIconName: 'user_outlined.svg',
                  inActiveIconName: 'user_filled.svg',
                ),
              ],
      ),
    );
  }

  navBarItem({
    required String label,
    required String activeIconName,
    required String inActiveIconName,
  }) {
    return BottomNavigationBarItem(
      label: label,
      icon: Padding(
        padding: EdgeInsets.all(3.0.w),
        child: SvgPicture.asset(
          getImage(folderName: 'icons', fileName: activeIconName),
          width: 24,
          height: 24,
          color: midGrey2.withAlpha(80),
        ),
      ),
      activeIcon: Padding(
        padding: EdgeInsets.all(3.0.w),
        child: SvgPicture.asset(
          getImage(folderName: 'icons', fileName: inActiveIconName),
          width: 24,
          height: 24,
          color: primaryBlue,
        ),
      ),
    );
  }
}
