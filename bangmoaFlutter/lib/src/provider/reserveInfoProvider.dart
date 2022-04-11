import 'package:bangmoa/src/models/cafeModel.dart';
import 'package:bangmoa/src/models/themaModel.dart';
import 'package:flutter/material.dart';

class ReserveInfoProvider extends ChangeNotifier{
  late Thema _thema;
  late Cafe _cafe;
  late String _date;
  late String _time;
  late int _cost;

  Thema get getThema => _thema;
  Cafe get getCafe => _cafe;
  String get getDate => _date;
  String get getTime => _time;
  int get getCost => _cost;

  void setThema(Thema thema) {
    _thema = thema;
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