import 'package:country_code_picker_mp/country_code_picker.dart';
import 'package:keyboard_visibility_pro/keyboard_visibility_pro.dart';
import 'package:wasta/public_packages.dart';
import 'package:wasta/screens/role_screen.dart';

import '../components/components_barrel.dart';
import '../navigation/navigator.dart';
import '../providers/auth_provider.dart';

String? phoneNumberOnBoarding;

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  // Check if textfield is active
  bool isActive = false;

  // Individual gradient color for the shader
  Color gradientTop = Colors.transparent;
  Color gradientBottom = Colors.transparent;

  final RegExp phoneNumberRegex =
      RegExp(r'^\+964(751|750|782|783|784|79[0-9]|77[0-9])[0-9]{7}$');

  // 7510000000
  String countryCode = '+964';

  final TextEditingController phoneNumber = TextEditingController();

  String errorMessage = '';

  bool isLoading = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    //getUser();
  }

  @override
  Widget build(BuildContext context) {
    //debugPrint(Role.getRole().toString());

    return Scaffold(
      //backgroundColor: Theme.of(context).colorScheme.onPrimary,
      body: KeyboardVisibility(
        onChanged: (value) {
          if (value) {
            // If keyboard is active, do nothing
          } else {
            isActive = false;
            setState(() {});
          }
        },
        child: SafeArea(
          child: SizedBox(
            // decoration: BoxDecoration(
            //   image: DecorationImage(image: SvgPicture.asset('assetName'))
            // ),
            child: SingleChildScrollView(
              keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.manual,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Stack(
                    children: [
                      AnimatedContainer(
                        height: !isActive ? 300.h : 150.h,
                        width: double.infinity,
                        color: primaryBlue,
                        duration: const Duration(milliseconds: 200),
                        curve: Curves.easeInOut,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Wasta',
                              style: GoogleFonts.russoOne(
                                  fontSize: 68.sp, color: Colors.white),
                            ),
                            textLabel(
                              text: 'All services at your fingertips !',
                              color: Colors.white,
                              fontWeight: FontWeight.w400,
                            )
                          ],
                        ),
                      ),
                      // Container(
                      //   height: 30,
                      //   width: 100,
                      //   color: Colors.red,
                      // ),
                      Padding(
                        padding: EdgeInsets.all(16.0.w),
                        child: Align(
                          alignment: Alignment.topRight,
                          child: GestureDetector(
                            onTap: () {
                              getPage(context, const RoleScreen());
                            },
                            child: AnimatedSlide(
                              duration: const Duration(milliseconds: 500),
                              //direction: Direction.left,
                              curve: Curves.easeInOut,
                              offset: isActive
                                  ? const Offset(2, 0)
                                  : const Offset(0, 0),
                              child: Container(
                                width: 100.w,
                                height: 40.h,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8.r),
                                  gradient: LinearGradient(
                                    begin: Alignment.bottomLeft,
                                    end: Alignment.centerRight,
                                    stops: const [0.5, 0.9],
                                    colors: gradient,
                                  ),
                                ),
                                child: Center(
                                  child: textLabel(
                                    text: 'Change role',
                                    color: Colors.white,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                  SizedBox(
                    height: 48.h,
                  ),
                  Text(
                    'Welcome!',
                    style: GoogleFonts.poppins(
                      fontSize: 24.sp,
                      color: Theme.of(context).colorScheme.onPrimary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(
                    height: 4.h,
                  ),
                  Text(
                    'Type your number to sign-in or \n skip for now!',
                    style: GoogleFonts.poppins(
                      fontSize: 14.sp,
                      color: Theme.of(context).colorScheme.onPrimary,
                      //fontWeight: FontWeight.w500,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(
                    height: 40.h,
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 40.0.w),
                    child: SizedBox(
                      width: 314.w,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            height: 60.h,
                            decoration: BoxDecoration(
                              color: Theme.of(context)
                                  .colorScheme
                                  .primaryContainer,
                              borderRadius: BorderRadius.circular(6.r),
                            ),
                            child: Center(
                              child: CountryCodePicker(
                                initialSelection: 'IQ',
                                showCountryOnly: false,
                                padding: EdgeInsets.symmetric(
                                    horizontal: 12.w, vertical: 12.h),
                                onChanged: (value) {
                                  //checkBackgroundColor();
                                },
                                // barrierColor: Theme.of(context)
                                //     .colorScheme
                                //     .primaryContainer,
                                backgroundColor: Theme.of(context)
                                    .colorScheme
                                    .primaryContainer,
                                searchDecoration: InputDecoration(
                                  prefixIcon: Icon(Icons.search_rounded,
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onPrimary),
                                  filled: true,
                                  fillColor: Theme.of(context)
                                      .colorScheme
                                      .primaryContainer,
                                  border: OutlineInputBorder(
                                    borderSide: const BorderSide(
                                        width: 0.0, style: BorderStyle.none),
                                    borderRadius: BorderRadius.circular(6.r),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      width: 1.0,
                                      style: BorderStyle.solid,
                                      color: primaryBlue,
                                    ),
                                    borderRadius: BorderRadius.circular(6.r),
                                  ),
                                  hintText: 'Search (+964)',
                                  hintStyle: GoogleFonts.poppins(
                                    fontSize: 14.sp,
                                    color:
                                        Theme.of(context).colorScheme.onPrimary,
                                    //fontWeight: FontWeight.w500,
                                  ),
                                ),
                                textStyle: GoogleFonts.poppins(
                                  fontSize: 14.sp,
                                  //backgroundColor: MidGrey2,
                                  color:
                                      Theme.of(context).colorScheme.onPrimary,
                                  //fontWeight: FontWeight.w500,
                                ),
                                dialogSize: Size(400.w, 1200.h),
                                dialogTextStyle: GoogleFonts.poppins(
                                  fontSize: 14.sp,
                                  color:
                                      Theme.of(context).colorScheme.onPrimary,
                                  //fontWeight: FontWeight.w500,
                                ),
                                dialogBackgroundColor: Theme.of(context)
                                    .colorScheme
                                    .primaryContainer,
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 6.w,
                          ),
                          Expanded(
                            child: textField(
                              controller: phoneNumber,
                              context: context,
                              isActive: isActive,
                              onSubmitted: (value) {
                                if (phoneNumber.text.isNotEmpty) {
                                  if (phoneNumberRegex.hasMatch(
                                    countryCode +
                                        phoneNumber.text
                                            .replaceAll(' ', '')
                                            .trim(),
                                  )) {
                                    //sendOtpCode();
                                    sendOtpCode();
                                    isActive = false;
                                    isLoading = true;

                                    setState(() {});
                                  } else {
                                    errorMessage =
                                        '*Phone number is not in a correct format';
                                  }
                                }
                              },
                              onTap: () {
                                isActive = true;
                                setState(() {});
                              },
                              hintText: 'Phone number',
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  errorMessage.isNotEmpty
                      ? SizedBox(
                          height: 34.h,
                        )
                      : Container(),
                  errorMessage.isEmpty
                      ? Container()
                      : Text(
                          errorMessage,
                          style: GoogleFonts.poppins(
                            fontSize: 12.sp,
                            color: Colors.red,
                            //fontWeight: FontWeight.w500,
                          ),
                        ),
                  SizedBox(
                    height: 34.h,
                  ),
                  SizedBox(
                    width: 314.w,
                    child: primaryButton(
                      onPressed: () {
                        if (phoneNumberRegex
                            .hasMatch(countryCode + phoneNumber.text)) {
                          //sendOtpCode();
                          isActive = false;
                          isLoading = true;
                          sendOtpCode();
                        } else {
                          errorMessage =
                              '*Phone number is not in a correct format';
                        }

                        setState(() {});
                      },
                      isLoading: isLoading,
                      label: 'LOGIN',
                      backgroundColor: primaryBlue,
                      size: Size(62.48.w, 60.h),
                    ),
                  ),
                  // secondaryButton(
                  //     label: 'Skip for now',
                  //     onPressed: () {
                  //       //getPage(context, const AllScreens());
                  //     }),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void sendOtpCode() {
    //print('The Value : ${Role.getRole()}');
    final ap = Provider.of<AuthProvider>(context, listen: false);
    String phoneNum = phoneNumber.text.trim();
    //+9647518070601
    phoneNumberOnBoarding = '$countryCode${phoneNum.replaceAll(' ', '')}';
    //print(phoneNumberOnBoarding);
    ap.checkExistingPhone(phoneNumberOnBoarding!).then((value) {
      if (value) {
        errorMessage = 'This phone number is already registered.';
        isLoading = false;
        setState(() {});
      } else {
        ap.signInWithPhone(context, "+$countryCode$phoneNum");
      }
    });
  }
}
