// ignore: implementation_imports
import 'dart:async';

import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';
import 'package:wasta/components/contants.dart';
import 'package:wasta/components/firebase_vars.dart';
import 'package:wasta/components/progress_indicator.dart';
import 'package:wasta/components/time_format.dart';
import 'package:wasta/providers/appointment_provider.dart';
import 'package:wasta/providers/auth_provider.dart';
import 'package:wasta/providers/date_time_card_provider.dart';
import 'package:wasta/public_packages.dart';
import 'package:wasta/screens/users_screen/success_screen.dart';

import '../../components/components_barrel.dart';
import '../../components/url_launcher.dart';
import '../../models/appointments.dart';
import '../../navigation/navigator.dart';
import '../../providers/time_of_day.dart';

DateTime dateTime = DateTime.now();
int? appointmentHour;
int? expectedWorkTime;

class UserScreen extends StatefulWidget {
  const UserScreen({super.key, required this.expertID});

  final String expertID;

  @override
  State<UserScreen> createState() => _UserScreenState();
}

class _UserScreenState extends State<UserScreen> {
  //String location = '';

  List<String> services = ['Home Cleaning', 'Office Cleaning'];

  Shader linearGradient(Rect bounds) {
    return LinearGradient(
      colors: [primaryBlue.shade900, primaryBlue.shade200],
      begin: Alignment.centerRight,
      end: Alignment.centerLeft,
      stops: const [0.1, 1.0],
    ).createShader(bounds);
  }

  String _locationMessage = "";

  Future<void> _getCurrentLocation() async {
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Handle the case where the user denied the permission request
        setState(() {
          _locationMessage = "Location permission denied";
        });
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Handle the case where the user denied the permission permanently
      setState(() {
        _locationMessage = "Location permission permanently denied";
      });
      return;
    }

    final position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    setState(() {
      launchUrls(
          'https://www.google.com/maps/place/${position.latitude},${position.longitude}');
      _locationMessage =
          "Latitude: ${position.latitude}, Longitude: ${position.longitude}";
    });
  }


  TextEditingController? location = TextEditingController();

  final RegExp googleMapsPlusCodeRegex =
      RegExp(r'^[A-HJ-NP-Z\d]{2,10}\+(\w{2,3}){1,2}$');

  @override
  Widget build(BuildContext context) {
    dateTime = DateTime.now();
    final ap = Provider.of<AppointmentProvider>(context, listen: false);
    final user = Provider.of<AuthProvider>(context, listen: false);
    final time = Provider.of<Time>(context, listen: true);
    //final slider = Provider.of<SliderProvider>(context, listen: true);

    user.getUserDataFromFirestore();

    return Scaffold(
        appBar: AppBar(
          backgroundColor:
              Theme.of(context).colorScheme.background.withAlpha(20),
          leading: GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Icon(
              Icons.arrow_back,
              color: primaryBlue,
            ),
          ),
          elevation: 0.0,
        ),
        body: StreamBuilder(
          stream: firebaseFirestore
              .collection('experts')
              .doc(widget.expertID)
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return loading();
            } else {
              final expertData = snapshot.data!;

              // List time = expertData['availableTime'];

              return SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Padding(
                  padding:
                      EdgeInsets.symmetric(horizontal: 18.0.w, vertical: 18.h),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Hero(
                            tag: expertData['profilePic'],
                            child: Container(
                              alignment: Alignment.topCenter,
                              height: 95.h,
                              width: 100.w,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(14.r),
                                image: DecorationImage(
                                  image: NetworkImage(
                                    expertData['profilePic'],
                                  ),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 12.w,
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              textLabel(
                                text: expertData['name'],
                                fontSize: 28.sp,
                                color: themeColor(context).background,
                              ),
                              textLabel(
                                text: expertData['speciality'],
                                fontSize: 18.sp,
                                fontWeight: FontWeight.w400,
                                color: themeColor(context).onPrimary,
                              ),
                            ],
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 12.h,
                      ),
                      Container(
                        height: 80.h,
                        width: double.infinity,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(6.r),
                            color: primaryBlue40Percent.withAlpha(40)),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Row(
                                  children: [
                                    ShaderMask(
                                      shaderCallback: (Rect bounds) {
                                        return linearGradient(bounds);
                                      },
                                      blendMode: BlendMode.srcIn,
                                      child: SvgPicture.asset(
                                        getImage(
                                          folderName: 'icons',
                                          fileName: 'badge-check.svg',
                                        ),
                                        color: primaryBlue,
                                        width: 28.w,
                                      ),
                                    ),
                                    SizedBox(
                                      width: 6.w,
                                    ),
                                    Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        textLabel(
                                          text: 'Experience',
                                          fontSize: 14.sp,
                                          color: themeColor(context)
                                              .onPrimary
                                              .withAlpha(100),
                                          fontWeight: FontWeight.w400,
                                        ),
                                        textLabel(
                                          text: expertData['experience'] +
                                              ' years',
                                          fontSize: 14.sp,
                                          color: themeColor(context).background,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ],
                                    )
                                  ],
                                ),
                                Container(
                                  height: 30.h,
                                  width: 1.5.h,
                                  color: primaryBlue.withAlpha(40),
                                ),
                                Row(
                                  children: [
                                    ShaderMask(
                                      shaderCallback: (Rect bounds) {
                                        return linearGradient(bounds);
                                      },
                                      blendMode: BlendMode.srcIn,
                                      child: SvgPicture.asset(
                                        getImage(
                                          folderName: 'icons',
                                          fileName: 'sack-dollar.svg',
                                        ),
                                        color: primaryBlue,
                                        width: 28.w,
                                      ),
                                    ),
                                    SizedBox(
                                      width: 6.w,
                                    ),
                                    Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        textLabel(
                                          text: 'Price',
                                          fontSize: 14.sp,
                                          color: themeColor(context)
                                              .onPrimary
                                              .withAlpha(100),
                                          fontWeight: FontWeight.w400,
                                        ),
                                        textLabel(
                                          text:
                                              '\$${expertData['pricePerDay']} / Hour',
                                          fontSize: 14.sp,
                                          color: themeColor(context).background,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ],
                                    )
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 8.h,
                      ),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: 12.0.w, vertical: 8.h),
                          child: textLabel(
                            text: 'Choose Date',
                            color: themeColor(context).onPrimary.withAlpha(180),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 80.h,
                        child: const DateBox(),
                      ),
                      SizedBox(
                        height: 18.h,
                      ),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: 12.0.w, vertical: 8.h),
                          child: textLabel(
                            text: 'Expected work time',
                            color: themeColor(context).onPrimary.withAlpha(180),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 60.h,
                        child: DateTimeBox(),
                      ),
                      SizedBox(
                        height: 22.h,
                      ),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: 12.0.w, vertical: 8.h),
                          child: textLabel(
                            text: 'Appointment time',
                            color: themeColor(context).onPrimary.withAlpha(180),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: 8.0.w, vertical: 4.h),
                        child: buildTimeCard(
                          onTap: () {
                            time.timePicker(context);
                          },
                          label: timeFormat(dateTime.hour),
                          timeOfDay:
                              time.appointmentHour.format(context).toString(),
                        ),
                      ),
                      SizedBox(
                        height: 22.h,
                      ),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: 12.0.w, vertical: 8.h),
                          child: textLabel(
                            text: 'Your Address',
                            color: themeColor(context).onPrimary.withAlpha(180),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: textBox(
                          context: context,
                          isActive: false,
                          onSubmitted: (value) {
                            location!.text = value;
                          },
                          onTap: () {},
                          hintText: 'Tap the icon to open Google Maps',
                          controller: null,
                          suffixIcon: GestureDetector(
                            onTap: () => _getCurrentLocation(),
                            child: Icon(
                              Icons.location_on_rounded,
                              color: primaryBlue,
                            ),
                          ),
                          //keyboardType: TextInputType.streetAddress,
                        ),
                      ),
                      SizedBox(
                        height: 24.h,
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 8.0.w),
                        child: primaryButton(
                          onPressed: () {
                            print(dateTime.hour);
                            ap.getToken().then((value) {
                              // AppointmentProvider.getToken();
                              if (location!.text.isEmpty ||
                                  expectedWorkTime == null) {
                                showSnackBar(
                                  isFalse: true,
                                  bgColor: secondaryColor,
                                  content:
                                      'Either the selected time is not correct or one of the fields it not set, please check it and try again.',
                                  context: context,
                                  textColor: Colors.white,
                                );
                              } else {
                                if (AppointmentProvider.isSave) {
                                  String ran = ap.generateRandomString();
                                  AppointmentProvider.appointmentDocumentID =
                                      ran;
                                } else {}

                                final appointments = Appointments(
                                  expertName: expertData['name'],
                                  expertProfilePic: expertData['profilePic'],
                                  speciality: expertData['speciality'],
                                  experience:
                                      expertData['experience'] + ' years',
                                  location: location!.text,
                                  customerName: user.userModel.name,
                                  customerNumber: user.userModel.phoneNumber,
                                  customerProfilePic: user.userModel.profilePic,
                                  appointmentDate: dateTime.toString(),
                                  appointmentHour:
                                      time.appointmentHour.format(context),
                                  isApproved: false,
                                  expertId: widget.expertID,
                                  customerID:
                                      AppointmentProvider.currentUser!.uid,
                                  deviceToken: value,
                                  expertDocumentID:
                                      AppointmentProvider.appointmentDocumentID,
                                  customerDocumentID:
                                      AppointmentProvider.appointmentDocumentID,
                                  expectedWorkHour: '${expectedWorkTime}h',
                                );

                                ap
                                    .checkAppointmentExisting(
                                  expertID: widget.expertID,
                                  userID: AppointmentProvider.currentUser!.uid,
                                )
                                    .then((value) {
                                  if (!value && AppointmentProvider.isSave) {
                                    ap.saveAppointmentDataToFirebase(
                                        context: context,
                                        appointments: appointments,
                                        doctorID: widget.expertID,
                                        userID: AppointmentProvider
                                            .currentUser!.uid,
                                        onSuccess: () {
                                          ap
                                              .saveAppointmentDataToSP()
                                              .then((value) {
                                            AppointmentProvider.sendPushMessage(
                                              'You have a new appointment request',
                                              'New Appointment',
                                              expertData['deviceToken'],
                                            );
                                            getPageRemoveUntil(
                                              context,
                                              const AppointmentBooked(),
                                            );
                                          });
                                        });
                                  } else if (!AppointmentProvider.isSave) {
                                    ap.saveAppointmentDataToFirebase(
                                      context: context,
                                      appointments: appointments,
                                      doctorID: widget.expertID,
                                      userID:
                                          AppointmentProvider.currentUser!.uid,
                                      onSuccess: () {
                                        ap
                                            .saveAppointmentDataToSP()
                                            .then((value) {
                                          AppointmentProvider.sendPushMessage(
                                            'You have a new appointment request',
                                            'New Appointment',
                                            expertData['deviceToken'],
                                          );
                                          getPageRemoveUntil(
                                            context,
                                            const AppointmentBooked(),
                                          );
                                        });
                                      },
                                    );
                                  } else if (value) {
                                    showSnackBar(
                                      isFalse: true,
                                      bgColor: secondaryColor,
                                      content:
                                          'You already have an appointment with this user, please be patient until they accept your request.',
                                      context: context,
                                      textColor: Colors.white,
                                    );
                                  }
                                });
                              }
                            });
                          },
                          isLoading: false,
                          label: 'Book an appointment',
                          backgroundColor: secondaryColor,
                          size: Size(double.infinity.w, 60.h),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }
          },
        ));
  }

  Widget textBox(
      {TextEditingController? controller,
      Function()? onTap,
      Function(String)? onSubmitted,
      required bool isActive,
      String? hintText,
      required BuildContext context,
      Widget? suffixIcon,
      TextInputType? keyboardType,
      FocusNode? focusNode,
      Color? color}) {
    return TextField(
      focusNode: focusNode,
      //toolbarOptions:
      //ToolbarOptions(copy: true, paste: true, cut: true, selectAll: true),
      controller: controller,
      onTap: onTap,
      onSubmitted: onSubmitted,
      autofocus: false,
      style: GoogleFonts.poppins(
        fontSize: 14.sp,
        color: darkGrey2,
        //fontWeight: FontWeight.w500,
      ),
      decoration: InputDecoration(
        filled: true,
        fillColor: isActive
            ? backgroundGrey2
            : Theme.of(context).colorScheme.primaryContainer,
        border: OutlineInputBorder(
          borderSide: const BorderSide(width: 0.0, style: BorderStyle.none),
          borderRadius: BorderRadius.circular(6.r),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(
            width: 1.0,
            style: BorderStyle.solid,
            color: color ?? primaryBlue,
          ),
          borderRadius: BorderRadius.circular(6.r),
        ),
        hintText: hintText,
        hintStyle: GoogleFonts.poppins(
          fontSize: 14.sp,
          color: Theme.of(context).colorScheme.onPrimary,
          //fontWeight: FontWeight.w500,
        ),
        suffixIcon: suffixIcon,
      ),
      //selectionHeightStyle: BoxHeightStyle.,
      keyboardType: keyboardType ?? TextInputType.streetAddress,
      cursorColor: Theme.of(context).colorScheme.onPrimary,
    );
  }

  Widget buildTimeCard(
      {void Function()? onTap, String? timeOfDay, String? label}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 8.w),
        height: 60.h,
        width: double.infinity.w,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8.r),
          color: themeColor(context).primaryContainer,
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              textLabel(
                text: timeOfDay!.isEmpty ? label! : timeOfDay,
                color: themeColor(context).onPrimary,
              ),
              const Spacer(),
              SvgPicture.asset(
                getImage(
                  folderName: 'icons',
                  fileName: 'clock-five.svg',
                ),
                color: primaryBlue,
                width: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Widget timeBox(List<dynamic> time) {
  //   return StatefulBuilder(
  //     builder: (context, setState) => GridView.builder(
  //         shrinkWrap: true,
  //         gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
  //             mainAxisExtent: 50.h, crossAxisCount: 2),
  //         itemCount: time.length,
  //         //controller: scroller.timeCardScrollController,
  //         //itemCount: dateTimeBox.length,
  //         scrollDirection: Axis.vertical,
  //         physics: const NeverScrollableScrollPhysics(),
  //         itemBuilder: (context, index) {
  //           final isActive = index == selectedIndex;
  //           return Padding(
  //             padding: const EdgeInsets.all(4.0),
  //             child: GestureDetector(
  //               onTap: () {
  //                 setState(() {
  //                   selectedIndex = index;
  //                 });
  //                 selectHourAppointment = time[index];
  //               },
  //               child: Container(
  //                 width: 85.w,
  //                 height: 10.h,
  //                 decoration: BoxDecoration(
  //                   gradient: LinearGradient(
  //                     colors: isActive
  //                         ? [primaryBlue.shade900, primaryBlue.shade200]
  //                         : [
  //                             Theme.of(context).colorScheme.primaryContainer,
  //                             Theme.of(context).colorScheme.primaryContainer
  //                           ],
  //                     begin: Alignment.topLeft,
  //                     end: Alignment.bottomRight,
  //                   ),
  //                   borderRadius: BorderRadius.circular(6.r),
  //                 ),
  //                 child: Row(
  //                   mainAxisAlignment: MainAxisAlignment.center,
  //                   children: [
  //                     textLabel(
  //                       text: time[index],
  //                       fontSize: 16.sp,
  //                       color: isActive ? backgroundGrey1 : darkGrey2,
  //                     ),
  //                   ],
  //                 ),
  //               ),
  //             ),
  //           );
  //         }),
  //   );
  // }
}

class DateTimeBox extends StatelessWidget {
  DateTimeBox({
    super.key,
  });

  // final int hour;
  // final bool isActive;

  bool isActive = false;

  List<int> dateTimeBox = [];

  @override
  Widget build(BuildContext context) {
    final scroller = Provider.of<DateBoxProvider>(context, listen: false);

    int selectedIndex = -1;

    return StatefulBuilder(
      builder: (context, setState) => ListView(
        controller: scroller.timeCardScrollController,
        //itemCount: dateTimeBox.length,
        scrollDirection: Axis.horizontal,
        children: List.generate(12, (index) {
          index++;
          return Padding(
            padding: const EdgeInsets.all(4.0),
            child: GestureDetector(
              onTap: () {
                setState(() {
                  selectedIndex = index;
                  isActive = !isActive;
                  expectedWorkTime = index;
                  print(expectedWorkTime);
                  scroller.goToTimeCard(selectedIndex - 1);
                });
              },
              child: Container(
                width: 45.w,
                //height: 20.h,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: index == selectedIndex
                        ? [primaryBlue.shade900, primaryBlue.shade200]
                        : [
                            Theme.of(context).colorScheme.primaryContainer,
                            Theme.of(context).colorScheme.primaryContainer
                          ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(6.r),
                ),
                child: Center(
                  child: textLabel(
                    text: '${index}h',
                    fontSize: 15.sp,
                    color: index == selectedIndex ? backgroundGrey1 : darkGrey2,
                  ),
                ),
              ),
            ),
          );
        }),
      ),
    );
  }

  // Widget card(BuildContext context, bool isActive, int hour) {
  //   return
  // }
}

class DateBox extends StatefulWidget {
  const DateBox({
    super.key,
  });

  @override
  State<DateBox> createState() => _DateBoxState();
}

class _DateBoxState extends State<DateBox> {
  // final DateTime dateTime;
  num activeDateBox = 0;

  // List<String> getWeekDayName() {
  //   List<String> day = [];

  //   for (int i = 0; i < 6; i++) {
  //     for (int j = 0; j < 3; j++) {
  //       day.add(DateFormat('EEEE').format(dateBox[i].day.)[j]);
  //     }
  //   }

  //   return day;
  // }

  List<DateTime> dateBox = [];

  @override
  void initState() {
    super.initState();
    dateTime = DateTime.now().subtract(const Duration(days: 1));
    for (int i = 0; i < 6; i++) {
      dateTime = dateTime.add(const Duration(days: 1));
      dateBox.add(dateTime);
    }
    dateTime = DateTime.now();
  }

  String monthName(DateTime dateTime) {
    String name = '';

    // check if current date exceeds last day of month
    if (dateTime.day > DateTime(dateTime.year, dateTime.month + 1, 0).day) {
      dateTime = dateTime
          .add(const Duration(days: 1)); // add one day to move to next month

      name = DateFormat('MMMM').format(DateTime(dateTime.year, dateTime.month));
    } else {
      name = DateFormat('MMMM').format(DateTime(dateTime.year, dateTime.month));
    }
    // get name of current month

    return name;
  }

  @override
  Widget build(BuildContext context) {
    final scroller = Provider.of<DateBoxProvider>(context, listen: false);

    //print(dateBox);

    // Formatting current dateTime
    DateFormat('yyyy-MM-dd').format(DateTime.now());

    return ListView.builder(
      itemCount: dateBox.length,
      scrollDirection: Axis.horizontal,
      controller: scroller.dateCardScrollController,
      //mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      itemBuilder: ((context, index) {
        return GestureDetector(
          onTap: () {
            setState(() {
              activeDateBox = index;
              dateTime = dateBox[index];
              scroller.goToDateCard(index);
              print(dateTime);
            });
          },
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 8.0.w),
            child: Container(
              width: 85.h,
              decoration: BoxDecoration(
                color: index == activeDateBox ? primaryBlue : backgroundGrey1,
                gradient: LinearGradient(
                    colors: index == activeDateBox
                        ? [primaryBlue.shade900, primaryBlue.shade200]
                        : [
                            Theme.of(context).colorScheme.primaryContainer,
                            Theme.of(context).colorScheme.primaryContainer
                          ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight),
                borderRadius: BorderRadius.circular(6.r),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  textLabel(
                    text: DateFormat('MMMM')
                        .format(dateBox[index])
                        .toString()
                        .substring(0, 3),
                    fontSize: 14.sp,
                    color: index == activeDateBox ? backgroundGrey1 : darkGrey2,
                  ),
                  textLabel(
                    text: dateBox[index].day.toString(),
                    fontSize: 22.sp,
                    color:
                        index == activeDateBox ? backgroundGrey1 : primaryBlue,
                    fontWeight: FontWeight.w800,
                  ),
                  textLabel(
                    text: DateFormat('EEEE')
                        .format(dateBox[index])
                        .toString()
                        .substring(0, 3),
                    fontSize: 14.sp,
                    color: index == activeDateBox ? backgroundGrey1 : darkGrey2,
                  ),
                ],
              ),
            ),
          ),
        );
      }),
    );
  }
}
