import 'package:bangmoa/src/models/manager.dart';
import 'package:flutter/material.dart';

class ManagerProvider extends ChangeNotifier {
  List<Manager> _managerList = [];
  List<String> regionList = ["홍대", "마포구", "신촌", "서대문구", "강남", "강남구", "서초구", "건대", "광진구", "대학로", "혜화", "종로구", "명동", "부산", "서면", "해운대", "인천", "부천", "대구", "동성로"];
  Map<String, List<String>> regionMapping = {
    "홍대" : ["홍대", "마포구"],
    "신촌" : ["신촌", "서대문구"],
    "강남" : ["강남", "강남구", "서초구"],
    "건대" : ["건대", "광진구"],
    "대학로" : ["대학로", "혜화", "종로구"],
    "명동" : ["명동"],
    "부산" : ["부산", "서면", "해운대"],
    "인천" : ["인천"],
    "대구" : ["대구", "동성로"],
  };

  List<Manager> get getManagerList => _managerList;

  void initManagerList(List<Manager> managerList) {
    _managerList = managerList;
  }

  Manager? getManagerByID(String id) {
    for (var element in _managerList) {
      if (element.id == id) {
        return element;
      }
    }
    return null;
  }
}