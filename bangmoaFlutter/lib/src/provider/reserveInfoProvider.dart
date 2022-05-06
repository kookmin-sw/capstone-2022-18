import 'package:bangmoa/src/models/BMTheme.dart';
import 'package:bangmoa/src/models/manager.dart';
import 'package:flutter/material.dart';

class ReserveInfoProvider extends ChangeNotifier{
  late BMTheme _theme;
  late Manager _manager;
  late String _date;
  late String _time;
  late int _cost;

  BMTheme get getTheme => _theme;
  Manager get getManager => _manager;
  String get getDate => _date;
  String get getTime => _time;
  int get getCost => _cost;

  void setTheme(BMTheme theme) {
    _theme = theme;
  }

  void setManager(Manager manager) {
    _manager = manager;
  }

  void setDate(String date) {
    _date = date;
  }

  void setTime(String time) {
    _time = time;
  }

  void setCost(int cost) {
    _cost = cost;
  }
}