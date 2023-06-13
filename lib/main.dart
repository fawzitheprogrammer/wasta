import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:rive/rive.dart';
import 'package:wasta/components/components_barrel.dart';
import 'package:wasta/components/contants.dart';
import 'package:wasta/firebase_options.dart';
import 'package:wasta/providers/appointment_provider.dart';
import 'package:wasta/providers/auth_provider.dart';
import 'package:wasta/providers/date_time_card_provider.dart';
import 'package:wasta/providers/providers_barrel.dart';
import 'package:wasta/providers/slider_provider.dart';
import 'package:wasta/providers/time_of_day.dart';
import 'package:wasta/public_packages.dart';
import 'package:wasta/push_notification/push_notification.dart';
import 'package:wasta/screen_tobe_shown.dart';
import 'package:wasta/screens/professionals_screen/appointment_screen.dart';
import 'package:wasta/screens/professionals_screen/profile_screen.dart';
import 'package:wasta/screens/users_screen/appointment_screen.dart';
import 'package:wasta/screens/users_screen/profile_screen.dart';
import 'package:wasta/theme/theme_style.dart';

import 'screens/users_screen/home_screen.dart';
import 'shared_preferences/shared_pref_barrel.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
   await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform);

  SystemChrome.setSystemUIOverlayStyle(
    SystemUiOverlayStyle(
        statusBarColor: primaryBlue, systemNavigationBarColor: primaryBlue),
  );

  requestPermission();
  loadFCM();
  listenFCM();

  await ScreenStateManager.init();
  await Role.init();
  runApp(MyApp());
}

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  //bool isConnected = true;

  List<Widget> noNet = [];

  @override
  void initState() {
    super.initState();
    load();
  }

  Future<void> load() async {
    Future.delayed(const Duration(seconds: 5))
        .then((value) => checkConnection().then((value) {
              print(value);
              if (value) {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AppRouter.getPage(),
                  ),
                );
              } else {
                Future.delayed(const Duration(seconds: 5));
                noNet = [
                  SvgPicture.asset(
                    getImage(
                      folderName: 'icons',
                      fileName: 'wifi.svg',
                    ),
                    width: 82.w,
                    color: primaryBlue,
                  ),
                  textLabel(
                    text: 'No internet connection',
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.onPrimary,
                    fontSize: 20.sp,
                  ),
                  textLabel(
                    text: 'Try these steps to get back online',
                    fontSize: 18.sp,
                    color: Theme.of(context).colorScheme.onPrimary,
                  ),
                  SizedBox(
                    height: 14.h,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const InstructionBullet(
                        content: 'Check your modem and router',
                      ),
                      SizedBox(
                        height: 6.h,
                      ),
                      const InstructionBullet(
                        content: 'Check you mobile data',
                      ),
                      SizedBox(
                        height: 6.h,
                      ),
                      const InstructionBullet(content: 'Connect to WIFI'),

                      //Spacer(),
                      SizedBox(height: 38.h),
                      primaryButton(
                        onPressed: () {
                          load();
                        },
                        label: 'Reload',
                        backgroundColor: primaryBlue,
                        size: Size(120.w, 50.h),
                      )
                    ],
                  )
                ];
                setState(() {});
              }
            }));
  }

  Future<bool> checkConnection() async {
    bool isConnected = true;

    //
    final connectivityResult = await (Connectivity().checkConnectivity());

    if (connectivityResult == ConnectivityResult.mobile) {
      isConnected = true;
      //print(isConnected);
      //notifyListeners();
    } else if (connectivityResult == ConnectivityResult.wifi) {
      isConnected = true;
      //print(isConnected);
      //notifyListeners();
    } else {
      isConnected = false;
      //print(isConnected);
      //notifyListeners();
    }

    return isConnected;
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //backgroundColor: primaryBlue.shade100,
      body: Center(
        child: RefreshIndicator(
          onRefresh: checkConnection,
          color: primaryBlue,
          triggerMode: RefreshIndicatorTriggerMode.anywhere,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: noNet.isEmpty
                ? [
                    const Spacer(),
                    SizedBox(
                      height: 180.h,
                      width: 180.w,
                      child: const RiveAnimation.asset('assets/rive/logo.riv'),
                    ),
                    const Spacer(),
                    Padding(
                      padding: EdgeInsets.only(bottom: 44.h),
                      child: SizedBox(
                        height: 20.h,
                        width: 20.w,
                        child: CircularProgressIndicator(
                          color: primaryBlue,
                        ),
                      ),
                    ),
                    // : Container()
                  ]
                : noNet,
          ),
        ),
      ),
    );
  }
}

class InstructionBullet extends StatelessWidget {
  const InstructionBullet({
    super.key,
    required this.content,
  });

  final String content;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      //crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        //Spacer(),
        SizedBox(
          width: 60.w,
        ),
        CircleAvatar(
          backgroundColor: primaryBlue,
          radius: 10.r,
          child: SvgPicture.asset(
            getImage(
              folderName: 'icons',
              fileName: 'check.svg',
            ),
            width: 10.w,
            color: backgroundGrey1,
          ),
        ),
        SizedBox(
          width: 8.w,
        ),
        textLabel(
          text: content,
          fontSize: 16.sp,
          color: Theme.of(context).colorScheme.onPrimary,
        ),
        const Spacer(),
      ],
    );
  }
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
        ChangeNotifierProvider(
          create: (context) => DateBoxProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => AuthProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => AppointmentProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => Time(),
        ),
        ChangeNotifierProvider(
          create: (context) => SliderProvider(),
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
            home: const SplashScreen(),
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
        children: Role.getRole() == true
            ? [
                const HomeScreen(),
                const AppointmentScreens(),
                const ProfileScreen()

                ///UserInfromationScreen(),
                //FavScreen(),
                //ProfileScreen(),
              ]
            : const [
                ExpertAppointmentScreens(),
                ExpertProfileScreen()
                //DoctorProfileScreen(),
              ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: themeColor(context).primaryContainer,
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
        items: Role.getRole() == true
            ? [
                navBarItem(
                  label: 'Home',
                  activeIconName: 'home.svg',
                  inActiveIconName: 'home_filled.svg',
                ),
                navBarItem(
                  label: 'Bookings',
                  activeIconName: 'calendar.svg',
                  inActiveIconName: 'calendar_filled.svg',
                ),
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
