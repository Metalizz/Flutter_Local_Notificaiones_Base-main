import 'dart:async';
import 'dart:ffi';
import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:local_notifications/services/notification_services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:workmanager/workmanager.dart';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import 'staticVars.dart';

import 'mainScreen.dart';

//FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;

Future showNotification() async {
  int IndexNotification =
      Random().nextInt(StaticVars().listaEstatic.length - 1);

  AndroidNotificationDetails androidPlatformChannelSpecifics =
      AndroidNotificationDetails(
    '$IndexNotification.0',
    'HELLO',
    importance: Importance.max,
    priority: Priority.high,
    playSound: true,
    enableVibration: true,
  );
  var platformChannelSpecifics =
      NotificationDetails(android: androidPlatformChannelSpecifics);

  await flutterLocalNotificationsPlugin.show(
    IndexNotification,
    'soy una notificacion',
    StaticVars().listaEstatic[IndexNotification],
    platformChannelSpecifics,
  );
}

@pragma(
    'vm:entry-point') // Mandatory if the App is obfuscated or using Flutter 3.1+
void callbackDispatcher() {
// initial notifications
  var initializationSettingsAndroid =
      AndroidInitializationSettings('@mipmap/ic_launcher');

  var initializationSettings =
      InitializationSettings(android: initializationSettingsAndroid);

  final flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  WidgetsFlutterBinding.ensureInitialized();

  flutterLocalNotificationsPlugin.initialize(
    initializationSettings,
  );

  Workmanager().executeTask((task, inputData) async {
    showNotification();
    return Future.value(true);
  });
}

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    Future.delayed(Duration(seconds: 10), () {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (_) => MainScreen()));
    });

    Workmanager().initialize(callbackDispatcher, isInDebugMode: false);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text(
          'SplashScreen',
          style: TextStyle(fontSize: 30),
        ),
      ),
    );
  }
}
