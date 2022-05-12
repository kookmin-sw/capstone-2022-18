import 'package:bangmoa_manager/src/model/theme_model.dart';
import 'package:flutter/material.dart';

class ThemeInfoProvider extends ChangeNotifier {
  List<ThemeModel> _themeList = [];
  late ThemeModel _selectedTheme;
  bool _isInit = false;

  void setTheme(ThemeModel theme) {
    _selectedTheme = theme;
    notifyListeners();
  }

  void setThemeList(List<ThemeModel> themeList) {
    _themeList = themeList;
  }

  void addTheme(ThemeModel theme) {
    _themeList.add(theme);
  }

  void removeThemeWithIndex(int index) {
    _themeList.removeAt(index);
    notifyListeners();
  }

  void finishInit() {
    _isInit = true;
    notifyListeners();
  }

  ThemeModel get getSelectedTheme => _selectedTheme;
  List<ThemeModel> get getThemeList => _themeList;
  bool get getInitState => _isInit;
}