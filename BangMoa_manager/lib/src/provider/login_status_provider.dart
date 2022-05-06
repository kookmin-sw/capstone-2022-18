import 'package:flutter/material.dart';


class LoginStatusProvider extends ChangeNotifier {
  static const String baseURL = 'http://3.39.80.150:5000';

  bool _isLoggedIn = false;
  bool get isLoggedIn => _isLoggedIn;

  String _statusText = '';
  String get statusText => _statusText;

  late String _id;
  String get getId => _id;

  void setID(String id) {
    _id = id;
    notifyListeners();
  }

  void login(){
    _isLoggedIn = true;
    notifyListeners();
  }

  void logout() {
    _isLoggedIn = false;
    notifyListeners();
  }

  void setStatusText(String text) {
    _statusText = text;
    notifyListeners();
  }
}