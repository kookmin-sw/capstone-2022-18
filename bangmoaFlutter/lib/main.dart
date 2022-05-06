import 'dart:convert';

import 'package:bangmoa/src/models/alarm.dart';
import 'package:bangmoa/src/models/BMTheme.dart';
import 'package:bangmoa/src/models/manager.dart';
import 'package:bangmoa/src/provider/managerProvider.dart';
import 'package:bangmoa/src/provider/reserveInfoProvider.dart';
import 'package:bangmoa/src/provider/reviewProvider.dart';
import 'package:bangmoa/src/provider/selectedThemeProvider.dart';
import 'package:bangmoa/src/provider/serchTextProvider.dart';
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
import 'src/provider/themeProvider.dart';
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
    frequency: const Duration(minutes: 15),
  );

  managerList = await loadFirebaseManagerList();
  themeList = await loadFirebaseThemeList();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider<ThemeProvider>(create: (BuildContext context) => ThemeProvider()),
        ChangeNotifierProvider<SelectedThemeProvider>(create: (BuildContext context) => SelectedThemeProvider()),
        ChangeNotifierProvider<UserLoginStatusProvider>(create: (BuildContext context) => UserLoginStatusProvider()),
        ChangeNotifierProvider<ManagerProvider>(create: (BuildContext context) => ManagerProvider()),
        ChangeNotifierProvider<ReviewProvider>(create: (BuildContext context) => ReviewProvider()),
        ChangeNotifierProvider<SearchTextProvider>(create: (BuildContext context) => SearchTextProvider()),
        ChangeNotifierProvider<ReserveInfoProvider>(create: (BuildContext context) => ReserveInfoProvider()),
      ],
        child : const MyApp()
    )
  );
}

List<Manager> managerList = [];
List<BMTheme> themeList = [];

void callbackDispatcher() async {
  List<Alarm> alarmList = [];
  Workmanager().executeTask((task, inputData) async {
    await Firebase.initializeApp();
    if (FirebaseAuth.instance.currentUser != null) {
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
    } else {
      return Future.value(false);
    }
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
    try{
      for (var alarm in alarmList) {
        http.Response _res = await http.post(
            Uri.parse("http://3.39.80.150:5000/theme/status"),
            body: json.encode(
                {
                  "id" : alarm.themeID,
                  "date" : alarm.date,
                }
            ),
            headers: {"Content-Type": "application/json"}
        );
        var body = json.decode(_res.body);
        print(body.toString());

        if (body.toString() != "{}") {
          List<bool> boolList = List<bool>.from(body.values.toList());
          if (boolList.contains(true)) {
            availableCount++;
            if (game.isEmpty) {
              game = alarm.themeName;
            }
          }
        }
      }
    } catch(e){
      print(e);
    }
    if (availableCount > 0) {
      await flip.show(0, '방탈출모아',
          "$game 등${availableCount.toString()}개 테마 예약 가능",
          platformChannelSpecifics, payload: 'Default_Sound'
      );
    }
  }
}

Future<List<BMTheme>> loadFirebaseThemeList() async {
  List<BMTheme> themeList = [];
  await FirebaseFirestore.instance.collection('theme').get().then((snapshot) {
    for (var doc in snapshot.docs) {
      themeList.add(BMTheme.fromDocument(doc));
    }
  });
  return themeList;
}

Future<List<Manager>> loadFirebaseManagerList() async {
  List<Manager> managerList = [];
  await FirebaseFirestore.instance.collection('manager').get().then((snapshot) {
    for (var doc in snapshot.docs) {
      managerList.add(Manager.fromDocument(doc));
    }
  });
  return managerList;
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Provider.of<ManagerProvider>(context).initManagerList(managerList);
    Provider.of<ThemeProvider>(context).initThemeList(themeList);
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
              home: const MainView(),
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
                        (value) {
                          if(value.exists) {
                            alarmList.add(Alarm.fromDocument(value));
                          }
                        }
                      );
                    }
                    Provider.of<UserLoginStatusProvider>(context, listen: false).setAlarm(alarmList);
                    return MaterialApp(
                      title: 'BangMoa',
                      theme: ThemeData(
                        primarySwatch: Colors.grey,
                      ),
                      home: const MainView(),
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