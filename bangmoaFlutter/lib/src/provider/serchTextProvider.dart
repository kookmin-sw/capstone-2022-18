import 'package:flutter/material.dart';

class SearchTextProvider extends ChangeNotifier{
  late String _searchText;

  String get getSearchText => _searchText;

  void setSearchText(String text) {
    _searchText = text;
  }
}