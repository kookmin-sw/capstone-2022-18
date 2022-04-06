import 'dart:convert';

import 'package:bangmoa/src/models/alarm.dart';
import 'package:bangmoa/src/models/cafeModel.dart';
import 'package:bangmoa/src/models/themaModel.dart';
import 'package:bangmoa/src/provider/selectedThemaProvider.dart';
import 'package:bangmoa/src/provider/themaCafeListProvider.dart';
import 'package:bangmoa/src/provider/userLoginStatusProvider.dart';
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
  late Thema _thema;
  late List<Cafe> _cafeList;
  late String _userID;
  List<Map<String, Map<String, dynamic>>> reserveList = [];

  void _requestReserve(DateTime date) async {
    http.Response _res = await http.post(
      Uri.parse("http://3.39.80.150:5000/reservation"),
      body: json.encode(
        {
          "id" : _thema.id,
          "date" : DateFormat('yyyy-MM-dd').format(date),
        }
      ),
      headers: {"Content-Type": "application/json"}
    );
    var body = json.decode(_res.body);
    for (var element in _cafeList) {
      var timeTable = body[element.name] as Map;
      timeTable.keys.forEach((key) {
        Map<String, Map<String, dynamic>> table = {};
        table.addAll({element.name+ " " +key : timeTable[key]});
        reserveList.add(table);
      });
    }
    setState(() {

    });
  }

  @override
  Widget build(BuildContext context) {
    SelectedThemaProvider themaProvider = Provider.of<SelectedThemaProvider>(context);
    ThemaCafeListProvider cafeListProvider = Provider.of<ThemaCafeListProvider>(context);
    UserLoginStatusProvider userLoginStatusProvider = Provider.of<UserLoginStatusProvider>(context);
    _thema = themaProvider.getSelectedThema;
    _cafeList = cafeListProvider.getCafeList;
    if (userLoginStatusProvider.getLogin) {
      _userID = userLoginStatusProvider.getUserID;
    }

    return Scaffold(
      backgroundColor: Colors.grey,
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
                  Text("방탈출 모아", style: TextStyle(fontSize: 17, fontFamily: 'POP'),),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(6),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20)
                ),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 15, bottom: 10),
                      child: Center(
                        child: Text(themaProvider.getSelectedThema.name,
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
                              child: Text("알림 설정", style: TextStyle(color: Colors.white),),
                              onPressed: () async {
                                if (userLoginStatusProvider.getLogin) {
                                  String id = _thema.id + "-" + _userID;
                                  if (!userLoginStatusProvider.getAlarms.contains(id)){
                                    DocumentReference user = FirebaseFirestore.instance.collection('user').doc(_userID);
                                    CollectionReference alarm = FirebaseFirestore.instance.collection('alarm');
                                    await alarm.doc(id).set(
                                        {
                                          "themaID" : _thema.id,
                                          "themaName" : _thema.name,
                                          "date" : DateFormat('yyyy-MM-dd').format(_currentDate).toString(),
                                        }
                                    );
                                    await user.update({"alarms" : FieldValue.arrayUnion([id])});
                                    userLoginStatusProvider.addAlarm(Alarm(_thema.id, _thema.name, DateFormat('yyyy-MM-dd').format(_currentDate).toString()));
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
                              child: Text("예약 검색", style: TextStyle(color: Colors.white),),
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
            ),
            reserveList.isEmpty? Container() : Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Padding(
                padding: EdgeInsets.all(6.0),
                child: Column(
                  children: List.generate(
                    reserveList.length*2,
                    (index1) {
                      String searchKey = reserveList[(index1/2).floor()].keys.first;
                      if (index1 == reserveList.length*2+1) {
                        return Container(
                          decoration: BoxDecoration(
                            color: Colors.indigo,
                          ),
                          child: TextButton(
                            child: Text("예약 알림설정하기"),
                            onPressed: () {

                            },
                          ),
                        );
                      }
                      else if (index1%2 != 0) {
                        List<bool> boolList = List<bool>.from(reserveList[(index1/2).floor()][searchKey]!.values.toList());
                        return SizedBox(
                          height: 150,
                          child: GridView.builder(
                              physics: NeverScrollableScrollPhysics(),
                              itemCount: reserveList[(index1/2).floor()][searchKey]!.length,
                              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 5,
                                childAspectRatio: 1.5,
                                mainAxisSpacing: 10.0,
                                crossAxisSpacing: 10.0,
                              ),
                              itemBuilder: (context, index) {
                                return boolList[index] ? Container(
                                  height: 10,
                                  width: 20,
                                  decoration: BoxDecoration(
                                      border: Border.all(
                                        color: Colors.black12,
                                      )
                                  ),
                                  child: Center(child: Text(reserveList[(index1/2).floor()][searchKey]!.keys.elementAt(index))),
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
