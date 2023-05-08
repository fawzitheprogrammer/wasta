import 'dart:io';

import 'package:wasta/components/components_barrel.dart';
import 'package:wasta/public_packages.dart';
import '../../components/contants.dart';
import '../../main.dart';
import '../../models/experts_model.dart';
import '../../providers/auth_provider.dart';
import '../../shared_preferences/shared_pref_barrel.dart';

class ExpertRegistrationForm extends StatefulWidget {
  const ExpertRegistrationForm({super.key});

  @override
  State<ExpertRegistrationForm> createState() => _ExpertRegistrationFormState();
}

class _ExpertRegistrationFormState extends State<ExpertRegistrationForm> {
  File? image;
  final nameController = TextEditingController();
  final experienceController = TextEditingController();
  final pricePerDay = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    nameController.dispose();
    //specialityController.dispose();
    experienceController.dispose();
  }

  // for selecting image
  void selectImage() async {
    image = await pickImage(context);
    setState(() {});
  }

  int? activeSpecialityIndex;

  List<int> activeIndexes = [];

  List<String> availableHours = [
    '8:00 AM - 11:00 AM',
    '11:00 AM - 01:00 PM',
    '1:00 AM - 3:00 PM',
    '3:00 AM - 5:00 PM',
    '5:00 PM - 7:00 PM',
    '7:00 PM - 9:00 PM',
  ];

  List<String> selectedAvailableHours = [];

  String speciality = '';

  String iconString = '';

  @override
  Widget build(BuildContext context) {
    final isLoading =
        Provider.of<AuthProvider>(context, listen: true).isLoading;
    // final appointmentProvider =
    //     Provider.of<AppointmentProvider>(context, listen: true);

    return Scaffold(
      body: SafeArea(
        child: isLoading == true
            ? Center(
                child: CircularProgressIndicator(
                  color: primaryBlue,
                ),
              )
            : Center(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(
                      vertical: 25.0, horizontal: 5.0),
                  child: Center(
                    child: Column(
                      children: [
                        InkWell(
                          onTap: () => selectImage(),
                          child: image == null
                              ? CircleAvatar(
                                  backgroundColor: primaryBlue,
                                  radius: 50,
                                  child: const Icon(
                                    Icons.add_a_photo_rounded,
                                    size: 50,
                                    color: Colors.white,
                                  ),
                                )
                              : CircleAvatar(
                                  backgroundImage: FileImage(image!),
                                  radius: 50,
                                ),
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width,
                          padding: const EdgeInsets.symmetric(
                            vertical: 5,
                            horizontal: 15,
                          ),
                          margin: const EdgeInsets.only(top: 20),
                          child: Column(
                            children: [
                              // name field
                              textFeld(
                                hintText: "Your name",
                                icon: Icons.account_circle,
                                inputType: TextInputType.name,
                                maxLines: 1,
                                controller: nameController,
                              ),

                              textFeld(
                                hintText: "Years of experience",
                                icon: Icons.account_circle,
                                inputType: TextInputType.number,
                                maxLines: 1,
                                controller: experienceController,
                              ),
                              textFeld(
                                hintText: "\$Price/Day",
                                icon: Icons.account_circle,
                                inputType: TextInputType.number,
                                maxLines: 1,
                                controller: pricePerDay,
                              ),

                              SizedBox(height: 8.h),
                              label('Your Specilaity'),
                              SizedBox(height: 8.h),
                              SizedBox(
                                child: Padding(
                                  padding: const EdgeInsets.all(4.0),
                                  child: GridView.builder(
                                      shrinkWrap: true,
                                      itemCount: categories.length,
                                      physics:
                                          const NeverScrollableScrollPhysics(),
                                      gridDelegate:
                                          SliverGridDelegateWithFixedCrossAxisCount(
                                        crossAxisCount: 4,
                                        childAspectRatio: 0.8.w,
                                      ),
                                      itemBuilder: (context, index) {
                                        final isActive =
                                            index == activeSpecialityIndex;

                                        return GestureDetector(
                                          onTap: () {
                                            setState(() {
                                              activeSpecialityIndex = index;
                                              speciality =
                                                  categoriesLabel[index];
                                            });
                                          },
                                          child: Padding(
                                            padding: const EdgeInsets.all(2.0),
                                            child: Container(
                                              // height: 60.h,
                                              // width: 100.w,
                                              decoration: BoxDecoration(
                                                color: themeColor(context)
                                                    .primaryContainer,
                                                borderRadius:
                                                    BorderRadius.circular(
                                                  2.r,
                                                ),
                                                border: Border.all(
                                                  width: isActive ? 2.0 : 0.0,
                                                  color: isActive
                                                      ? primaryBlue
                                                      : Colors.transparent,
                                                ),
                                              ),
                                              child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  Image.asset(
                                                    categories[index],
                                                    width: 50.w,
                                                  ),
                                                  SizedBox(height: 12.h),
                                                  textLabel(
                                                      text: categoriesLabel[
                                                          index],
                                                      color: midGrey2)
                                                ],
                                              ),
                                            ),
                                          ),
                                        );
                                      }),
                                ),
                              ),
                              SizedBox(height: 8.h),
                              // label('Available hours'),
                              // SizedBox(height: 8.h),
                              // SizedBox(
                              //   child: timeBox(),
                              // ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 20),
                        SizedBox(
                          // height: 50,
                          // width: MediaQuery.of(context).size.width * 0.90,
                          child: primaryButton(
                            label: 'Register',
                            backgroundColor: secondaryColor,
                            size: Size(
                                MediaQuery.of(context).size.width * 0.90, 70.h),
                            onPressed: () {
                              print(speciality);

                              if (speciality != '') {
                                storeData();
                              } else {
                                showSnackBar(
                                  bgColor: Colors.redAccent,
                                  content:
                                      "Please fill all fields correctly and try again.",
                                  context: context,
                                  textColor: Colors.white,
                                );
                              }
                              //setState(() {});
                            },
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
      ),
    );
  }

  Widget label(String label) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 12.0.w, vertical: 8.h),
        child: textLabel(
          text: label,
          color: themeColor(context).onPrimary.withAlpha(180),
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  // Widget timeBox() {
  //   return GridView.builder(
  //       shrinkWrap: true,
  //       gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
  //           mainAxisExtent: 50.h, crossAxisCount: 2),
  //       itemCount: availableHours.length,
  //       //controller: scroller.timeCardScrollController,
  //       //itemCount: dateTimeBox.length,
  //       scrollDirection: Axis.vertical,
  //       physics: const NeverScrollableScrollPhysics(),
  //       itemBuilder: (context, index) {
  //         final isActive = activeIndexes.contains(index);
  //         return Padding(
  //           padding: const EdgeInsets.all(4.0),
  //           child: GestureDetector(
  //             onTap: () {
  //               setState(() {
  //                 if (isActive) {
  //                   activeIndexes.remove(index);
  //                   selectedAvailableHours.remove(availableHours[index]);
  //                 } else {
  //                   activeIndexes.add(index);
  //                   selectedAvailableHours.add(availableHours[index]);
  //                 }

  //                 print(selectedAvailableHours);
  //               });
  //             },
  //             child: Container(
  //               width: 85.w,
  //               height: 10.h,
  //               decoration: BoxDecoration(
  //                 gradient: LinearGradient(
  //                   colors: isActive
  //                       ? [primaryBlue.shade900, primaryBlue.shade200]
  //                       : [
  //                           Theme.of(context).colorScheme.primaryContainer,
  //                           Theme.of(context).colorScheme.primaryContainer
  //                         ],
  //                   begin: Alignment.topLeft,
  //                   end: Alignment.bottomRight,
  //                 ),
  //                 borderRadius: BorderRadius.circular(6.r),
  //               ),
  //               child: Row(
  //                 mainAxisAlignment: MainAxisAlignment.center,
  //                 children: [
  //                   textLabel(
  //                     text: availableHours[index],
  //                     fontSize: 16.sp,
  //                     color: isActive ? backgroundGrey1 : darkGrey2,
  //                   ),
  //                 ],
  //               ),
  //             ),
  //           ),
  //         );
  //       });
  // }

  Widget buildTimeCard(
      {void Function()? onTap, TimeOfDay? timeOfDay, String? label}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 60.h,
        width: 30.w,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8.r),
            color: primaryBlue.shade50),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SvgPicture.asset(
                getImage(
                  folderName: 'icons',
                  fileName: 'clock-five.svg',
                ),
                color: primaryBlue,
                width: 20,
              ),
              SizedBox(width: 8.w),
              textLabel(
                text: timeOfDay == null ? label! : timeOfDay.format(context),
                color: primaryBlue,
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget textFeld({
    required String hintText,
    required IconData icon,
    required TextInputType inputType,
    required int maxLines,
    required TextEditingController controller,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: TextFormField(
        cursorColor: primaryBlue,
        controller: controller,
        keyboardType: inputType,
        maxLines: maxLines,
        decoration: InputDecoration(
          // prefixIcon: Container(
          //   margin: const EdgeInsets.all(8.0),
          //   decoration: BoxDecoration(
          //     borderRadius: BorderRadius.circular(8),
          //     color: Green,
          //   ),
          //   child: Icon(
          //     icon,
          //     size: 20,
          //     color: Colors.white,
          //   ),
          // ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(
              color: Colors.transparent,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(
              color: Colors.transparent,
            ),
          ),
          hintText: hintText,
          alignLabelWithHint: true,
          border: InputBorder.none,
          fillColor: primaryBlue.shade50,
          filled: true,
          hintStyle: GoogleFonts.poppins(
            color: primaryBlue.shade600,
            fontSize: 14.sp,
          ),
        ),
      ),
    );
  }

  // Future<TimeOfDay> _showTimePicker(BuildContext context) async {
  //   TimeOfDay initialTime = const TimeOfDay(hour: 9, minute: 0);

  //   final TimeOfDay? selectedTime = await showTimePicker(
  //     context: context,
  //     initialTime: initialTime,
  //   );

  //   return selectedTime!;
  // }

  // store user data to database
  void storeData() async {
    final ap = Provider.of<AuthProvider>(context, listen: false);

    ap.getToken().then((value) {
      // AppointmentProvider.getToken();

      ExpertModel doctorModel = ExpertModel(
        name: nameController.text.trim(),
        profilePic: "",
        createdAt: "",
        phoneNumber: "",
        uid: "",
        speciality: speciality,
        experience: experienceController.text.trim(),
        isApproved: false,
        deviceToken: value,
        pricePerDay: double.parse(pricePerDay.text.trim().replaceAll(' ', '')),
      );
      if (image != null &&
          nameController.text.isNotEmpty &&
          pricePerDay.text.isNotEmpty &&
          experienceController.text.isNotEmpty) {
        ap.saveExpertDataToFirebase(
          context: context,
          doctorModel: doctorModel,
          profilePic: image!,
          onSuccess: () {
            ap.saveExpertDataToSP().then(
                  (value) => ap.setSignIn().then((value) {
                    ScreenStateManager.setPageOrderID(3);
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const AllScreens(),
                      ),
                      (route) => false,
                    );
                  }),
                );
          },
        );
      } else {
        showSnackBar(
          bgColor: Colors.redAccent,
          content: "Please fill all fields correctly and try again.",
          context: context,
          textColor: Colors.white,
        );
      }
    });
  }
}

// // ignore: must_be_immutable
// class AvailableHours extends StatelessWidget {
//   AvailableHours({
//     super.key,
//   });

//   bool isActive = false;

//   List<int> dateTimeBox = [];

//   @override
//   Widget build(BuildContext context) {
//     final scroller = Provider.of<DateBoxProvider>(context, listen: false);

//     return StatefulBuilder(
//       builder: (context, setState) =>
//     );
//   }
// }
