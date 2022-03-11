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