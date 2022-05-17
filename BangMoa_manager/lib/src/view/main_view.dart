import 'dart:convert';

import 'package:bangmoa_manager/src/provider/login_status_provider.dart';
import 'package:bangmoa_manager/src/view/reservation_list_view.dart';
import 'package:bangmoa_manager/src/view/theme_info_view.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:crypto/crypto.dart';

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
  int _selectedIndex = 0;
  final List<Widget> _widgetList = [const ReservationListView(), const ThemeInfoView()];

  @override
  void initState() {
    super.initState();
  }

  void onClickLoginButton() async {
    // ID와 PW 모두 입력하지 않은 경우 종료
    if(_idController.text == '' || _pwController.text == '') {
      context.read<LoginStatusProvider>().setStatusText('ID와 PW를 모두 입력해야 합니다.');
      return;
    }
    // 비밀번호 해시
    String hashedPW = sha256.convert(utf8.encode(_pwController.text)).toString();

    // 서버에 로그인 요청
    http.Response response = await http.post(
      Uri.parse(LoginStatusProvider.baseURL + '/login/manager'),
      headers: <String, String> {'Content-Type': 'application/json'},
      body: json.encode({
        'id': _idController.text,
        'pw': hashedPW
      })
    );
    // 성공한 경우 로그인
    if(json.decode(response.body)['result'] == 'true') {
      context.read<LoginStatusProvider>().login();
      context.read<LoginStatusProvider>().setID(_idController.text);
    }
    // 실패한 경우 메시지 출력
    else {
      context.read<LoginStatusProvider>().setStatusText('ID 또는 PW가 올바르지 않습니다.');
    }
  }

  void onClickSignUpButton() => Navigator.pushNamed(context, '/signup');

  void onClickLogoutButton() => context.read<LoginStatusProvider>().logout();

  // 로그인 화면
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
          Row(
            children: [
              ElevatedButton(child: const Text('Sign up'), onPressed: onClickSignUpButton),
              const SizedBox(width: 10,),
              ElevatedButton(child: const Text('Log in'), onPressed: onClickLoginButton)
            ],
            mainAxisAlignment: MainAxisAlignment.end,
          ),
          Text(context.watch<LoginStatusProvider>().statusText)
        ],
      ),
    )
  );

  // 로그인 이후 메인 화면
  Widget _mainView() {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            ElevatedButton(
              child: const Text('logout'),
              onPressed: () => onClickLogoutButton(),
            )
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        backgroundColor: Colors.grey,
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.white.withOpacity(0.6),
        onTap: (int index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(
            label: "예약현황",
            icon: Icon(Icons.description),
          ),
          BottomNavigationBarItem(
            label: "테마정보",
            icon: Icon(Icons.photo_album),
          ),
        ],
      ),
      body: _widgetList[_selectedIndex],
    );
  }


  @override
  Widget build(BuildContext context) {
    if(!context.watch<LoginStatusProvider>().isLoggedIn) {
      return _loginView();
    }
    return _mainView();
  }
}