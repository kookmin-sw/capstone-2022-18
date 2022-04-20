import 'dart:io';

import 'package:flutter/material.dart';

class SelectedImageProvider extends ChangeNotifier {
  late File _selectedImage;
  bool _isSelected = false;

  File get getImage => _selectedImage;
  bool get getSelectedState => _isSelected;

  void selectImage (File image) {
    _selectedImage = image;
    notifyListeners();
  }

  void select() {
    _isSelected = true;
    notifyListeners();
  }

  void reset() {
    _isSelected = false;
  }
}