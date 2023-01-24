import 'dart:async';
import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:workmanager/workmanager.dart';
import 'repository.dart';

void main() => runApp(MyApp());

const simpleTaskKey = "be.tramckrijte.workmanagerExample.simpleTask";
const rescheduledTaskKey = "be.tramckrijte.workmanagerExample.rescheduledTask";
const failedTaskKey = "be.tramckrijte.workmanagerExample.failedTask";
const simpleDelayedTask = "be.tramckrijte.workmanagerExample.simpleDelayedTask";
const simplePeriodicTask =
    "be.tramckrijte.workmanagerExample.simplePeriodicTask";
const simplePeriodic1HourTask =
    "be.tramckrijte.workmanagerExample.simplePeriodic1HourTask";

@pragma(
    'vm:entry-point') // Mandatory if the App is obfuscated or using Flutter 3.1+
void callbackDispatcher() {
  Workmanager().executeTask((task, inputData) async {
    Timer.periodic(Duration(seconds: 15), (Timer t) {
      print('message each 15 second');
    });
    switch (task) {
      case simpleTaskKey:
        print("$simpleTaskKey was executed. inputData = $inputData");
        final prefs = await SharedPreferences.getInstance();
        prefs.setBool("test", true);
        print("Bool from prefs: ${prefs.getBool("test")}");
        break;
      case rescheduledTaskKey:
        final key = inputData!['key']!;
        final prefs = await SharedPreferences.getInstance();
        if (prefs.containsKey('unique-$key')) {
          print('has been running before, task is successful');
          return true;
        } else {
          await prefs.setBool('unique-$key', true);
          print('reschedule task');
          return false;
        }
      case simplePeriodic1HourTask:
        print("$simplePeriodic1HourTask was executed");
        break;
    }

    return Future.value(true);
  });
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

List list = [
  {
    "v_hora_inicial": "13:00",
    "v_hora_final": "15:00",
    "v_num_dia": 2,
    "v_dia": "Martes"
  },
  {
    "v_hora_inicial": "14:00",
    "v_hora_final": "15:00",
    "v_num_dia": 5,
    "v_dia": "Viernes"
  }
];
final List<String> hourList =
    list.map((h) => h["v_hora_inicial"].toString()).toList();

int calculateRemainTimeInSeconds(String nextTime) {
  DateTime _now = DateTime.now();
  int _nowInSeconds = _now.hour * 3600 + _now.minute * 60 + _now.second;
  List<String> untilTime = nextTime.split(":");
  int hour = int.parse(untilTime[0]);
  int minute = int.parse(untilTime[1]);
  print("**********************HORA/MINUTO*************************");
  print(hour);
  print(minute);
  return hour * 3600 + minute * 60 - _nowInSeconds;
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    print(hourList); //TRAE SOLO LA HORA

    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text("Flutter WorkManager Example"),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Text(
                  "Plugin initialization",
                  style: Theme.of(context).textTheme.headline5,
                ),
                ElevatedButton(
                  child: Text("Start the Flutter background service"),
                  onPressed: () {
                    Workmanager().initialize(
                      callbackDispatcher,
                      isInDebugMode: true,
                    );
                  },
                ),
                //This task runs periodically
                //It will run about every hour
                ElevatedButton(
                    child: Text("Register 1 hr Periodic Task"),
                    onPressed: Platform.isAndroid
                        ? () {
                            Workmanager().registerPeriodicTask(
                              simplePeriodicTask,
                              simplePeriodic1HourTask,
                              //frequency: Duration(minutes: 15),
                              initialDelay: Duration(
                                  seconds: calculateRemainTimeInSeconds(
                                      hourList.toString())),
                              /*backoffPolicy: BackoffPolicy.linear,
                              existingWorkPolicy: ExistingWorkPolicy.replace,
                              constraints: Constraints(
                                  networkType: NetworkType.not_required,
                                  requiresCharging: false,
                                  requiresBatteryNotLow: false,
                                  requiresDeviceIdle: false,
                                  requiresStorageNotLow: false),*/
                            );
                          }
                        : null),
                SizedBox(height: 16),
                Text(
                  "Task cancellation",
                  style: Theme.of(context).textTheme.headline5,
                ),
                ElevatedButton(
                  child: Text("Cancel All"),
                  onPressed: () async {
                    await Workmanager().cancelAll();
                    print('Cancel all tasks completed');
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
