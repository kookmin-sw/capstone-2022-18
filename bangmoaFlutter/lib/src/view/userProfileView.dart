// 유저 개인정보 페이지
// 현재는 로그인정보가 없을 시 로그인을 하기 위한 페이지만 존재, 개인정보 및 로그아웃 등 기능은 미구현.

import 'package:bangmoa/src/provider/userLoginStatusProvider.dart';
import 'package:bangmoa/src/view/loginView.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class UserProfileView extends StatefulWidget {
  const UserProfileView({Key? key}) : super(key: key);

  @override
  State<UserProfileView> createState() => _UserProfileViewState();
}

class _UserProfileViewState extends State<UserProfileView> {
  late bool _loginStatus;
  @override
  Widget build(BuildContext context) {
    UserLoginStatusProvider userLoginStatusProvider = Provider.of<UserLoginStatusProvider>(context);
    _loginStatus = Provider.of<UserLoginStatusProvider>(context).getLogin;
    if (!_loginStatus) {
      return Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                  height: MediaQuery.of(context).size.height*0.2,
                  child: const Text("로그인 정보가 없습니다.")
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
                  child: const Text("로그인", style: TextStyle(fontSize: 20, color: Colors.black)),
                ),
              )
            ],
          ),
        ),
      );
    }
    return Scaffold(
      body: Column(
        children: [
          Text(
            "닉네임 : ${userLoginStatusProvider.getNickName}",
            style: const TextStyle(
              fontSize: 30,
            ),
          ),
          TextButton(
            onPressed: () {

            },
            child: SizedBox(
              child: const Text(
                "로그아웃",
                style: TextStyle(
                    fontSize: 30
                ),
              ),
              height: MediaQuery.of(context).size.height*0.1,
              width: MediaQuery.of(context).size.width,
            ),
          )
        ],
      ),
    );
  }
}
