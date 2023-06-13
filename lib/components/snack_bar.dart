import 'package:wasta/components/components_barrel.dart';
import 'package:wasta/public_packages.dart';

void showSnackBar(
    {required BuildContext context,
    required String? content,
    required Color? bgColor,
    required Color? textColor,
    void Function()? onPressed,
    bool isFalse = false}) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      duration: const Duration(seconds: 7),
      // action: SnackBarAction(
      //   textColor: backgroundGrey1,
      //   onPressed: onPressed ?? () {},
      //   label: 'Try again',
      // ),
      content: Row(
        children: [
          !isFalse
              ? Container()
              : const Icon(
                  Icons.info,
                  color: Colors.white,
                ),
          SizedBox(
            width: 8.w,
          ),
          Flexible(
            child: textLabel(
                text: content ?? '',
                fontSize: 12,
                fontWeight: FontWeight.normal,
                color: textColor ?? midGrey1),
          )
        ],
      ),
      backgroundColor: bgColor ?? midGrey2,
    ),
  );
}
