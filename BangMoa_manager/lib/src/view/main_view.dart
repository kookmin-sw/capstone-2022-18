import 'dart:convert';

import 'package:bangmoa_manager/src/provider/login_status_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:http/http.dart' as http;

import '../../main.dart';

class MainView extends StatefulWidget{
  const MainView({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _MainViewState();
}

class _MainViewState extends State<MainView> {

  final TextEditingController _idController = TextEditingController();
  final TextEditingController _pwController = TextEditingController();

  void onClickLoginButton() async {
    // 서버에 로그인 요청
    http.Response response = await http.post(
      Uri.parse(MyApp.baseURL + '/login/manager'),
      headers: <String, String> {'Content-Type': 'application/json'},
      body: json.encode({
        'id': _idController.text,
        'pw': _pwController.text
      })
    );
    // 성공한 경우 로그인
    if(json.decode(response.body)['result'] == 'true') {
      context.read<LoginStatusProvider>().login();
    }
    // 실패한 경우 메시지 출력
    else {

    }
  }
  void onClickLogoutButton() => context.read<LoginStatusProvider>().logout();

  Widget _loginView() => Scaffold(
    body: Container(
      padding: const EdgeInsets.all(30),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          TextField(
            controller: _idController,
            decoration: const InputDecoration(
              labelText: 'ID',
              border: OutlineInputBorder()
            ),
          ),
          const SizedBox(height: 10),
          TextField(
            controller: _pwController,
            decoration: const InputDecoration(
              labelText: 'PW',
              border: OutlineInputBorder()
            ),
            obscureText: true,
          ),
          const SizedBox(height: 20),
          ElevatedButton(child: const Text('Submit'), onPressed: onClickLoginButton)
        ],
      ),
    )
  );

  Widget _mainView() => Scaffold(
    body: Container(
      child:ElevatedButton(
        child: Text('logout'),
        onPressed: () => onClickLogoutButton(),
      )
    ),
  );

  @override
  Widget build(BuildContext context) {
    if(!context.watch<LoginStatusProvider>().isLoggedIn) {
      return _loginView();
    }
    return _mainView();
  }
}