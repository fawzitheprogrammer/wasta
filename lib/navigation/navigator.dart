import 'package:flutter/material.dart';

getPage(BuildContext context, Widget page) {
  return Navigator.push(
    context,
    MaterialPageRoute(builder: (context) => page),
  );
}

getPageRemoveUntil(BuildContext context, Widget page) {
  return Navigator.pushAndRemoveUntil(
    context,
    MaterialPageRoute(builder: (context) => page),
    (route) => false,
  );
}
