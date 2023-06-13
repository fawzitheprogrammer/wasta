import 'dart:convert';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:wasta/components/colors.dart';
import 'package:wasta/shared_preferences/shared_pref_barrel.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../components/snack_bar.dart';
import '../models/user_model.dart';
import '../screens/otp_verification_screen.dart';
import 'package:wasta/models/experts_model.dart';

class AuthProvider extends ChangeNotifier {
  //int _isSignedIn = 0;
  //int get isSignedIn => _isSignedIn;
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  bool? isApproved = false;
  String? _uid;
  String get uid => _uid!;
  // The model to get set in user data
  UserModel? _userModel;
  UserModel get userModel => _userModel!;
  // The model  to get set in doctors data
  ExpertModel? _expertModel;
  ExpertModel get expertModel => _expertModel!;
  Color errorBorder = backgroundGrey1;

  //
  String _userID = '';
  String get userID => _userID;

  //
  String _deviceToken = '';
  String get deviceToken => _deviceToken;

  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  FirebaseAuth get firebaseAuth => _firebaseAuth;
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;
  final FirebaseStorage _firebaseStorage = FirebaseStorage.instance;

  Future setSignIn() async {
    // ScreenStateManager.setPageOrderID(1);
    notifyListeners();
  }

  // signin
  void signInWithPhone(BuildContext context, String phoneNumber) async {
    try {
      await _firebaseAuth.verifyPhoneNumber(
          phoneNumber: phoneNumber,
          verificationCompleted:
              (PhoneAuthCredential phoneAuthCredential) async {
            await _firebaseAuth.signInWithCredential(phoneAuthCredential);
          },
          verificationFailed: (error) {
            throw Exception(error.message);
          },
          codeSent: (verificationId, forceResendingToken) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) =>
                    OTPVerification(verificationId: verificationId),
              ),
            );
          },
          codeAutoRetrievalTimeout: (verificationId) {});
    } on FirebaseAuthException catch (e) {
      showSnackBar(
        bgColor: Colors.redAccent,
        content: e.message.toString(),
        context: context,
        textColor: Colors.white,
      );
    }
  }

  // verify otp
  void verifyOtp({
    required BuildContext context,
    required String verificationId,
    required String userOtp,
    required Function onSuccess,
  }) async {
    _isLoading = true;
    notifyListeners();

    try {
      PhoneAuthCredential creds = PhoneAuthProvider.credential(
        verificationId: verificationId,
        smsCode: userOtp,
      );

      User? user = (await _firebaseAuth.signInWithCredential(creds)).user;

      if (user != null) {
        // carry our logic
        _uid = user.uid;
        errorBorder = primaryBlue;
        onSuccess();
      }
      _isLoading = false;
      notifyListeners();
    } on FirebaseAuthException {
      errorBorder = Colors.redAccent;
      //showSnackBar(context, e.message.toString());
      _isLoading = false;
      notifyListeners();
    }
  }

  // Future<bool> isExpertApproved() async {
  //   DocumentSnapshot snapshot = await _firebaseFirestore
  //       .collection("doctors")
  //       .doc(AppointmentProvider.currentUser!.uid)
  //       .get();

  //   if (snapshot.get('isApproved')) {
  //     return true;
  //   } else {
  //     return false;
  //   }
  // }

  // DATABASE OPERTAIONS
  Future<bool> checkExistingPhone(String phoneNumber) async {
    bool isFound = false;

    //print(Role.getRole());

    QuerySnapshot querySnapshot;

    if (Role.getRole() == false) {
      querySnapshot = await _firebaseFirestore.collection("users").get();
    } else {
      querySnapshot = await _firebaseFirestore.collection("experts").get();
    }

    for (var i in querySnapshot.docs) {
      print(i.reference.parent.id);
      if (phoneNumber == i.get('phoneNumber')) {
        debugPrint(i.get('phoneNumber'));

        isFound = true;
      }
    }

    return isFound;
  }

  // DATABASE OPERTAIONS
  Future<bool> checkExistingUser() async {
    DocumentSnapshot snapshot = await _firebaseFirestore
        .collection(Role.getRole() ? "users" : "experts")
        .doc(_uid)
        .get();
    _userID = snapshot.id;

    if (snapshot.exists) {
      //print("USER EXISTS");

      return true;
    } else {
      //print("NEW USER");
      return false;
    }
  }

  // getting deviceToken
  Future<String> getToken() async {
    await FirebaseMessaging.instance.getToken().then((token) {
      _deviceToken = token!;
      notifyListeners();
    });

    return deviceToken;
  }

  // Storing user data to firebase
  void saveUserDataToFirebase({
    required BuildContext context,
    required UserModel userModel,
    required File profilePic,
    required Function onSuccess,
  }) async {
    _isLoading = true;
    notifyListeners();
    try {
      // uploading image to firebase storage.
      await storeFileToStorage("profilePic/$_uid", profilePic).then((value) {
        userModel.profilePic = value;
        userModel.createdAt = DateTime.now().millisecondsSinceEpoch.toString();
        userModel.phoneNumber = _firebaseAuth.currentUser!.phoneNumber!;
        userModel.uid = _firebaseAuth.currentUser!.phoneNumber!;
      });

      _userModel = userModel;

      // uploading to database
      await _firebaseFirestore
          .collection("users")
          .doc(_uid)
          .set(userModel.toMap())
          .then((value) {
        onSuccess();
        _isLoading = false;
        notifyListeners();
      });
    } on FirebaseAuthException catch (e) {
      showSnackBar(
        bgColor: Colors.redAccent,
        content: e.message.toString(),
        context: context,
        textColor: Colors.white,
      );
      _isLoading = false;
      notifyListeners();
    }
  }

  // Storing Doctors data to firebase
  void saveExpertDataToFirebase({
    required BuildContext context,
    required ExpertModel doctorModel,
    required File profilePic,
    required Function onSuccess,
  }) async {
    _isLoading = true;
    notifyListeners();
    try {
      // uploading image to firebase storage.
      await storeFileToStorage("profilePic/$_uid", profilePic).then((value) {
        doctorModel.profilePic = value;
        doctorModel.createdAt =
            DateTime.now().millisecondsSinceEpoch.toString();
        doctorModel.phoneNumber = _firebaseAuth.currentUser!.phoneNumber!;
        doctorModel.uid = _firebaseAuth.currentUser!.phoneNumber!;
      });

      _expertModel = doctorModel;

      // uploading to database
      await _firebaseFirestore
          .collection("experts")
          .doc(_uid)
          .set(doctorModel.toMap())
          .then((value) {
        onSuccess();
        _isLoading = false;
        notifyListeners();
      });
    } on FirebaseAuthException catch (e) {
      showSnackBar(
        bgColor: Colors.redAccent,
        content: e.message.toString(),
        context: context,
        textColor: Colors.white,
      );
      _isLoading = false;
      notifyListeners();
    }
  }

  // Saving profile pictures to the firebase storage
  Future<String> storeFileToStorage(String ref, File file) async {
    UploadTask uploadTask = _firebaseStorage.ref().child(ref).putFile(file);
    TaskSnapshot snapshot = await uploadTask;
    String downloadUrl = await snapshot.ref.getDownloadURL();
    return downloadUrl;
  }

  // Get Doctor info from firebase
  Future getExpertDataFromFirestore() async {
    await _firebaseFirestore
        .collection("experts")
        .doc(_firebaseAuth.currentUser!.uid)
        .get()
        .then((DocumentSnapshot snapshot) {
      _expertModel = ExpertModel(
        name: snapshot['name'] ?? '',
        uid: snapshot['uid'] ?? '',
        phoneNumber: snapshot['phoneNumber'] ?? '',
        createdAt: snapshot['createdAt'] ?? '',
        profilePic: snapshot['profilePic'] ?? '',
        speciality: snapshot['speciality'] ?? '',
        experience: snapshot['experience'] ?? '',
        isApproved: snapshot['isApproved'] ?? '',
        deviceToken: snapshot['deviceToken'] ?? '',
        pricePerDay: snapshot['pricePerDay'] ?? '',
      );
      _uid = expertModel.uid;
    });
  }

// Get user info from firebase
  Future getUserDataFromFirestore() async {
    await _firebaseFirestore
        .collection("users")
        .doc(_firebaseAuth.currentUser!.uid)
        .get()
        .then((DocumentSnapshot snapshot) {
      _userModel = UserModel(
        name: snapshot['name'],
        createdAt: snapshot['createdAt'],
        uid: snapshot['uid'],
        profilePic: snapshot['profilePic'],
        phoneNumber: snapshot['phoneNumber'],
        age: snapshot['age'],
        gender: snapshot['gender'],
      );
      _uid = userModel.uid;
    });
  }

  // STORING DATA LOCALLY
  Future saveUserDataToSP() async {
    SharedPreferences s = await SharedPreferences.getInstance();
    await s.setString("user_model", jsonEncode(userModel.toMap()));
  }

  Future getDataFromSP() async {
    SharedPreferences s = await SharedPreferences.getInstance();
    String data = s.getString("user_model") ?? '';
    _userModel = UserModel.fromMap(jsonDecode(data));
    _uid = _userModel!.uid;
    notifyListeners();
  }

  // STORING DOCTOR DATA LOCALLY
  Future saveExpertDataToSP() async {
    SharedPreferences s = await SharedPreferences.getInstance();
    await s.setString("expert_model", jsonEncode(expertModel.toMap()));
  }

  Future getDoctorDataFromSP() async {
    SharedPreferences s = await SharedPreferences.getInstance();
    String data = s.getString("expert_model") ?? '';
    _expertModel = ExpertModel.fromMap(jsonDecode(data));
    _uid = _expertModel!.uid;
    notifyListeners();
  }

  Future userSignOut() async {
    SharedPreferences s = await SharedPreferences.getInstance();

    await _firebaseAuth.signOut();
    ScreenStateManager.setPageOrderID(1);
    // BottomNavBar().index = 0;
    notifyListeners();
    s.clear();
  }
}
