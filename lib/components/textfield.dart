import 'package:wasta/components/components_barrel.dart';

import '../public_packages.dart';

Widget textField({
  TextEditingController? controller,
  Function()? onTap,
  Function(String)? onSubmitted,
  required bool isActive,
  String? hintText,
  required BuildContext context,
  Widget? suffixIcon,
  TextInputType? keyboardType,
  FocusNode? focusNode,
}) {
  return TextField(
    focusNode: focusNode,
    //toolbarOptions:
    //ToolbarOptions(copy: true, paste: true, cut: true, selectAll: true),
    controller: controller,
    onTap: onTap,
    onSubmitted: onSubmitted,
    autofocus: false,
    style: GoogleFonts.poppins(
      fontSize: 14.sp,
      color: darkGrey2,
      //fontWeight: FontWeight.w500,
    ),
    decoration: InputDecoration(
      filled: true,
      fillColor: isActive
          ? backgroundGrey2
          : Theme.of(context).colorScheme.primaryContainer,
      border: OutlineInputBorder(
        borderSide: const BorderSide(width: 0.0, style: BorderStyle.none),
        borderRadius: BorderRadius.circular(6.r),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(
          width: 1.0,
          style: BorderStyle.solid,
          color: primaryBlue,
        ),
        borderRadius: BorderRadius.circular(6.r),
      ),
      hintText: hintText,
      hintStyle: GoogleFonts.poppins(
        fontSize: 14.sp,
        color: Theme.of(context).colorScheme.onPrimary,
        //fontWeight: FontWeight.w500,
      ),
      suffixIcon: suffixIcon,
    ),
    //selectionHeightStyle: BoxHeightStyle.,
    keyboardType: keyboardType ?? TextInputType.streetAddress,
    cursorColor: Theme.of(context).colorScheme.onPrimary,
  );
}
