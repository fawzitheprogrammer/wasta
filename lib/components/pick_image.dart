import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:wasta/components/snack_bar.dart';
// import 'package:wasta/public_packages.dart';

Future<File?> pickImage(BuildContext context) async {
  File? image;
  try {
    final pickedImage =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedImage != null) {
      image = File(pickedImage.path);
    }
  } catch (e) {
    showSnackBar(
      bgColor: Colors.redAccent,
      content: e.toString(),
      context: context,
      textColor: Colors.white,
    );
  }

  return image;
}
