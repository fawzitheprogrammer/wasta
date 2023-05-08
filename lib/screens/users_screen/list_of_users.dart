import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:wasta/components/components_barrel.dart';
import 'package:wasta/components/contants.dart';
import 'package:wasta/navigation/navigator.dart';
import 'package:wasta/public_packages.dart';
import 'package:wasta/screens/users_screen/user_screen.dart';

import '../../components/firebase_vars.dart';
import '../../components/progress_indicator.dart';

class AllUsers extends StatelessWidget {
  const AllUsers({super.key, required this.selectedSpeciality});

  final String selectedSpeciality;

  //final String selectedSpeciality;
  @override
  Widget build(BuildContext context) {
    //print(selectedSpeciality);
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
              .collection("experts")
              .where('speciality', isEqualTo: selectedSpeciality)
              .where('isApproved', isEqualTo: true)
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return loading();
            } else {
              final initialData = snapshot.data;

              List<Widget> listOfWidgets = [];

              for (var expertData in initialData!.docs) {
                final expertWidget = GestureDetector(
                  onTap: () => getPage(
                    context,
                    UserScreen(
                      expertID: expertData.id,
                    ),
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(8.0.w),
                    child: Container(
                      height: 100.h,
                      padding: EdgeInsets.symmetric(horizontal: 18.0.w),
                      width: double.infinity,
                      color: Theme.of(context).colorScheme.primaryContainer,
                      child: Row(
                        children: [
                          Hero(
                            // transitionOnUserGestures: true,
                            tag: expertData['profilePic'],
                            child: CircleAvatar(
                              radius: 32.r,
                              backgroundImage:
                                  NetworkImage(expertData['profilePic']),
                            ),
                          ),
                          SizedBox(
                            width: 8.w,
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              textLabel(
                                text: expertData['name'],
                                fontSize: 18.sp,
                                color: themeColor(context).onPrimary,
                              ),
                              textLabel(
                                text: expertData['speciality'],
                                fontSize: 14.sp,
                                fontWeight: FontWeight.w400,
                                color: themeColor(context).onPrimary,
                              ),
                            ],
                          ),
                          const Spacer(),
                          Icon(
                            Icons.arrow_forward_ios_rounded,
                            color: themeColor(context).background,
                          )
                        ],
                      ),
                    ),
                  ),
                );

                listOfWidgets.add(expertWidget);
              }

              return listOfWidgets.isNotEmpty
                  ? ListView(
                      children: listOfWidgets,
                    )
                  : const Center(
                      child: Text('No resutls'),
                    );
            }
          },
        ));
  }
}
