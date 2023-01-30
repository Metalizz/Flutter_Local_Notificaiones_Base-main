import 'package:flutter/material.dart';

import 'splashScreen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Flutter Demo Notification',
        debugShowCheckedModeBanner: false, //elimina el lizton rojo Debug
        home: SplashScreen());
  }
}
