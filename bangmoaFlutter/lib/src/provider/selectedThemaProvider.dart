// 유저에 의해 선택된 테마 정보를 저장하고 각 뷰에 뿌려주기 위한 프로바이더.

import 'package:bangmoa/src/models/themaModel.dart';
import 'package:flutter/material.dart';

class SelectedThemaProvider extends ChangeNotifier{
  late Thema _selectedThema;

  Thema get getSelectedThema => _selectedThema;

  void setSelectedThema(Thema thema) {
    _selectedThema = thema;
    notifyListeners();
  }
}