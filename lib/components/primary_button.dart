import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:wasta/components/colors.dart';

Widget primaryButton(
    {required String label,
    required Color backgroundColor,
    required Size size,
    Function()? onPressed,
    double? shadow,
    Color? shadowColor,
    double? borderWidth,
    Color? borderColor,
    Color? textColor,
    bool isLoading = false}) {
  return Ink(
    decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10.r),
        gradient: LinearGradient(
          begin: Alignment.bottomLeft,
          end: Alignment.centerRight,
          stops: const [0.5, 0.9],
          colors: gradient,
        )),
    child: TextButton(
      style: ButtonStyle(
        overlayColor: MaterialStatePropertyAll(secondaryColor),
        //backgroundColor: MaterialStateProperty.all(backgroundColor),

        minimumSize: MaterialStatePropertyAll(
          size,
        ),
        shape: MaterialStatePropertyAll(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.r),
          ),
        ),
        elevation: MaterialStatePropertyAll(shadow),
        shadowColor: MaterialStatePropertyAll(
          shadowColor,
        ),
        side: MaterialStatePropertyAll(
          BorderSide(
              color: borderColor ?? Colors.transparent,
              width: borderWidth ?? 0),
        ),
      ),
      onPressed: onPressed,
      child: isLoading
          ? const CircularProgressIndicator(
              color: Colors.white,
            )
          : Text(
              label,
              style: GoogleFonts.poppins(
                  fontSize: 15.sp, color: textColor ?? Colors.white),
            ),
    ),
  );
}
