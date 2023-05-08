import 'package:wasta/components/components_barrel.dart';
import 'package:wasta/public_packages.dart';
import 'package:wasta/screens/login_screen.dart';
import 'package:wasta/shared_preferences/role.dart';
import 'package:wasta/shared_preferences/screens_state_manager.dart';


class RoleScreen extends StatelessWidget {
  const RoleScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    Role role = Role();

    goToPage(bool isUser) {
      Role.setIsUser(isUser: isUser).then(
        (value) {
          ScreenStateManager.setPageOrderID(2);
          return Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
              builder: (context) => const LoginScreen(),
            ),
            (route) => false,
          );
        },
      );
    }

    // goToPage() {
    //   return Navigator.pushAndRemoveUntil(
    //       context,
    //       MaterialPageRoute(
    //         builder: (context) => const LoginScreen(),
    //       ),
    //       (route) => false);
    // }

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                textLabel(
                  text: 'How do you want to continue ?',
                  fontSize: 22,
                  color: colorScheme.onPrimary.withAlpha(120),
                ),
                SizedBox(
                  height: 22.h,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    RoleCard(
                      onTap: () {
                        ///goToPage();
                        goToPage(false);
                      },
                      header: 'As an Expert',
                      subtitle: 'Recieve job offers from customers.',
                      image: 'expert.svg',
                      cColor: primaryBlue.withAlpha(40),
                    ),
                    RoleCard(
                      onTap: () {
                        ///goToPage();
                        goToPage(true);
                      },
                      header: 'As a Customer',
                      subtitle: 'Find & hire experts to consult with them.',
                      image: 'customer.svg',
                      cColor: Colors.blue.withAlpha(40),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class RoleCard extends StatelessWidget {
  RoleCard({
    super.key,
    required this.header,
    required this.subtitle,
    required this.image,
    required this.cColor,
    required this.onTap,
  });

  final String header;
  final String subtitle;
  final String image;
  final Color cColor;
  void Function() onTap;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return GestureDetector(
      onTap: onTap,
      child: Container(
          padding: EdgeInsets.all(12.0.w),
          margin: EdgeInsets.all(4.0.w),
          height: 220.h,
          width: 180.w,
          decoration: BoxDecoration(
            color: colorScheme.primaryContainer,
            borderRadius: BorderRadius.circular(8.r),
          ),
          child: Center(
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Stack(
                    children: [
                      Positioned(
                        left: 20.w,
                        top: 10.h,
                        child: CircleAvatar(
                          backgroundColor: cColor,
                          radius: 26.r,
                        ),
                      ),
                      Align(
                        alignment: Alignment.center,
                        child: SvgPicture.asset(
                          getImage(
                            folderName: 'vectors',
                            fileName: image,
                          ),
                          width: header != "As an Expert" ? 80.w : 75.w,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 4.h,
                  ),
                  textLabel(
                    text: header,
                    fontSize: 16.spMax,
                    //fontWeight: FontWeight.w600,
                    color:
                        Theme.of(context).colorScheme.onPrimary.withAlpha(200),
                  ),
                  textLabel(
                    text: subtitle,
                    fontSize: 12.spMax,
                    color: midGrey2.withAlpha(160),
                    textAlign: TextAlign.center,
                  )
                ],
              ),
            ),
          )),
    );
  }
}
