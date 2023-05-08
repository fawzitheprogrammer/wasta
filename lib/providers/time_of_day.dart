import 'package:wasta/public_packages.dart';

class Time extends ChangeNotifier {




  TimeOfDay? _appointmentHour =
      TimeOfDay(hour: DateTime.now().hour, minute: DateTime.now().minute);
  TimeOfDay get appointmentHour => _appointmentHour!;

  timePicker(BuildContext context) async {
    TimeOfDay initialTime =  TimeOfDay(hour: DateTime.now().hour, minute: DateTime.now().minute);

    _appointmentHour = await showTimePicker(
      context: context,
      initialTime: initialTime,
      useRootNavigator: true
    )??initialTime;

    notifyListeners();
  }


  var time = TimeOfDay.now();


}
