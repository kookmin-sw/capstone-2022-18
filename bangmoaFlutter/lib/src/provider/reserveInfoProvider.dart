import 'package:bangmoa/src/models/cafeModel.dart';
import 'package:bangmoa/src/models/BMTheme.dart';
import 'package:flutter/material.dart';

class ReserveInfoProvider extends ChangeNotifier{
  late BMTheme _theme;
  late Cafe _cafe;
  late String _date;
  late String _time;
  late int _cost;

  BMTheme get getTheme => _theme;
  Cafe get getCafe => _cafe;
  String get getDate => _date;
  String get getTime => _time;
  int get getCost => _cost;

  void setTheme(BMTheme theme) {
    _theme = theme;
  }

  void setCafe(Cafe cafe) {
    _cafe = cafe;
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