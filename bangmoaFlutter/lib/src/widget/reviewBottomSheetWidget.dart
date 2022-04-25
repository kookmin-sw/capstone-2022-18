// 테마의 리뷰를 모아서 보여주는 BottomSheet
// 테마 상세정보 페이지 내부에서 활용.

import 'dart:convert';

import 'package:bangmoa/src/const/themeInfoViewConst.dart';
import 'package:bangmoa/src/models/reviewModel.dart';
import 'package:bangmoa/src/provider/reviewProvider.dart';
import 'package:bangmoa/src/provider/selectedThemeProvider.dart';
import 'package:bangmoa/src/provider/userLoginStatusProvider.dart';
import 'package:bangmoa/src/widget/reviewTileWidget.dart';
import 'package:bangmoa/src/widget/themeGridTileWidget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:http/http.dart' as http;

Widget reviewBottomSheet(BuildContext context) {
  List<ReviewModel> reviewList = Provider.of<ReviewProvider>(context).getReviewList;
  final TextEditingController _textEditingController = TextEditingController();
  double _rating = 3.0;

  return Container(
    color: Colors.white,
    child: Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
          child: Column(
            children: [
              Padding(
                padding: sheetDragBarPadding,
                child: const Text("댓글", style: TextStyle(fontSize: 18, color: Colors.black),),
              ),
              Container(
                height: 1,
                width: 500,
                color: Colors.grey,
              ),
              RatingBar.builder(
                itemSize: 30,
                initialRating: 3,
                itemPadding: const EdgeInsets.symmetric(horizontal: 4.0),
                minRating: 1,
                direction: Axis.horizontal,
                allowHalfRating: false,
                itemCount: 5,
                itemBuilder: (context, _) => const Icon(
                  Icons.star,
                  color: Colors.amber,
                ),
                onRatingUpdate: (rating) {
                  _rating = rating;
                },
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  maxLines: 2,
                  decoration: InputDecoration(
                      suffixIcon: IconButton(
                          onPressed: () async {
                            http.Response _res = await http.post(
                              Uri.parse("http://3.39.80.150:5000/review/add"),
                              body: json.encode(
                                  {
                                    'text' : _textEditingController.text,
                                    'themaID' : Provider.of<SelectedThemeProvider>(context, listen: false).getSelectedTheme.id,
                                    'writerID' : Provider.of<UserLoginStatusProvider>(context, listen: false).getUserID,
                                    'rating' : _rating,
                                    'time' : DateTime.now().toString(),
                                  }
                              ),
                              headers: {"Content-Type": "application/json"}
                            );
                            print(_res.body.toString());
                            _textEditingController.clear();
                            loadReviewData(context, Provider.of<SelectedThemeProvider>(context, listen: false).getSelectedTheme);
                          },
                          icon: const Icon(Icons.arrow_forward_ios_rounded)
                      ),
                      border: const OutlineInputBorder()
                  ),
                  controller: _textEditingController,
                ),
              ),
            ],
          ),
        ),
        SizedBox(
          height: 75.0*reviewList.length,
          width: getReviewListBoxWidth(context),
          child: ListView.builder(
              physics: const NeverScrollableScrollPhysics(),
              itemCount: reviewList.length,
              itemBuilder: (BuildContext context, int index) {
                return reviewTileWidget(context, reviewList[index]);
              }
          ),
        )
      ],
    ),
  );
}