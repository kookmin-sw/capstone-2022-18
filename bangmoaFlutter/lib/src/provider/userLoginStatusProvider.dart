import 'package:flutter/material.dart';

class UserLoginStatusProvider extends ChangeNotifier{
  late bool _isLogin;
  late String? _userID;
  late String _nickName;

  String? get getUserID => _userID;
  bool get getLogin => _isLogin;
  String get getNickName => _nickName;

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