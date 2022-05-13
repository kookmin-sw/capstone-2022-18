// 유저의 로그인 정보를 저장하며 뿌려주는 프로바이더
// _isLogin은 현재 로그인여부를 알려주는 boolean값.

import 'package:bangmoa/src/models/alarm.dart';
import 'package:bangmoa/src/models/bangmoaUser.dart';
import 'package:flutter/material.dart';

class UserLoginStatusProvider extends ChangeNotifier{
  late bool _isLogin;
  late String _userID;
  late String _nickName;
  late List<Alarm> _alarms;
  late BangmoaUser _user;

  String get getUserID => _userID;
  bool get getLogin => _isLogin;
  String get getNickName => _nickName;
  List<Alarm> get getAlarms => _alarms;
  List<String> get getRecommend => _user.recommend;

  void addAlarm(Alarm alarm) {
    _alarms.add(alarm);
    notifyListeners();
  }

  void setUser(BangmoaUser user) {
    _user = user;
  }

  void removeAlarm(int index) {
    _alarms.removeAt(index);
    notifyListeners();
  }

  void setAlarm(List<Alarm> alarms) {
    _alarms = alarms;
  }

  void setUserID(String userID) {
    _userID = userID;
    // notifyListeners();
  }

  void login() {
    _isLogin = true;
  }

  void logout() {
    _isLogin = false;
  }

  void setUserNickName(String nickName) {
    _nickName = nickName;
  }
}