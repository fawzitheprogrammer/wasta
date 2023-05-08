import 'dart:io';

import 'package:wasta/components/components_barrel.dart';
import 'package:wasta/main.dart';
import 'package:wasta/models/user_model.dart';
import 'package:wasta/public_packages.dart';
import '../../providers/auth_provider.dart';

class UserInfromationScreen extends StatefulWidget {
  const UserInfromationScreen({super.key});

  @override
  State<UserInfromationScreen> createState() => _UserInfromationScreenState();
}

class _UserInfromationScreenState extends State<UserInfromationScreen> {
  File? image;
  final nameController = TextEditingController();
  final ageController = TextEditingController();
  //final bioController = TextEditingController();

  bool isActive = true;
  String gender = '';

  @override
  void dispose() {
    super.dispose();
    nameController.dispose();
    ageController.dispose();
    //bioController.dispose();
  }

  // for selecting image
  void selectImage() async {
    image = await pickImage(context);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final isLoading =
        Provider.of<AuthProvider>(context, listen: true).isLoading;
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
                              vertical: 5, horizontal: 15),
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
                                hintText: "Your age",
                                icon: Icons.account_circle,
                                inputType: TextInputType.number,
                                maxLines: 1,
                                controller: ageController,
                              ),
                              Row(
                                children: [
                                  Expanded(
                                    child: genderChip(
                                      cardActive: isActive,
                                      text: 'Male',
                                      iconData: Icons.male,
                                      onTap: () {
                                        isActive = true;
                                        gender = 'Male';
                                        setState(() {});
                                      },
                                    ),
                                  ),
                                  SizedBox(
                                    width: 8.w,
                                  ),
                                  Expanded(
                                    child: genderChip(
                                        cardActive: !isActive,
                                        text: 'Female',
                                        iconData: Icons.female,
                                        onTap: () {
                                          isActive = false;
                                          gender = 'Female';
                                          setState(() {});
                                        }),
                                  )
                                ],
                              )

                              // // email
                              // textFeld(
                              //   hintText: "abc@example.com",
                              //   icon: Icons.email,
                              //   inputType: TextInputType.emailAddress,
                              //   maxLines: 1,
                              //   controller: emailController,
                              // ),

                              // // bio
                              // textFeld(
                              //   hintText: "Enter your bio here...",
                              //   icon: Icons.edit,
                              //   inputType: TextInputType.name,
                              //   maxLines: 2,
                              //   controller: bioController,
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
                            backgroundColor: primaryBlue,
                            size: Size(
                                MediaQuery.of(context).size.width * 0.90, 70.h),
                            onPressed: () => storeData(),
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

  Widget genderChip(
      {required String text,
      required IconData iconData,
      void Function()? onTap,
      required bool cardActive}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 60.h,
        // width: 30.w,

        decoration: BoxDecoration(
          color: cardActive ? primaryBlue : primaryBlue.withAlpha(80),
          borderRadius: BorderRadius.circular(
            8.r,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              iconData,
              color: backgroundGrey1,
            ),
            textLabel(
              text: text,
              color: backgroundGrey2,
            ),
          ],
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
          hintStyle: GoogleFonts.poppins(),
        ),
      ),
    );
  }

  // store user data to database
  void storeData() async {
    final ap = Provider.of<AuthProvider>(context, listen: false);

    UserModel userModel = UserModel(
      name: nameController.text.trim(),
      profilePic: "",
      createdAt: "",
      phoneNumber: "",
      uid: "",
      age: int.parse(ageController.text.trim()),
      gender: gender,
    );

    if (image != null && nameController.text.isNotEmpty) {
      ap.saveUserDataToFirebase(
        context: context,
        userModel: userModel,
        profilePic: image!,
        onSuccess: () {
          ap.saveUserDataToSP().then(
                (value) => ap.setSignIn().then(
                      (value) => Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const AllScreens(),
                        ),
                        (route) => false,
                      ),
                    ),
              );
        },
      );
    } else {
      showSnackBar(
        bgColor: Colors.redAccent,
        content: 'Please upload your profile photo.',
        context: context,
        textColor: Colors.white,
        // isFalse: true
      );
    }
  }
}
