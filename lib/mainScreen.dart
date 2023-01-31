import 'package:flutter/material.dart';
import 'package:local_notifications/splashScreen.dart';
import 'package:workmanager/workmanager.dart';
import 'package:local_notifications/mainScreen.dart';

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  @override
  void initState() {
    /*List list = [
      {
        "v_hora_inicial": "15:00",
        "v_hora_final": "16:00",
        "v_num_dia": 2,
        "v_dia": "Martes"
      },
      {
        "v_hora_inicial": "16:00",
        "v_hora_final": "17:00",
        "v_num_dia": 5,
        "v_dia": "Viernes"
      }
    ];
    final List<String> horaInicial =
        list.map((h) => h["v_hora_inicial"].toString()).toList();

      int calculateRemainTimeInSeconds(String horaInicial) {
      DateTime _now = DateTime.now();
      int _nowInSeconds = _now.hour * 1500 + _now.minute * 900 + _now.second;
      //segundos sumados
      List<String> untilTime = horaInicial.split(":");

      int hour = int.parse(untilTime[0]);
      int minute = int.parse(untilTime[1]);
      if (hour > int.parse(horaInicial)) {
      } else {
        //if (minute == 45 || minute >= 45) {
        //mensaje de alerta
        callbackDispatcher();
        // }
      }
      print("**********************HORA/MINUTO*************************");
      print(hour);
      print(minute);
      return hour * 1500 + minute * 900 - _nowInSeconds;
    }*/

    Workmanager().registerPeriodicTask(
      "1",
      "notify_15_minutes_before_hour",
      frequency: Duration(minutes: 15),
      initialDelay: Duration(seconds: 5),
    );

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text(
          'Im Main Screen',
          style: TextStyle(fontSize: 20),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
