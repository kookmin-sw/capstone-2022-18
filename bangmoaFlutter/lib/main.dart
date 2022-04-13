import 'dart:convert';

import 'package:bangmoa/src/models/alarm.dart';
import 'package:bangmoa/src/models/cafeModel.dart';
import 'package:bangmoa/src/models/themaModel.dart';
import 'package:bangmoa/src/provider/cafeProvider.dart';
import 'package:bangmoa/src/provider/reserveInfoProvider.dart';
import 'package:bangmoa/src/provider/reviewProvider.dart';
import 'package:bangmoa/src/provider/selectedThemaProvider.dart';
import 'package:bangmoa/src/provider/serchTextProvider.dart';
import 'package:bangmoa/src/provider/themaCafeListProvider.dart';
import 'package:bangmoa/src/provider/userLoginStatusProvider.dart';
import 'package:bangmoa/src/view/mainView.dart';
import 'package:bangmoa/src/view/registerNicknameView.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:workmanager/workmanager.dart';
import 'src/provider/themaProvider.dart';
import 'package:http/http.dart' as http;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  Workmanager().initialize(
    callbackDispatcher,
    isInDebugMode: true,
  );

  Workmanager().registerPeriodicTask(
    "2",
    "simplePeriodicTask",
    frequency: Duration(minutes: 15),
  );
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider<ThemaProvider>(create: (BuildContext context) => ThemaProvider()),
        ChangeNotifierProvider<SelectedThemaProvider>(create: (BuildContext context) => SelectedThemaProvider()),
        ChangeNotifierProvider<UserLoginStatusProvider>(create: (BuildContext context) => UserLoginStatusProvider()),
        ChangeNotifierProvider<CafeProvider>(create: (BuildContext context) => CafeProvider()),
        ChangeNotifierProvider<ReviewProvider>(create: (BuildContext context) => ReviewProvider()),
        ChangeNotifierProvider<ThemaCafeListProvider>(create: (BuildContext context) => ThemaCafeListProvider()),
        ChangeNotifierProvider<SearchTextProvider>(create: (BuildContext context) => SearchTextProvider()),
        ChangeNotifierProvider<ReserveInfoProvider>(create: (BuildContext context) => ReserveInfoProvider()),
      ],
        child : MyApp()
    )
  );
}

void callbackDispatcher() async {
  List<Alarm> alarmList = [];
  Workmanager().executeTask((task, inputData) async {
    await Firebase.initializeApp();
    var userDoc = await FirebaseFirestore.instance.collection("user").doc(FirebaseAuth.instance.currentUser!.uid).get();
    List<String> alarmData = userDoc.data()!["alarms"]?.cast<String>();
    for (var element in alarmData) {
      var alarmDoc = await FirebaseFirestore.instance.collection("alarm").doc(element).get();
      alarmList.add(Alarm.fromDocument(alarmDoc));
    }
    FlutterLocalNotificationsPlugin flip = FlutterLocalNotificationsPlugin();
    var android = const AndroidInitializationSettings('@mipmap/ic_launcher');
    var IOS = const IOSInitializationSettings(
      requestAlertPermission: false,
      requestBadgePermission: false,
      requestSoundPermission: false,
    );

    var settings = InitializationSettings(android: android, iOS: IOS);
    flip.initialize(settings);
    await _showNotificationWithDefaultSound(flip, alarmList);
    return Future.value(true);
  });
}

Future _showNotificationWithDefaultSound(FlutterLocalNotificationsPlugin flip, List<Alarm> alarmList) async {
  var androidPlatformChannelSpecifics = const AndroidNotificationDetails(
      'your channel id',
      'your channel name',
      channelDescription: 'your channel description',
      importance: Importance.max,
      priority: Priority.high,
  );
  var iOSPlatformChannelSpecifics = const IOSNotificationDetails();

  var platformChannelSpecifics = NotificationDetails(
      android: androidPlatformChannelSpecifics,
      iOS: iOSPlatformChannelSpecifics
  );
  if (alarmList.isNotEmpty) {
    int availableCount = 0;
    String game = "";
    for (var alarm in alarmList) {
      List<Cafe> cafeList = [];
      var cafe = await FirebaseFirestore.instance.collection("cafe").where("themes", arrayContains: alarm.themaID).get();
      for (var cafeDoc in cafe.docs) {
        cafeList.add(Cafe.fromDocument(cafeDoc));
      }
      http.Response _res = await http.post(
          Uri.parse("http://3.39.80.150:5000/reservation"),
          body: json.encode(
              {
                "id" : alarm.themaID,
                "date" : alarm.date,
              }
          ),
          headers: {"Content-Type": "application/json"}
      );
      var body = json.decode(_res.body);

      for (var element in cafeList) {
        if (body.toString() != "{}") {
          var timeTable = body[element.name] as Map;
          for (var key in timeTable.keys) {
            List<bool> boolList = List<bool>.from(timeTable[key].values.toList());
            if (boolList.contains(true)) {
              availableCount++;
              game = alarm.themaName;
            }
          }
        }
      }
    }
    if (availableCount > 0) {
      await flip.show(0, '방탈출모아',
          "$game 등${availableCount.toString()}개 테마 예약 가능",
          platformChannelSpecifics, payload: 'Default_Sound'
      );
    }
  }
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<Cafe> _cafeList = [];
    List<Thema> _themaList = [];
    return StreamBuilder(
      stream: FirebaseFirestore.instance.collection('cafe').snapshots(),
      builder: (context, AsyncSnapshot<QuerySnapshot> cafeSnapshot) {
        return StreamBuilder(
          stream: FirebaseFirestore.instance.collection('thema').snapshots(),
          builder: (context, AsyncSnapshot<QuerySnapshot> themaSnapshot) {
            if (cafeSnapshot.connectionState == ConnectionState.waiting || themaSnapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator(),);
            } else if (cafeSnapshot.hasError) {
              return Text(cafeSnapshot.error.toString());
            } else if (themaSnapshot.hasError) {
              return Text(themaSnapshot.error.toString());
            } else {
              cafeSnapshot.data!.docs.forEach((doc) {
                _cafeList.add(Cafe.fromDocument(doc));
              });
              themaSnapshot.data!.docs.forEach((doc) {
                _themaList.add(Thema.fromDocument(doc));
              });
              Provider.of<CafeProvider>(context).initCafeList(_cafeList);
              Provider.of<ThemaProvider>(context).initThemaList(_themaList);
              return StreamBuilder(
                stream: FirebaseAuth.instance.authStateChanges(),
                builder: (BuildContext context, AsyncSnapshot<User?> userAuthSnapshot) {
                  if (userAuthSnapshot.data == null) {
                    Provider.of<UserLoginStatusProvider>(context).logout();
                    return MaterialApp(
                      title: 'BangMoa',
                      theme: ThemeData(
                        primarySwatch: Colors.grey,
                      ),
                      home: const mainView(),
                    );
                  } else {
                    Provider.of<UserLoginStatusProvider>(context).login();
                    return FutureBuilder(
                      future : FirebaseFirestore.instance.collection('user').doc(userAuthSnapshot.data?.uid).get(),
                      builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot> userDataSnapshot) {
                        if (userDataSnapshot.connectionState == ConnectionState.waiting) {
                          return const Center(child: CircularProgressIndicator(),);
                        }
                        if (userDataSnapshot.data!.exists) {
                          Provider.of<UserLoginStatusProvider>(context, listen: false).setUserID(userAuthSnapshot.data!.uid);
                          Provider.of<UserLoginStatusProvider>(context, listen: false).setUserNickName(userDataSnapshot.data!["nickname"]);
                          List<String> alarmIdList = List<String>.from(userDataSnapshot.data!["alarms"]);
                          List<Alarm> alarmList = [];
                          for (var alarmID in alarmIdList) {
                            var alarmCollection = FirebaseFirestore.instance.collection("alarm").doc(alarmID);
                            alarmCollection.get().then(
                                  (value) => alarmList.add(Alarm.fromDocument(value))
                            );
                          }
                          Provider.of<UserLoginStatusProvider>(context, listen: false).setAlarm(alarmList);
                          return MaterialApp(
                            title: 'BangMoa',
                            theme: ThemeData(
                              primarySwatch: Colors.grey,
                            ),
                            home: const mainView(),
                          );
                        } else {
                          Provider.of<UserLoginStatusProvider>(context).setUserID(userAuthSnapshot.data!.uid);
                          return MaterialApp(
                            title: 'BangMoa',
                            theme: ThemeData(
                              primarySwatch: Colors.grey,
                            ),
                            home: const RegisterNicknameView(),
                          );
                        }
                      }
                    );
                  }
                }
              );
            }
          }
        );
      }
    );
  }
}