import 'dart:convert';

import 'package:bangmoa/src/models/alarm.dart';
import 'package:bangmoa/src/models/BMTheme.dart';
import 'package:bangmoa/src/models/manager.dart';
import 'package:bangmoa/src/provider/reserveInfoProvider.dart';
import 'package:bangmoa/src/provider/selectedThemeProvider.dart';
import 'package:bangmoa/src/provider/userLoginStatusProvider.dart';
import 'package:bangmoa/src/view/reserveInfoInputView.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_calendar_carousel/flutter_calendar_carousel.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

class ReservationView extends StatefulWidget {
  const ReservationView({Key? key}) : super(key: key);

  @override
  State<ReservationView> createState() => _ReservationViewState();
}

class _ReservationViewState extends State<ReservationView> {
  DateTime _currentDate = DateTime.now();
  late BMTheme _theme;
  late Manager _manager;
  late String _userID;
  List<String> timeList = [];
  List<bool> boolList = [];

  void _requestReserve(DateTime date) async {
    http.Response _res = await http.post(
        Uri.parse("http://3.39.80.150:5000/theme/status"),
        body: json.encode(
            {
              "id" : _theme.id,
              "date" : DateFormat('yyyy-MM-dd').format(date).toString(),
            }
        ),
        headers: {"Content-Type": "application/json"}
    );
    var body = json.decode(_res.body);
    timeList = body.keys.toList();
    boolList = List<bool>.from(body.values.toList());

    setState(() {

    });
  }

  void reservationBoxClickAction(int index) {
    if(context.read<UserLoginStatusProvider>().getLogin) {
      var reserveInfoProvider = Provider.of<ReserveInfoProvider>(context, listen: false);
      reserveInfoProvider.setTheme(_theme);
      reserveInfoProvider.setManager(_manager);
      reserveInfoProvider.setDate(DateFormat('yyyy-MM-dd').format(_currentDate).toString());
      reserveInfoProvider.setTime(timeList[index]);
      reserveInfoProvider.setCost(_theme.cost);
      Navigator.push(context, MaterialPageRoute(builder: (context) => const ReserveInfoInputView()));
    } else {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            content: const Text("예약을 진행하시려면 로그인을 해야합니다."),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text("ok"),
              )
            ],
          );
        }
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    SelectedThemeProvider themeProvider = Provider.of<SelectedThemeProvider>(context);
    UserLoginStatusProvider userLoginStatusProvider = Provider.of<UserLoginStatusProvider>(context);
    _theme = themeProvider.getSelectedTheme;
    _manager = themeProvider.getManager;
    if (userLoginStatusProvider.getLogin) {
      _userID = userLoginStatusProvider.getUserID;
    }

    return Scaffold(
      backgroundColor: Colors.black,
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          children: [
            SizedBox(
              height: 40,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset("asset/image/bangmoaLogo.png", height: 40, width: 40, fit: BoxFit.fill,),
                  const Text("방탈출 모아", style: TextStyle(fontSize: 17, fontFamily: 'POP', color: Colors.white),),
                ],
              ),
            ),
            Container(
              decoration: const BoxDecoration(
                color: Colors.white,
              ),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 15, bottom: 10),
                    child: Center(
                      child: Text(themeProvider.getSelectedTheme.name,
                        style: const TextStyle(
                            fontSize: 20
                        ),
                      ),
                    ),
                  ),
                  CalendarCarousel(
                    onDayPressed: (DateTime date, List<Widget> events) {
                      if (date.isAfter(DateTime.now())) {
                        setState(() => _currentDate = date);
                      } else if (date.day == DateTime.now().day && date.year == DateTime.now().year && date.month == DateTime.now().month){
                        setState(() => _currentDate = date);
                      }
                    },
                    customGridViewPhysics: const NeverScrollableScrollPhysics(),
                    height: 400,
                    selectedDateTime: _currentDate,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(right: 10.0),
                        child: Container(
                          alignment: Alignment.bottomRight,
                          child: TextButton(
                            style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all(Colors.indigo),

                            ),
                            child: const Text("알림 설정", style: TextStyle(color: Colors.white),),
                            onPressed: () async {
                              if (userLoginStatusProvider.getLogin) {
                                String id = _theme.id + "-" + _userID + DateFormat('yyyy-MM-dd').format(_currentDate).toString();
                                if (!userLoginStatusProvider.getAlarms.contains(id)){
                                  DocumentReference user = FirebaseFirestore.instance.collection('user').doc(_userID);
                                  CollectionReference alarm = FirebaseFirestore.instance.collection('alarm');
                                  await alarm.doc(id).set(
                                      {
                                        "themeID" : _theme.id,
                                        "themeName" : _theme.name,
                                        "date" : DateFormat('yyyy-MM-dd').format(_currentDate).toString(),
                                      }
                                  );
                                  await user.update({"alarms" : FieldValue.arrayUnion([id])});
                                  userLoginStatusProvider.addAlarm(Alarm(id, _theme.id, _theme.name, DateFormat('yyyy-MM-dd').format(_currentDate).toString()));
                                }
                              }
                            },
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(right: 10.0),
                        child: Container(
                          alignment: Alignment.bottomRight,
                          child: TextButton(
                            style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all(Colors.indigo),

                            ),
                            child: const Text("예약 검색", style: TextStyle(color: Colors.white),),
                            onPressed: () {
                              _requestReserve(_currentDate);
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 15,
            ),
            if (timeList.isEmpty)
              Container()
            else
            Container(
              decoration: const BoxDecoration(
                color: Colors.white,
              ),
              child: Padding(
                padding: const EdgeInsets.all(6.0),
                child: Column(
                  children: [
                    Text("${_theme.name} 예약현황"),
                    SizedBox(
                      height: 65.0*((timeList.length/6).ceil()),
                      child: GridView.builder(
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: timeList.length,
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 6,
                          childAspectRatio: 1.5,
                          mainAxisSpacing: 10.0,
                          crossAxisSpacing: 10.0,
                        ),
                        itemBuilder: (context, index) {
                          if (boolList[index]) {
                            return InkWell(
                              onTap: () {
                                reservationBoxClickAction(index);
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                    border: Border.all(
                                        color: Colors.black
                                    )
                                ),
                                child: Center(
                                  child: Text(timeList[index]),
                                ),
                              ),
                            );
                          } else {
                            return Container(
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: Colors.black
                                ),
                                color: Colors.red
                              ),
                              child: Center(
                                child: Text(timeList[index]),
                              ),
                            );
                          }
                        }
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
