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
  List<Manager> managerCountList = [];
  List<Map<String, Map<String, dynamic>>> reserveList = [];

  void _requestReserve(DateTime date) async {
    http.Response _res = await http.post(
      Uri.parse("http://3.39.80.150:5000/theme/status"),
      body: json.encode(
        {
          "id" : _theme.id,
          "date" : DateFormat('yyyy-MM-dd').format(date),
        }
      ),
      headers: {"Content-Type": "application/json"}
    );
    var body = json.decode(_res.body);
    print(body);

    setState(() {

    });
  }

  void reservationBoxClickAction(int index, int index1, String searchKey) {
    if(context.read<UserLoginStatusProvider>().getLogin) {
      var reserveInfoProvider = Provider.of<ReserveInfoProvider>(context, listen: false);
      reserveInfoProvider.setTheme(_theme);
      reserveInfoProvider.setManager(managerCountList[(index1/2).floor()]);
      reserveInfoProvider.setDate(DateFormat('yyyy-MM-dd').format(_currentDate).toString());
      reserveInfoProvider.setTime(reserveList[(index1/2).floor()][searchKey]!.keys.elementAt(index));
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
                      setState(() => _currentDate = date);
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
            reserveList.isEmpty? Container() : Container(
              decoration: const BoxDecoration(
                color: Colors.white,
              ),
              child: Padding(
                padding: EdgeInsets.all(6.0),
                child: Column(
                  children: List.generate(
                    reserveList.length*2,
                    (index1) {
                      String searchKey = reserveList[(index1/2).floor()].keys.first;
                      if (index1%2 != 0) {
                        List<bool> boolList = List<bool>.from(reserveList[(index1/2).floor()][searchKey]!.values.toList());
                        return SizedBox(
                          height: 150,
                          child: GridView.builder(
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: reserveList[(index1/2).floor()][searchKey]!.length,
                              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 5,
                                childAspectRatio: 1.5,
                                mainAxisSpacing: 10.0,
                                crossAxisSpacing: 10.0,
                              ),
                              itemBuilder: (context, index) {
                                return boolList[index] ? InkWell(
                                  onTap: () {
                                    reservationBoxClickAction(index, index1, searchKey);
                                  },
                                  child: Container(
                                    height: 10,
                                    width: 20,
                                    decoration: BoxDecoration(
                                        border: Border.all(
                                          color: Colors.black12,
                                        )
                                    ),
                                    child: Center(child: Text(reserveList[(index1/2).floor()][searchKey]!.keys.elementAt(index))),
                                  ),
                                ) : Container(
                                  height: 10,
                                  width: 20,
                                  decoration: BoxDecoration(
                                    color: Colors.red,
                                      border: Border.all(
                                        color: Colors.black12,
                                      )
                                  ),
                                  child: Center(child: Text(reserveList[(index1/2).floor()][searchKey]!.keys.elementAt(index))),
                                );
                              }
                          ),
                        );
                      } else {
                        return Text(searchKey);
                      }
                    }
                  )
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
