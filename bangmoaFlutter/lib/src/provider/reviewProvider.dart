import 'package:bangmoa/src/models/reviewModel.dart';
import 'package:flutter/material.dart';

class ReviewProvider extends ChangeNotifier{
  List<ReviewModel> _reviewList = [];

  List<ReviewModel> get getReviewList => _reviewList;

  bool reviewIDCheck(String id) {
    for (var element in _reviewList) {
      if (element.id == id) {
        return false;
      }
    }
    return true;
  }

  void setReviewList(List<ReviewModel> reviewList) {
    _reviewList = reviewList;
  }

  void addReview(ReviewModel review) {
    _reviewList.add(review);
  }

  void resetList() {
    _reviewList.clear();
    notifyListeners();
  }
}