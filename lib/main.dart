import 'package:fcm_sample/push_notification.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

///reference: https://www.youtube.com/watch?v=u-7ut-phOrA
///
///backend test [Postman]

///top-level function that is called when the app is in the background or terminated
@pragma('vm:entry-point')
Future _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  print('Handling a background message ${message.messageId}');
}

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late int _totalNotifications;
  late final FirebaseMessaging _messaging;
  PushNotification? _notificationInfo;
  @override
  void initState() {
    requestAndRegisterNotification();

    ///onMessage is called when the app is in the foreground and when the app is in the background
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print('A new onMessageOpenedApp event was published!');
      setState(() {
        _notificationInfo = PushNotification(
          message.notification?.title,
          message.notification?.body,
        );
        _totalNotifications++;
      });
    });

    _totalNotifications = 0;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text(
          'You have pushed the button this many times:',
        ),
        Text(
          '$_totalNotifications',
          style: Theme.of(context).textTheme.headlineMedium,
        ),
        if (_notificationInfo != null)
          Text(
            'Last notification title: ${_notificationInfo!.title}',
          ),
        if (_notificationInfo != null)
          Text(
            'Last notification body: ${_notificationInfo!.body}',
          ),
      ],
    ));
  }

  void requestAndRegisterNotification() async {
    await Firebase.initializeApp();

    _messaging = FirebaseMessaging.instance;
    FirebaseMessaging.onBackgroundMessage(
        (message) => _firebaseMessagingBackgroundHandler(message));

    NotificationSettings settings = await _messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      print('User granted permission');
      String? token = await _messaging.getToken();
      print('User granted permission and token is: $token');

      FirebaseMessaging.onMessage.listen((RemoteMessage message) {
        print('Got a message whilst in the foreground!');
        print('Message data: ${message.data}');

        if (message.notification != null) {
          print(
              'Message also contained a notification: ${message.notification}');
        }

        setState(() {
          _notificationInfo = PushNotification(
            message.notification?.title,
            message.notification?.body,
          );
          _totalNotifications++;
        });
      });
    } else if (settings.authorizationStatus ==
        AuthorizationStatus.provisional) {
      print('User granted provisional permission');

      String? token = await _messaging.getToken();
      print('User granted provisional permission and token is: $token');

      FirebaseMessaging.onMessage.listen((RemoteMessage message) {
        print('Got a message whilst in the foreground!');
        print('Message data: ${message.data}');

        if (message.notification != null) {
          print(
              'Message also contained a notification: ${message.notification}');
        }

        setState(() {
          _notificationInfo = PushNotification(
            message.notification?.title,
            message.notification?.body,
          );
          _totalNotifications++;
        });
      });
    } else {
      print('User declined or has not accepted permission');
    }
  }
}
