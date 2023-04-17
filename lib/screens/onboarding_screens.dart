import 'package:wasta/components/components_barrel.dart';
import 'package:wasta/navigation/navigator.dart';
import 'package:wasta/public_packages.dart';
import 'package:wasta/screens/login_screen.dart';

//import '../components/primary_button.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  // Page index
  int selectedIndex = 0;

  // a control that controls page transition
  PageController pageController = PageController();

  //
  List<String> keys = [];
  List<String> values = [];

  @override
  Widget build(BuildContext context) {
    // One method to set [pageOrderId] and open another screen
    appRouting() {
      //ScreenStateManager.setPageOrderID(1);
      getPage(context, const LoginScreen());
    }

    onboardingInfo.forEach(((key, value) {
      keys.add(key);
      values.add(value);
    }));

    return Scaffold(
      backgroundColor: primaryBlue,
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              height: 90.h,
            ),
            SizedBox(
              height: 450.75.h,
              //width: 350.75.w,
              child: PageView.builder(
                itemCount: vectorsPath.length,
                controller: pageController,
                onPageChanged: (value) {
                  selectedIndex = value;
                  //debugPrint(selectedIndex.toString());
                  setState(() {});
                },
                scrollDirection: Axis.horizontal,
                itemBuilder: (context, index) => buildOnScreenTextAndImage(
                  vectorsPath[index],
                  keys[index],
                  values[index],
                ),
              ),
            ),
            SizedBox(
              height: 50.h,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                3,
                (index) => Padding(
                  padding: EdgeInsets.symmetric(horizontal: 4.w),
                  child: CircleAvatar(
                    // if(index==selectdIndex){RETURN }ELSE{}
                    backgroundColor: index == selectedIndex
                        ? Colors.white
                        : primaryBlue40Percent,
                    radius: 5.r,
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 98.h,
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 44.0.w),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: TextButton(
                      style: ButtonStyle(
                        minimumSize: MaterialStatePropertyAll(
                          Size(154.98.w, 55.h),
                        ),
                      ),
                      onPressed: () {
                        //appRouting();
                      },
                      child: Text(
                        'Skip',
                        style: GoogleFonts.poppins(
                            fontSize: 15.sp, color: Colors.white),
                      ),
                    ),
                  ),
                  primaryButton(
                    onPressed: () {
                      if (selectedIndex < vectorsPath.length - 1) {
                        selectedIndex++;
                        pageController.animateToPage(selectedIndex,
                            duration: const Duration(milliseconds: 800),
                            curve: Curves.easeInOut);
                      } else {
                        appRouting();
                      }
                      setState(() {});
                    },
                    label: 'NEXT',
                    backgroundColor: primaryBlue40Percent,
                    size: Size(154.98.w, 55.h),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget buildOnScreenTextAndImage(
    String vectorPath,
    String header,
    String body,
  ) {
    bool isRulerImage = vectorPath == 'assets/vectors/v1.svg';

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SvgPicture.asset(
          vectorPath,
          width: isRulerImage ? 100.w : 350.75.w,
          height: isRulerImage ? 180.w : 230.h,
        ),
        SizedBox(
          height: isRulerImage ? 22.h : 2.h,
        ),
        Text(
          header,
          style: GoogleFonts.poppins(
              fontSize: 30.sp,
              fontWeight: FontWeight.bold,
              color: Colors.white),
        ),
        SizedBox(
          height: 12.h,
        ),
        Text(
          body,
          style: GoogleFonts.poppins(fontSize: 14.sp, color: Colors.white),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
