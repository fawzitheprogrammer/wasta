import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import '../firebase_options.dart';

FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

var channel;

void requestPermission() async {
  //settings.authorizationStatus == AuthorizationStatus.authorized
 // Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  FirebaseMessaging messaging = FirebaseMessaging.instance;
  NotificationSettings settings = await messaging.requestPermission(
    alert: true,
    announcement: false,
    badge: true,
    carPlay: false,
    criticalAlert: false,
    provisional: false,
    sound: true,
  );

  if (settings.authorizationStatus == AuthorizationStatus.authorized) {
    //print('User granted permission');
  } else if (settings.authorizationStatus == AuthorizationStatus.provisional) {
    //print('User granted provisional permission');
  } else {
    //print('User declined or has not accepted permission');
  }
}

void loadFCM() async {
  //Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  channel = const AndroidNotificationChannel(
    'high_importance_channel', // id
    'High Importance Notifications', // title
    'wasta_app',
    importance: Importance.high,
    enableVibration: true,
  );

  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  /// Create an Android Notification Channel.
  ///
  /// We use this channel in the `AndroidManifest.xml` file to override the
  /// default FCM channel to enable heads up notifications.
  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(channel);

  /// Update the iOS foreground notification presentation options to allow
  /// heads up notifications.
  ///Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
    alert: true,
    badge: true,
    sound: true,
  );
}

void listenFCM() async {
  //Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    RemoteNotification? notification = message.notification;
    AndroidNotification? android = message.notification?.android;
    if (notification != null && android != null) {
      flutterLocalNotificationsPlugin.show(
        notification.hashCode,
        notification.title,
        notification.body,
        NotificationDetails(
          android: AndroidNotificationDetails(
            channel.id,
            channel.name,
            channel.description,
            // TODO add a proper drawable resource to android, for now using
            //      one that already exists in example app.
            icon: 'launch_background',
          ),
        ),
      );
    }
  });
}



















// Future<void> initNotifications() async {
//   final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
//       FlutterLocalNotificationsPlugin();

//   const AndroidInitializationSettings initializationSettingsAndroid =
//       AndroidInitializationSettings('launch_background');
//   final InitializationSettings initializationSettings =
//       InitializationSettings(android: initializationSettingsAndroid);

//   await flutterLocalNotificationsPlugin.initialize(initializationSettings);
// }

// Future showBigTextNotification(
//     {var id = 0,
//     required String title,
//     required String body,
//     var payload,
//     required FlutterLocalNotificationsPlugin fln}) async {
//   AndroidNotificationDetails androidPlatformChannelSpecifics =
//       const AndroidNotificationDetails(
//     'your_channel_id',
//     'your_channel_name',
//     'your_channel_description',
//     playSound: true,
//     //sound: RawResourceAndroidNotificationSound().sound,
//     importance: Importance.max,
//     priority: Priority.high,
//   );

//   var not = NotificationDetails(
//       android: androidPlatformChannelSpecifics, iOS: IOSNotificationDetails());
//   await fln.show(0, title, body, not);
// }
