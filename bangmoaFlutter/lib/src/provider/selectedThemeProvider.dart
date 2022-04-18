// 유저에 의해 선택된 테마 정보를 저장하고 각 뷰에 뿌려주기 위한 프로바이더.

import 'package:bangmoa/src/models/BMTheme.dart';
import 'package:flutter/material.dart';

class SelectedThemeProvider extends ChangeNotifier{
  late BMTheme _selectedTheme;

  BMTheme get getSelectedTheme => _selectedTheme;

  void setSelectedTheme(BMTheme theme) {
    _selectedTheme = theme;
    notifyListeners();
  }
}