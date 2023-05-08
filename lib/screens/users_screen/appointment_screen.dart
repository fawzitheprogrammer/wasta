import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:wasta/components/components_barrel.dart';
import 'package:wasta/navigation/navigator.dart';
import 'package:wasta/public_packages.dart';

import 'package:intl/intl.dart';
import 'package:wasta/screens/users_screen/user_screen.dart';

import '../../components/url_launcher.dart';
import '../../providers/appointment_provider.dart';

class AppointmentScreens extends StatelessWidget {
  const AppointmentScreens({super.key});

  Shader linearGradient(Rect bounds) {
    return LinearGradient(
      colors: [primaryBlue.shade900, primaryBlue.shade200],
      begin: Alignment.centerRight,
      end: Alignment.centerLeft,
      stops: const [0.1, 1.0],
    ).createShader(bounds);
  }

  @override
  Widget build(BuildContext context) {
    //requestPermission();

    return Scaffold(
      body: buildAppointmentList(context),
    );
  }

  Widget buildAppointmentList(BuildContext context) {
    final FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;

    final appointmentProvider =
        Provider.of<AppointmentProvider>(context, listen: false);

    return StreamBuilder(
      stream: firebaseFirestore
          .collection('users')
          .doc(AppointmentProvider.currentUser!.uid)
          .collection('appointments')
          .snapshots(),
      builder: ((context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(
              color: primaryBlue,
            ),
          );
        }

        //var fetchedData;
        List<Widget> appointmentsList = [];
        //int i = 0;
        for (var item in snapshot.data!.docs) {
          //i++;
          final fetchedData = item.data();

          // if (fetchedData['isApproved'] == true) {
          //   showBigTextNotification(
          //     title: 'Appointment Approved',
          //     body: 'Your appointment is approved',
          //     fln: flutterLocalNotificationsPlugin,
          //   );
          // }

          final appointmentCard = Padding(
            padding: EdgeInsets.all(8.0.w),
            child: Container(
              height: 300.h,
              width: 350.w,
              decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primaryContainer,
                  borderRadius: BorderRadius.circular(6.r)),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    children: [
                      Container(
                        height: 80.h,
                        width: 80.w,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(6.r),
                        ),
                        margin: const EdgeInsets.symmetric(horizontal: 14.0),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(6.r),
                          child: Image.network(
                            fetchedData['expertProfilePic'],
                            fit: BoxFit.fitHeight,
                          ),
                        ),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            '${fetchedData['expertName']}',
                            style: GoogleFonts.poppins(
                                fontSize: 16.sp,
                                color: Theme.of(context).colorScheme.onPrimary,
                                fontWeight: FontWeight.w600
                                //fontWeight: FontWeight.w500,
                                ),
                          ),
                          Text(
                            'Specialty : ${fetchedData['speciality']}',
                            style: GoogleFonts.poppins(
                              fontSize: 14.sp,
                              color: Theme.of(context).colorScheme.onPrimary,
                              //fontWeight: FontWeight.w500,
                            ),
                          ),
                          Text(
                            'Experience :  ${fetchedData['experience']}',
                            style: GoogleFonts.poppins(
                              fontSize: 14.sp,
                              color: Theme.of(context).colorScheme.onPrimary,
                              //fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                      Spacer(),
                      Column(
                        children: [
                          SvgPicture.asset(
                            getImage(
                              folderName: 'icons',
                              fileName: !fetchedData['isApproved']
                                  ? 'pending.svg'
                                  : 'check.svg',
                            ),
                            color: !fetchedData['isApproved']
                                ? Colors.orange
                                : Colors.green,
                            width: 24.w,
                          ),
                          SizedBox(
                            height: 4.h,
                          ),
                          textLabel(
                            text: !fetchedData['isApproved']
                                ? 'Pending'
                                : 'Approved',
                            fontSize: 10.sp,
                            color: !fetchedData['isApproved']
                                ? Colors.orange
                                : Colors.green,
                          )
                        ],
                      ),
                      SizedBox(
                        width: 15.w,
                      ),
                    ],
                  ),
                  Padding(
                    padding: EdgeInsets.all(12.0.w),
                    child: Container(
                      height: 100.h,
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
                                        fileName: 'calendar_filled.svg',
                                      ),
                                      color: primaryBlue,
                                       width: 18.w,
                                    ),
                                  ),
                                  SizedBox(
                                    width: 6.w,
                                  ),
                                  textLabel(
                                    text: DateFormat('yyyy-MM-dd')
                                        .format(
                                          DateTime.parse(
                                            fetchedData['appointmentDate'],
                                          ),
                                        )
                                        .toString(),
                                    fontSize: 14.sp,
                                    color: primaryBlue,
                                    fontWeight: FontWeight.w600,
                                  ),
                                  textLabel(
                                    text:
                                        ',${DateFormat('EEEE').format(DateTime.parse(fetchedData['appointmentDate'])).substring(0, 3)}',
                                    fontSize: 14.sp,
                                    color: primaryBlue,
                                    fontWeight: FontWeight.w600,
                                  ),
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
                                        fileName: 'clock-five.svg',
                                      ),
                                       width: 18.w,
                                      //color: primaryBlue,
                                    ),
                                  ),
                                  SizedBox(
                                    width: 6.w,
                                  ),
                                  textLabel(
                                      text: fetchedData['appointmentHour'],
                                      fontSize: 14.sp,
                                      color: primaryBlue,
                                      fontWeight: FontWeight.w600),
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
                                        fileName: 'business-time.svg',
                                      ),
                                      width: 18.w,
                                      //color: primaryBlue,
                                    ),
                                  ),
                                  SizedBox(
                                    width: 6.w,
                                  ),
                                  textLabel(
                                      text: fetchedData['expectedWorkHour'],
                                      fontSize: 14.sp,
                                      color: primaryBlue,
                                      fontWeight: FontWeight.w600),
                                ],
                              ),
                            ],
                          ),
                          Divider(
                            indent: 10.w,
                            thickness: 1,
                            endIndent: 10.w,
                            color: primaryBlue.withAlpha(40),
                          ),
                          SizedBox(
                            height: 5.h,
                          ),
                          GestureDetector(
                            onTap: () {
                              launchUrls(
                                  'https://www.google.com/maps/search/${item.get('location').toString().trim()}');
                            },
                            child: Padding(
                              padding: EdgeInsets.symmetric(horizontal: 6.0.w),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  ShaderMask(
                                    shaderCallback: (Rect bounds) {
                                      return linearGradient(bounds);
                                    },
                                    blendMode: BlendMode.srcIn,
                                    child: SvgPicture.asset(
                                      getImage(
                                        folderName: 'icons',
                                        fileName: 'marker.svg',
                                      ),
                                      //color: primaryBlue,
                                      width: 15.w,
                                    ),
                                  ),
                                  SizedBox(
                                    width: 6.w,
                                  ),
                                  Flexible(
                                    child: textLabel(
                                      text: item.get('location'),
                                      fontSize: 12.sp,
                                      color: primaryBlue,
                                      fontWeight: FontWeight.w600,
                                      letterSpacing: 1.0,
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 12.0.w),
                    child: Row(
                      children: [
                        Expanded(
                          child: primaryButton(
                            label: 'Reschedule',
                            backgroundColor: primaryBlue,
                            size: Size(0, 70.h),
                            shadow: 2.0,
                            shadowColor: const Color(0xff17cfb6).withAlpha(60),
                            onPressed: () {
                              AppointmentProvider.isSave = false;
                              // AppointmentProvider.appointmentDocumentID =
                              //     item.id;

                              AppointmentProvider.appointmentDocumentID =
                                  item.id;

                              getPage(
                                context,
                                UserScreen(
                                  expertID: fetchedData['expertId'],
                                ),
                              );
                            },
                          ),
                        ),
                        SizedBox(
                          width: 8.w,
                        ),
                        Expanded(
                          child: primaryButton(
                            label: 'Cancel',
                            backgroundColor:
                                Theme.of(context).colorScheme.primaryContainer,
                            size: Size(0, 70.h),
                            //shadow: 2.0,
                            //shadowColor: Color(0xfff17cfb6).withAlpha(60),
                            onPressed: () {
                              // print(item.id);
                              // print(item.get('doctorID'));
                              appointmentProvider.deleteAppointment(item.id,
                                  item.get('expertId'), item.get('customerID'));
                            },
                            borderColor: primaryBlue.withAlpha(40),
                            borderWidth: 2,
                            textColor: primaryBlue,
                          ),
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
          );

          appointmentsList.add(appointmentCard);
        }
        //print(fetchedData['doctorName']);

        return appointmentsList.isNotEmpty
            ? ListView(
                children: appointmentsList,
              )
            : Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SvgPicture.asset(
                          getImage(
                            folderName: 'vectors',
                            fileName: 'appointment.svg',
                          ),
                          width: 200.h,
                        ),
                        SizedBox(
                          width: 24.w,
                        )
                      ],
                    ),
                    SizedBox(
                      height: 28.h,
                    ),
                    textLabel(
                        text: 'You have no appointments yet.',
                        fontWeight: FontWeight.w500,
                        fontSize: 18.sp),
                    textLabel(
                      text: 'All your bookings appear in this screen.',
                      fontWeight: FontWeight.w400,
                      color: Theme.of(context)
                          .colorScheme
                          .onPrimary
                          .withAlpha(120),
                    ),
                  ],
                ),
              );
      }),
    );
  }
}
