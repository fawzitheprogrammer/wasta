import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:wasta/components/components_barrel.dart';
import 'package:wasta/components/contants.dart';
import 'package:wasta/navigation/navigator.dart';
import 'package:wasta/public_packages.dart';
import 'package:wasta/screens/users_screen/user_screen.dart';

import '../../components/progress_indicator.dart';

class SearchAllUsers extends StatefulWidget {
  const SearchAllUsers({super.key, required this.selectedSpeciality});

  final String selectedSpeciality;

  @override
  State<SearchAllUsers> createState() => _SearchAllUsersState();
}

class _SearchAllUsersState extends State<SearchAllUsers> {
  //final String selectedSpeciality;
  @override
  Widget build(BuildContext context) {
    //print(selectedSpeciality);
    final FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
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
          stream: firebaseFirestore.collection("experts").where('isApproved',isEqualTo: true).snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return loading();
            } else {
              final initialData = snapshot.data!.docs;

              List<Widget> listOfWidgets = [];
              List<String> documentID = [];
              List<String> profilePic = [];

              for (var expertData in initialData) {
                bool getFields(String field) {
                  return expertData[field]
                      .toString()
                      .toLowerCase()
                      .contains(widget.selectedSpeciality.toLowerCase());
                }

                if (widget.selectedSpeciality.isEmpty) {
                  final expertCardItem = GestureDetector(
                    onTap: () => getPage(
                      context,
                      UserScreen(expertID: expertData.id),
                    ),
                    child: expertsCard(expertData),
                  );
                  listOfWidgets.add(expertCardItem);
                  documentID.add(expertData.id);
                  profilePic.add(expertData['profilePic']);
                } else if (getFields('name') || getFields('speciality')) {
                  final expertCardItem = GestureDetector(
                      onTap: () =>
                          getPage(context, UserScreen(expertID: expertData.id)),
                      child: expertsCard(expertData));
                  listOfWidgets.add(expertCardItem);
                  documentID.add(expertData.id);
                  profilePic.add(expertData['profilePic']);
                }
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

  Widget expertsCard(dynamic expertData) {
    return Padding(
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
                backgroundImage: NetworkImage(expertData['profilePic']),
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
    );
  }
}
