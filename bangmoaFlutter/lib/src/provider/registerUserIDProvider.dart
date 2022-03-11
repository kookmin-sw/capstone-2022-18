import 'package:flutter/material.dart';

class RegisterUserIDPRovder extends ChangeNotifier {
  late String _userID;

  String get getUserID => _userID;

  void setUserID(String userID) {
    _userID = userID;
    // notifyListeners();
  }
}