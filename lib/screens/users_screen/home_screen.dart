import 'package:wasta/components/components_barrel.dart';
import 'package:wasta/components/contants.dart';
import 'package:wasta/components/firebase_vars.dart';
import 'package:wasta/navigation/navigator.dart';
import 'package:wasta/providers/appointment_provider.dart';
import 'package:wasta/screens/users_screen/list_of_users.dart';
import 'package:wasta/screens/users_screen/search_results.dart';

import '../../public_packages.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final controller = TextEditingController();

  // @override
  // void dispose() {
  //   // TODO: implement dispose
  //   super.dispose();
  //   controller.dispose();
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(8.0.w),
          child: Column(
            children: [
              // User name
              Padding(
                padding: EdgeInsets.all(16.0.w),
                child: Row(
                  children: [
                    StreamBuilder(
                      stream: firebaseFirestore
                          .collection('users')
                          .doc(AppointmentProvider.currentUser!.uid)
                          .snapshots(),
                      builder: (context, snapshots) {
                        if (snapshots.connectionState ==
                            ConnectionState.waiting) {
                          return Container();
                        }

                        final user = snapshots.data;

                        return Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Welcome! 🖐',
                              style: GoogleFonts.poppins(
                                fontSize: 18.sp,
                                color: Theme.of(context).colorScheme.onPrimary,
                                //fontWeight: FontWeight.w500,
                              ),
                            ),
                            Text(
                              user!['name'],
                              style: GoogleFonts.poppins(
                                  fontSize: 28.sp,
                                  color: primaryBlue,
                                  fontWeight: FontWeight.w600
                                  //fontWeight: FontWeight.w500,
                                  ),
                            )
                          ],
                        );
                      },
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                child: TextField(
                  autofocus: false,
                  controller: controller,
                  decoration: InputDecoration(
                    prefixIcon: Icon(
                      Icons.search,
                      color: Theme.of(context).colorScheme.onPrimary,
                    ),
                    filled: true,
                    fillColor: Theme.of(context).colorScheme.primaryContainer,
                    border: OutlineInputBorder(
                      borderSide:
                          const BorderSide(width: 0.0, style: BorderStyle.none),
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        width: 1.0,
                        style: BorderStyle.solid,
                        color: primaryBlue,
                      ),
                      borderRadius: BorderRadius.circular(6.r),
                    ),
                    hintText: 'Search here...',
                    hintStyle: GoogleFonts.poppins(
                      fontSize: 14.sp,
                      color: Theme.of(context).colorScheme.onPrimary,
                      //fontWeight: FontWeight.w500,
                    ),
                    suffixIcon: IconButton(
                      onPressed: () {
                        // controller.text = '';
                        // categoryActiveIndex = -1;
                        // setState(() {});
                      },
                      icon: Icon(
                        Icons.clear,
                        color: Theme.of(context).colorScheme.onPrimary,
                      ),
                    ),
                  ),
                  cursorColor: Theme.of(context).colorScheme.onPrimary,
                  onSubmitted: (String value) {
                    getPage(
                      context,
                      SearchAllUsers(
                        selectedSpeciality: value,
                      ),
                    );
                  },
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: GridView.builder(
                    itemCount: categories.length,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 4,
                      childAspectRatio: 0.8.w,
                    ),
                    itemBuilder: (context, index) => GestureDetector(
                      onTap: () => getPage(
                        context,
                        AllUsers(
                          selectedSpeciality: categoriesLabel[index],
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(2.0),
                        child: Container(
                          // height: 60.h,
                          // width: 100.w,
                          decoration: BoxDecoration(
                              color: themeColor(context).primaryContainer,
                              borderRadius: BorderRadius.circular(2.r)),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image.asset(
                                categories[index],
                                width: 50.w,
                              ),
                              SizedBox(height: 12.h),
                              textLabel(
                                  text: categoriesLabel[index], color: midGrey2)
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
