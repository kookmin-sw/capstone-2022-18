import 'package:bangmoa/src/models/reviewModel.dart';
import 'package:flutter/material.dart';

class ReviewProvider extends ChangeNotifier{
  String _themaID = "";
  List<ReviewModel> _reviewList = [];

  List<ReviewModel> get getReviewList => _reviewList;
  String get getThemaID => _themaID;

  bool reviewIDCheck(String id) {
    for (var element in _reviewList) {
      if (element.id == id) {
        return false;
      }
    }
    return true;
  }

  void setThemaID(String themaID) {
    _themaID = themaID;
  }

  void changeThemaID(String themaID) {
    _themaID = themaID;
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