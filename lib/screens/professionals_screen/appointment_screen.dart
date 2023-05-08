import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:wasta/components/components_barrel.dart';
import 'package:wasta/navigation/navigator.dart';
import 'package:wasta/public_packages.dart';

import 'package:intl/intl.dart';
import 'package:wasta/screens/users_screen/user_screen.dart';

import '../../components/url_launcher.dart';
import '../../providers/appointment_provider.dart';

class ExpertAppointmentScreens extends StatelessWidget {
  const ExpertAppointmentScreens({super.key});

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
            .collection('experts')
            .doc(AppointmentProvider.currentUser!.uid)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          bool isExpertApproved = snapshot.data!.get('isApproved');

          return StreamBuilder(
            stream: firebaseFirestore
                .collection('experts')
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
                              margin:
                                  const EdgeInsets.symmetric(horizontal: 14.0),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(6.r),
                                child: Image.network(
                                  fetchedData['customerProfilePic'],
                                  fit: BoxFit.fitHeight,
                                ),
                              ),
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  '${fetchedData['customerName']}',
                                  style: GoogleFonts.poppins(
                                      fontSize: 28.sp,
                                      color: Theme.of(context)
                                          .colorScheme
                                          .background,
                                      fontWeight: FontWeight.w600
                                      //fontWeight: FontWeight.w500,
                                      ),
                                ),
                                Text(
                                  'Phone : ${fetchedData['customerNumber']}',
                                  style: GoogleFonts.poppins(
                                    fontSize: 14.sp,
                                    color:
                                        Theme.of(context).colorScheme.onPrimary,
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
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
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
                                                  fetchedData[
                                                      'appointmentDate'],
                                                ),
                                              )
                                              .toString(),
                                          fontSize: 12.sp,
                                          color: primaryBlue,
                                          fontWeight: FontWeight.w600,
                                        ),
                                        textLabel(
                                          text:
                                              ',${DateFormat('EEEE').format(DateTime.parse(fetchedData['appointmentDate'])).substring(0, 3)}',
                                          fontSize: 12.sp,
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
                                          fontSize: 12.sp,
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
                                            text:
                                                fetchedData['expectedWorkHour'],
                                            fontSize: 12.sp,
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
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 6.0.w),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
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
                              fetchedData['isApproved'] == false
                                  ? Expanded(
                                      child: primaryButton(
                                        label: 'Accept',
                                        backgroundColor: primaryBlue,
                                        size: Size(0, 70.h),
                                        shadow: 2.0,
                                        shadowColor: const Color(0xff17cfb6)
                                            .withAlpha(60),
                                        onPressed: () {
                                          if (dateTime != null) {
                                            updateDocuemnt(
                                                    firestore:
                                                        firebaseFirestore,
                                                    parentCollection: 'users',
                                                    userDocumentID: fetchedData[
                                                        'customerID'],
                                                    appointMentID: fetchedData[
                                                        'customerDocumentID'],
                                                    date: dateTime.toString())
                                                .then((value) {
                                              updateDocuemnt(
                                                firestore: firebaseFirestore,
                                                parentCollection: 'experts',
                                                userDocumentID:
                                                    fetchedData['expertId'],
                                                appointMentID: fetchedData[
                                                    'expertDocumentID'],
                                                date: dateTime.toString(),
                                              ).then((value) {
                                                AppointmentProvider
                                                    .sendPushMessage(
                                                  '${fetchedData['customerName']} accepted your appointment',
                                                  'Appointment Accepted',
                                                  fetchedData['deviceToken'],
                                                );
                                              });
                                            });
                                          } else {
                                            updateDocuemnt(
                                                    firestore:
                                                        firebaseFirestore,
                                                    parentCollection: 'users',
                                                    userDocumentID: fetchedData[
                                                        'customerID'],
                                                    appointMentID: fetchedData[
                                                        'customerDocumentID'],
                                                    date: dateTime.toString())
                                                .then((value) {
                                              updateDocuemnt(
                                                firestore: firebaseFirestore,
                                                parentCollection: 'experts',
                                                userDocumentID:
                                                    fetchedData['expertId'],
                                                appointMentID: fetchedData[
                                                    'expertDocumentID'],
                                                date: dateTime.toString(),
                                              ).then((value) {
                                                AppointmentProvider
                                                    .sendPushMessage(
                                                  '${fetchedData['customerName']} accepted your appointment',
                                                  'Appointment Accepted',
                                                  fetchedData['deviceToken'],
                                                );
                                              });
                                            });
                                          }
                                        },
                                      ),
                                    )
                                  : Container(),
                              SizedBox(
                                width: 8.w,
                              ),
                              Expanded(
                                child: primaryButton(
                                  label: 'Cancel',
                                  backgroundColor: Theme.of(context)
                                      .colorScheme
                                      .primaryContainer,
                                  size: Size(0, 70.h),
                                  //shadow: 2.0,
                                  //shadowColor: Color(0xfff17cfb6).withAlpha(60),
                                  onPressed: () {
                                    // print(item.id);
                                    // print(item.get('doctorID'));
                                    appointmentProvider.deleteAppointment(
                                        item.id,
                                        item.get('expertId'),
                                        item.get('customerID'));
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

              if (!isExpertApproved) {
                return Center(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SvgPicture.asset(
                          getImage(
                              folderName: 'vectors', fileName: 'waiting.svg'),
                          width: 310.w,
                        ),
                        SizedBox(
                          height: 18.h,
                        ),
                        textLabel(
                          text: 'Your information is under reviewing!',
                          color: Theme.of(context).colorScheme.onPrimary,
                          fontSize: 16.sp,
                        ),
                        SizedBox(
                          height: 4.h,
                        ),
                        textLabel(
                          text:
                              'Unfortunately you will not be able to recieve any appointments from customer until we are done reviwisng your information.\n thanks for you patience.',
                          color: Theme.of(context)
                              .colorScheme
                              .onPrimary
                              .withAlpha(100),
                          textAlign: TextAlign.center,
                          fontSize: 12.sp,
                        )
                      ],
                    ),
                  ),
                );
              } else if (isExpertApproved && snapshot.data!.docs.isNotEmpty) {
                return ListView(
                  children: appointmentsList,
                );
              } else {
                return Center(
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
              }
            }),
          );
        });
  }

  Future<void> updateDocuemnt(
      {required FirebaseFirestore firestore,
      required String parentCollection,
      required String userDocumentID,
      required String appointMentID,
      required String date}) {
    final documentReference = firestore
        .collection(parentCollection)
        .doc(userDocumentID)
        .collection('appointments')
        .doc(appointMentID);

    return documentReference
        .update({'isApproved': true, 'appointmentDate': date});
  }
}
