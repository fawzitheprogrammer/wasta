import 'package:wasta/components/components_barrel.dart';
import 'package:wasta/main.dart';
import 'package:wasta/navigation/navigator.dart';
import 'package:wasta/public_packages.dart';
import 'package:rive/rive.dart';

import '../../providers/appointment_provider.dart';
import '../../providers/bottom_narbar_provider.dart';



class AppointmentBooked extends StatefulWidget {
  const AppointmentBooked({super.key});

  @override
  State<AppointmentBooked> createState() => _AppointmentBookedState();
}

class _AppointmentBookedState extends State<AppointmentBooked> {
  @override
  Widget build(BuildContext context) {
    // final appointmentProvider =
    //     Provider.of<AppointmentProvider>(context, listen: false);

    final provider = Provider.of<BottomNavBar>(context, listen: false);

    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Spacer(),
            SizedBox(
              height: 160.h,
              width: 160.w,
              child: const RiveAnimation.asset('assets/rive/done.riv'),
            ),
            textLabel(
              text: AppointmentProvider.isSave
                  ? 'Appointment Booked !'
                  : 'Appointment Updated !',
              fontSize: 18.sp,
              fontWeight: FontWeight.w500,
            ),
            SizedBox(
              height: 4.h,
            ),
            textLabel(
                text: 'All your appointments appear in the appointmentscreen.',
                fontSize: 13.sp,
                color: Theme.of(context).colorScheme.onPrimary.withAlpha(120),
                textAlign: TextAlign.center),
            const Spacer(),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 24.0.h),
              child: primaryButton(
                onPressed: () {
                  provider.bottomNavIndex(0);
                  getPageRemoveUntil(
                    context,
                    const AllScreens(),
                  );
                },
                label: 'Done',
                backgroundColor: primaryBlue,
                size: Size(
                  double.infinity,
                  60.h,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
