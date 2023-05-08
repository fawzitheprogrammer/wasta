import 'package:intl/intl.dart';

String timeFormat(value) {
  return DateFormat('h:mm a')
      .format(
        DateTime.tryParse(
          DateTime(
            DateTime.now().year,
            DateTime.now().month,
            DateTime.now().day,
            value,
          ).toString(),
        )!,
      )
      .toString();
}
