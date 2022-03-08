
import 'package:bangmoa/src/models/themaModel.dart';
import 'package:flutter/material.dart';

class ThemaProvider extends ChangeNotifier {
  List<Thema> _themaList = [];

  List<Thema> get getThemaList => _themaList;

  void initThemaList(List<Thema> themaList) {
    _themaList = themaList;
  }

  void setThemaList(List<Thema> themaList) {
    _themaList = themaList;
    notifyListeners();
  }

  Thema getThema (String id) {
    for (var element in _themaList) {
      if (element.id == id) {
        return element;
      }
    }
    return Thema("-1", "-1", "-1", "-1", -1, "-1");
  }
}