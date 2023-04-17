import 'package:wasta/components/components_barrel.dart';
import 'package:wasta/public_packages.dart';

Widget secondaryButton({required String label, Function()? onPressed}) {
  return TextButton(
    onPressed: onPressed,
    child: Text(
      label,
      style: GoogleFonts.poppins(
        fontSize: 14.sp,
        color: midGrey2,
        //fontWeight: FontWeight.w500,
      ),
    ),
  );
}
