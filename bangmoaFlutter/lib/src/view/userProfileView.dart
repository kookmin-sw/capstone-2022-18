// 유저 개인정보 페이지
// 현재는 로그인정보가 없을 시 로그인을 하기 위한 페이지만 존재, 개인정보 및 로그아웃 등 기능은 미구현.

import 'package:bangmoa/src/provider/userLoginStatusProvider.dart';
import 'package:bangmoa/src/view/loginView.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class UserProfileView extends StatefulWidget {
  const UserProfileView({Key? key}) : super(key: key);

  @override
  State<UserProfileView> createState() => _UserProfileViewState();
}

class _UserProfileViewState extends State<UserProfileView> {
  late bool _loginStatus;

  void removeButtonAction(int index) {
    FirebaseFirestore.instance.collection('alarm').doc(context.read<UserLoginStatusProvider>().getAlarms[index].id).delete();
    Provider.of<UserLoginStatusProvider>(context,listen: false).removeAlarm(index);
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
              Container(
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
                    Navigator.push(context, MaterialPageRoute(builder: (context) => LoginView()));
                  },
                  child: const Text("로그인", style: TextStyle(fontSize: 20, color: Colors.white)),
                ),
              )
            ],
          ),
        ),
      );
    }
    return Scaffold(
      backgroundColor: Colors.black,
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
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
              onPressed: () {

              },
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
                          Text("알람 ${index+1}", style: const TextStyle(color: Colors.white)),
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
            )
          ],
        ),
      ),
    );
  }
}
