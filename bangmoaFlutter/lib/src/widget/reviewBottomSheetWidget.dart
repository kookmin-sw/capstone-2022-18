// 테마의 리뷰를 모아서 보여주는 BottomSheet
// 테마 상세정보 페이지 내부에서 활용.

import 'dart:convert';

import 'package:bangmoa/src/const/themaInfoViewConst.dart';
import 'package:bangmoa/src/models/reviewModel.dart';
import 'package:bangmoa/src/provider/reviewProvider.dart';
import 'package:bangmoa/src/provider/selectedThemaProvider.dart';
import 'package:bangmoa/src/provider/userLoginStatusProvider.dart';
import 'package:bangmoa/src/widget/reviewTileWidget.dart';
import 'package:bangmoa/src/widget/themaGridTileWidget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:http/http.dart' as http;

Widget reviewBottomSheet(BuildContext context) {
  List<ReviewModel> reviewList = Provider.of<ReviewProvider>(context).getReviewList;
  final TextEditingController _textEditingController = TextEditingController();
  double _rating = 3.0;
  CollectionReference review = FirebaseFirestore.instance.collection('review');

  return Padding(
    padding: const EdgeInsets.all(6.0),
    child: Container(
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20)
      ),
      child: Padding(
        padding: const EdgeInsets.only(left: 8.0, right: 8.0),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
              child: Container(
                decoration: BoxDecoration(
                  // border: Border.all(
                  //   width: 1,
                  //   color: Colors.grey
                  // ),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  children: [
                    Padding(
                      padding: sheetDragBarPadding,
                      child: sheetDragBarText,
                    ),
                    Container(
                      height: 1,
                      width: 500,
                      color: Colors.grey,
                    ),
                    RatingBar.builder(
                      itemSize: 30,
                      initialRating: 3,
                      itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
                      minRating: 1,
                      direction: Axis.horizontal,
                      allowHalfRating: false,
                      itemCount: 5,
                      itemBuilder: (context, _) => Icon(
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
                                      Uri.parse("http://3.39.80.150:5000/reservation"),
                                      body: json.encode(
                                          {
                                            'text' : _textEditingController.text,
                                            'themaID' : Provider.of<SelectedThemaProvider>(context, listen: false).getSelectedThema.id,
                                            'writerID' : Provider.of<UserLoginStatusProvider>(context, listen: false).getUserID,
                                            'rating' : _rating,
                                          }
                                      ),
                                      headers: {"Content-Type": "application/json"}
                                  );
                                  print(_res.body.toString());
                                  _textEditingController.clear();
                                  loadReviewData(context, Provider.of<SelectedThemaProvider>(context, listen: false).getSelectedThema);
                                },
                                icon: const Icon(Icons.arrow_forward_ios_rounded)
                            ),
                            border: const OutlineInputBorder(
                                borderRadius: BorderRadius.all(Radius.circular(10.0))
                            )
                        ),
                        controller: _textEditingController,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(
              height: 75.0*reviewList.length,
              width: getReviewListBoxWidth(context),
              child: ListView.builder(
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: reviewList.length,
                  itemBuilder: (BuildContext context, int index) {
                    return reviewTileWidget(context, reviewList[index]);
                  }
              ),
            )
          ],
        ),
      ),
    ),
  );
}