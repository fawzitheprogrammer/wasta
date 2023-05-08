// ignore: unnecessary_import
import 'dart:math';

import 'package:wasta/components/text.dart';
import 'package:wasta/providers/appointment_provider.dart';
import 'package:wasta/public_packages.dart';
import 'package:wasta/screens//role_screen.dart';
import 'package:wasta/shared_preferences/screens_state_manager.dart';
import '../../components/components_barrel.dart';
import '../../providers/auth_provider.dart';
import '../../providers/bottom_narbar_provider.dart';
import '../../providers/theme_provider.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    final ap = Provider.of<AuthProvider>(context, listen: false);
    final bottomNavProvider = Provider.of<BottomNavBar>(context, listen: false);

    return Scaffold(
      body: SafeArea(
        child: SizedBox(
          height: MediaQuery.of(context).size.height,
          width: double.infinity,
          child: Padding(
            padding: EdgeInsets.all(12.0.w),
            child: FutureBuilder(
              future: ap.getUserDataFromFirestore(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                      child: CircularProgressIndicator(
                    color: primaryBlue,
                  ));
                } else {
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CircleAvatar(
                          radius: 68.r,
                          backgroundColor:
                              Theme.of(context).colorScheme.primaryContainer,
                          backgroundImage:
                              NetworkImage(ap.userModel.profilePic)),
                      SizedBox(
                        height: 12.h,
                      ),
                      textLabel(
                        text: ap.userModel.name,
                        fontSize: 28.sp,
                        color: primaryBlue,
                        fontWeight: FontWeight.bold,
                      ),
                      SizedBox(
                        height: 6.w,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          textLabel(
                            text: ap.userModel.phoneNumber,
                            fontSize: 18.sp,
                            color: Theme.of(context).colorScheme.onPrimary,
                            //fontWeight: FontWeight.bold,
                          ),
                          SizedBox(
                            width: 6.w,
                          ),
                          // GestureDetector(
                          //   child: SvgPicture.asset(
                          //     getImage(
                          //       folderName: 'icons',
                          //       fileName: 'edit.svg',
                          //     ),
                          //     color: Green,
                          //     width: 18.w,
                          //   ),
                          // ),
                        ],
                      ),
                      SizedBox(
                        height: 14.h,
                      ),
                      ProfileCard(
                        value: themeProvider.isDarkMode,
                        onChanged: ((value) {
                          final providerTheme = Provider.of<ThemeProvider>(
                              context,
                              listen: false);
                          providerTheme.toggleTheme(value);
                        }),
                        provider: themeProvider,
                        label: 'Dark Mode',
                        icon: 'moon.svg',
                        hasSwitch: true,
                      ),
                      // GestureDetector(
                      //   onTap: () {},
                      //   child: ProfileCard(
                      //     provider: themeProvider,
                      //     label: 'Notification',
                      //     icon: 'bell.svg',
                      //     hasSwitch: true,
                      //   ),
                      // ),
                      //
                      GestureDetector(
                        onTap: () {
                          ap.userSignOut().then((value) {
                            
                            bottomNavProvider.bottomNavIndex(0);
                            ScreenStateManager.setPageOrderID(1);
                            Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const RoleScreen(),
                              ),
                              (route) => false,
                            );
                          });
                        },
                        child: ProfileCard(
                          provider: themeProvider,
                          label: 'Sign out',
                          icon: 'sign-out-alt.svg',
                          hasSwitch: false,
                        ),
                      ),
                    ],
                  );
                }
              },
            ),
          ),
        ),
      ),
    );
  }
}

class ProfileCard extends StatelessWidget {
  const ProfileCard({
    Key? key,
    this.value,
    this.onChanged,
    required this.provider,
    required this.label,
    required this.icon,
    this.hasSwitch,
  }) : super(key: key);

  final ThemeProvider provider;
  final String label;
  final String icon;
  final bool? hasSwitch;
  final Function(bool)? onChanged;
  final bool? value;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(
        horizontal: 12.0.w,
        vertical: 8.h,
      ),
      padding: EdgeInsets.symmetric(vertical: 8.h),
      height: 80.h,
      width: 353.w,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primaryContainer,
        borderRadius: BorderRadius.circular(6.r),
      ),
      child: Row(
        children: [
          SizedBox(
            width: 24.0.w,
          ),
          SvgPicture.asset(
            getImage(
              folderName: 'icons',
              fileName: icon,
            ),
            color: primaryBlue,
          ),
          SizedBox(
            width: 8.0.w,
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  label,
                  style: GoogleFonts.poppins(
                    fontSize: 16.sp,
                    //[, Theme.of(context).colorScheme.primaryContainer],
                    color: Theme.of(context).colorScheme.onPrimary,
                    //fontWeight: FontWeight.w600
                    //fontWeight: FontWeight.w500,
                  ),
                ),
                // Text(
                //   'Cardiologist',
                //   style: GoogleFonts.poppins(
                //     fontSize: 14.sp,
                //     color: DarkGrey2,
                //     //fontWeight: FontWeight.w500,
                //   ),
                // ),
              ],
            ),
          ),
          const Spacer(),
          hasSwitch ?? false
              ? Switch.adaptive(
                  value: value ?? false,
                  onChanged: onChanged,
                  thumbColor: MaterialStatePropertyAll(primaryBlue),
                  inactiveThumbColor: midGrey2,
                  inactiveTrackColor: Colors.black12,
                  splashRadius: 20.r,
                )
              : Container()
        ],
      ),
    );
  }
}
