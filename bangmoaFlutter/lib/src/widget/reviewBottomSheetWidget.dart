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
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

Widget reviewBottomSheet(BuildContext context) {
  List<ReviewModel> reviewList = Provider.of<ReviewProvider>(context).getReviewList;
  final TextEditingController _textEditingController = TextEditingController();
  double _rating = 3.0;

  void reviewWriteButtonAction() async {
    if (context.read<UserLoginStatusProvider>().getLogin) {
      http.Response _res = await http.post(
          Uri.parse("http://3.39.80.150:5000/review/add"),
          body: json.encode(
              {
                'text' : _textEditingController.text,
                'themaID' : Provider.of<SelectedThemeProvider>(context, listen: false).getSelectedTheme.id,
                'writerID' : Provider.of<UserLoginStatusProvider>(context, listen: false).getUserID,
                'rating' : _rating.toInt().toString(),
                'time' : DateFormat('yyyy-MM-dd HH:mm').format(DateTime.now()).toString(),
              }
          ),
          headers: {"Content-Type": "application/json"}
      );
      var body = json.decode(_res.body);
      if (body["result"] == "true") {
        _textEditingController.clear();
        loadReviewData(context, Provider.of<SelectedThemeProvider>(context, listen: false).getSelectedTheme);
      } else {
        showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                content: const Text("댓글 작성에 실패하였습니다. 잠시 후 다시 시도해주세요."),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text("ok"),
                  )
                ],
              );
            }
        );
      }
    } else {
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              content: const Text("댓글을 작성하시려면 로그인을 진행해야 합니다."),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text("ok"),
                )
              ],
            );
          }
      );
    }
  }

  return Container(
    color: Colors.white,
    child: Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
          child: Column(
            children: [
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: Text("댓글", style: TextStyle(fontSize: 18, color: Colors.black),),
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
                          onPressed: reviewWriteButtonAction,
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
          height: 60.0*reviewList.length + 25,
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