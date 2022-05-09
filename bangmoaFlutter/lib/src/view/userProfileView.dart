// 유저 개인정보 페이지
// 현재는 로그인정보가 없을 시 로그인을 하기 위한 페이지만 존재, 개인정보 및 로그아웃 등 기능은 미구현.

import 'package:bangmoa/src/models/reservation.dart';
import 'package:bangmoa/src/provider/userLoginStatusProvider.dart';
import 'package:bangmoa/src/view/loginView.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class UserProfileView extends StatefulWidget {
  const UserProfileView({Key? key}) : super(key: key);

  @override
  State<UserProfileView> createState() => _UserProfileViewState();
}

class _UserProfileViewState extends State<UserProfileView> {
  late bool _loginStatus;
  List<Reservation> _reserveList = [];

  Future<List<Reservation>> loadReserve() async {
    _loginStatus = Provider.of<UserLoginStatusProvider>(context, listen: false).getLogin;
    List<Reservation> list = [];
    if (_loginStatus) {
      var reserveDoc = FirebaseFirestore.instance.collection("reservation").where("user_id", isEqualTo: context.read<UserLoginStatusProvider>().getUserID);
      await reserveDoc.get().then((value) async {
        for (var element in value.docs) {
          String themeID = element["theme_id"];
          var themeDoc = await FirebaseFirestore.instance.collection("theme").doc(themeID).get();
          String themeName = themeDoc.get("name");
          list.add(Reservation(element.id, element["date"], element["theme_id"], themeName, element["time"], element["user_count"], element["user_id"], element["user_name"], element["user_phone"]));
        }
      });
    }
    return list;
  }

  void removeButtonAction(int index) {
    String alarmId = context.read<UserLoginStatusProvider>().getAlarms[index].id;
    FirebaseFirestore.instance.collection('alarm').doc(alarmId).delete();
    FirebaseFirestore.instance.collection('user').doc(context.read<UserLoginStatusProvider>().getUserID).update(
        {
          'alarms' : FieldValue.arrayRemove([alarmId]),
        }
    );
    Provider.of<UserLoginStatusProvider>(context,listen: false).removeAlarm(index);
    setState(() {

    });
  }

  void logOutButtonAction() async {
    try {
      context.read<UserLoginStatusProvider>().logout();
      return await FirebaseAuth.instance.signOut();
    } catch (e) {
      print('sign out failed');
      print(e.toString());
      return null;
    }
  }

  void reservationCancelButtonAction(int index) {
    FirebaseFirestore.instance.collection("reservation").doc(_reserveList[index].id).delete();
    _reserveList.removeAt(index);
    setState(() {

    });
  }

  @override
  Widget build(BuildContext context) {
    UserLoginStatusProvider userLoginStatusProvider = Provider.of<UserLoginStatusProvider>(context);
    _loginStatus = Provider.of<UserLoginStatusProvider>(context).getLogin;
    if (!_loginStatus) {
      return Scaffold(
        backgroundColor: Colors.black,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
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
              SizedBox(
                  height: MediaQuery.of(context).size.height*0.2,
                  child: const Text("로그인 정보가 없습니다.", style: TextStyle(color: Colors.white),)
              ),
              Container(
                width: MediaQuery.of(context).size.width*0.85,
                height: MediaQuery.of(context).size.height*0.1,
                decoration: BoxDecoration(
                    color: Colors.indigo,
                    borderRadius: BorderRadius.circular(20)
                ),
                child: TextButton(
                  onPressed: (){
                    Navigator.push(context, MaterialPageRoute(builder: (context) => const LoginView()));
                  },
                  child: const Text("로그인", style: TextStyle(fontSize: 20, color: Colors.white)),
                ),
              )
            ],
          ),
        ),
      );
    }
    return FutureBuilder(
      future: loadReserve(),
      builder: (context, AsyncSnapshot<List<Reservation>> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        }
        _reserveList = snapshot.data!;
        return Scaffold(
          backgroundColor: Colors.black,
          body: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
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
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    "닉네임 : ${userLoginStatusProvider.getNickName}",
                    style: const TextStyle(
                        fontSize: 30,
                        color: Colors.white
                    ),
                  ),
                ),
                TextButton(
                  onPressed: logOutButtonAction,
                  child: SizedBox(
                    child: const Text(
                      "로그아웃",
                      style: TextStyle(
                          fontSize: 30,
                          color: Colors.white
                      ),
                    ),
                    height: MediaQuery.of(context).size.height*0.1,
                    width: MediaQuery.of(context).size.width,
                  ),
                ),
                userLoginStatusProvider.getAlarms.isEmpty?Container() : SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text("알람목록",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 20
                            )
                        ),
                      ),
                      Column(
                        children: List.generate(userLoginStatusProvider.getAlarms.length, (index) => Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                            decoration: BoxDecoration(
                                border: Border.all(color: Colors.grey)
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                children: [
                                  Text("알람 ${index+1}", style: const TextStyle(color: Colors.white, fontSize: 15)),
                                  Row(
                                    children: [
                                      const Text("예약 테마 : " ,style: TextStyle(color: Colors.white)),
                                      Text(userLoginStatusProvider.getAlarms[index].themeName ,style: const TextStyle(color: Colors.white)),
                                    ],
                                  ),
                                  Row(
                                      children: [
                                        const Text("예약 날짜 : " ,style: TextStyle(color: Colors.white)),
                                        Text(userLoginStatusProvider.getAlarms[index].date ,style: const TextStyle(color: Colors.white)),
                                      ]
                                  ),
                                  Row(
                                    children: [
                                      Expanded(child: Container()),
                                      TextButton(
                                          onPressed: () {
                                            removeButtonAction(index);
                                          },
                                          child: const Text("삭제", style: TextStyle(color: Colors.white),)
                                      )
                                    ],
                                  )
                                ],
                              ),
                            ),
                          ),
                        )
                        ),
                      ),
                      const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text("예약목록",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 20
                            )
                        ),
                      ),
                      Column(
                        children: List.generate(_reserveList.length, (index) => Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                            decoration: BoxDecoration(
                                border: Border.all(color: Colors.grey)
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Center(child: Text("${_reserveList[index].theme_name} 예약", style: const TextStyle(color: Colors.white, fontSize: 15))),
                                  Text("예약날짜 : ${_reserveList[index].date}", style: const TextStyle(color: Colors.white)),
                                  Text("예약시간 : ${_reserveList[index].time}", style: const TextStyle(color: Colors.white)),
                                  Text("예약인원 : ${_reserveList[index].user_count}", style: const TextStyle(color: Colors.white),),
                                  Text("예약자 성함 : ${_reserveList[index].user_name}", style: const TextStyle(color: Colors.white)),
                                  Row(
                                    children: [
                                      Expanded(child: Container()),
                                      TextButton(
                                          onPressed: () {
                                            reservationCancelButtonAction(index);
                                          },
                                          child: const Text("예약 취소", style: TextStyle(color: Colors.white),)
                                      )
                                    ],
                                  )
                                ],
                              ),
                            ),
                          ),
                        )
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        );
      },
    );
  }
}
