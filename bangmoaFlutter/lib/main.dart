import 'dart:io';

import 'package:bangmoa/src/models/cafeModel.dart';
import 'package:bangmoa/src/models/themaModel.dart';
import 'package:bangmoa/src/provider/cafeProvider.dart';
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

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  Workmanager().initialize(
    callbackDispatcher,
    isInDebugMode: true
  );
  Workmanager().registerPeriodicTask(
    "2",
    "simplePeriodicTask",
    frequency: Duration(minutes: 15),
  );
  await Firebase.initializeApp();
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
      ],
        child : MyApp()
    )
  );
}

void callbackDispatcher() {
  Workmanager().executeTask((task, inputData) {
    FlutterLocalNotificationsPlugin flip = FlutterLocalNotificationsPlugin();
    var android = const AndroidInitializationSettings('@mipmap/ic_launcher');
    var IOS = const IOSInitializationSettings(
      requestAlertPermission: false,
      requestBadgePermission: false,
      requestSoundPermission: false,
    );

    // initialise settings for both Android and iOS device.
    var settings = InitializationSettings(android: android, iOS: IOS);
    flip.initialize(settings);
    _showNotificationWithDefaultSound(flip);
    return Future.value(true);
  });
}

Future _showNotificationWithDefaultSound(FlutterLocalNotificationsPlugin flip) async {
  var androidPlatformChannelSpecifics = AndroidNotificationDetails(
      'your channel id',
      'your channel name',
      channelDescription: 'your channel description',
      importance: Importance.max,
      priority: Priority.high,
  );
  var iOSPlatformChannelSpecifics = IOSNotificationDetails();

  // initialise channel platform for both Android and iOS device.
  var platformChannelSpecifics = NotificationDetails(
      android: androidPlatformChannelSpecifics,
      iOS: iOSPlatformChannelSpecifics
  );
  sleep(Duration(seconds: 20));
  await flip.show(0, '방탈출모아',
      '[엘도라도] 2022-04-05 예약 가능 알림',
      platformChannelSpecifics, payload: 'Default_Sound'
  );
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
                            return MaterialApp(
                              title: 'BangMoa',
                              theme: ThemeData(
                                primarySwatch: Colors.grey,
                              ),
                              home: const mainView(),
                            );
                          }
                      );
                    }
                    return MaterialApp(
                      title: 'BangMoa',
                      theme: ThemeData(
                        primarySwatch: Colors.grey,
                      ),
                      home: const mainView(),
                    );
                  }
              );
            }
          }
        );
      }
    );
  }
}