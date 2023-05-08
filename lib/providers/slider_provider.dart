import 'package:wasta/public_packages.dart';

class SliderProvider extends ChangeNotifier {
  double? _workTime = 1;

  double get workTime => _workTime!;

  set value(double newValue) {
    _workTime = newValue;
    notifyListeners();
  }
}
