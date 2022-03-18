// 전체 테마 리스트를 가지고 각 뷰에 뿌려주기 위한 프로바이더
// getThema 의 경우 id로 검색을 진행하며 에러를 방지하기 위해 해당 id가 없을경우 모든 데이터가 -1로 차있는 테마객체를 만들어서 리턴함. 따라서 getThema 사용시 값 체크 필요.

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