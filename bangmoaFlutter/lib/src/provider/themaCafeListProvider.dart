import 'package:bangmoa/src/models/cafeModel.dart';
import 'package:flutter/material.dart';

class ThemaCafeListProvider extends ChangeNotifier{
  List<Cafe> _cafeList = [];

  List<Cafe> get getCafeList => _cafeList;

  void setCafeList(List<Cafe> cafeList) {
    _cafeList = cafeList;
  }

  void addCafe(Cafe cafe) {
    _cafeList.add(cafe);
    notifyListeners();
  }

}