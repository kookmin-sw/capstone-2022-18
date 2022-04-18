import 'package:bangmoa/src/models/reviewModel.dart';
import 'package:flutter/material.dart';

class ReviewProvider extends ChangeNotifier{
  String _themeID = "";
  List<ReviewModel> _reviewList = [];

  List<ReviewModel> get getReviewList => _reviewList;
  String get getThemeID => _themeID;

  bool reviewIDCheck(String id) {
    for (var element in _reviewList) {
      if (element.id == id) {
        return false;
      }
    }
    return true;
  }

  void setThemeID(String themeID) {
    _themeID = themeID;
  }

  void changeThemeID(String themeID) {
    _themeID = themeID;
    notifyListeners();
  }

  void setReviewList(List<ReviewModel> reviewList) {
    _reviewList = reviewList;
  }

  void addReview(ReviewModel review) {
    _reviewList.add(review);
    notifyListeners();
  }

  void resetList() {
    _reviewList.clear();
    notifyListeners();
  }

  void initList() {
    _reviewList.clear();
  }
}