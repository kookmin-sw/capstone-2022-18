// 리뷰 타일
// 향후 별점 등 기능 추가 가능성이 존재해서 위젯화함.

import 'package:bangmoa/src/const/themaInfoViewConst.dart';
import 'package:bangmoa/src/models/reviewModel.dart';
import 'package:flutter/material.dart';

Widget reviewTileWidget(BuildContext context, ReviewModel reviewModel) {
  return Column(
    children: [
      Container(
        color: Colors.grey,
        height: 1,
        width: MediaQuery.of(context).size.width*0.9,
      ),
      Padding(
        padding: EdgeInsets.only(bottom: 2.0),
        child: Container(
          decoration: BoxDecoration(
            color: reviewTileColor,
          ),
          child: Row(
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: SizedBox(
                  child: Text(reviewModel.writerNickName,
                    style: reviewTextStyle,
                  ),
                  width: getNickNameBoxWidth(context),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  color: Colors.grey,
                  width: 1,
                  height: 60,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: SizedBox(
                  height: 60,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(bottom: 8.0),
                        child: Row(
                          children: List.generate(5, (index) {
                            return Icon(
                              index < reviewModel.rating ? Icons.star : Icons.star_border,
                              color: Colors.yellow,
                            );
                          }),
                        ),
                      ),
                      Expanded(
                          child: Text(reviewModel.text,
                            style: reviewTextStyle,
                          )
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
      Container(
        color: Colors.grey,
        height: 1,
        width: MediaQuery.of(context).size.width*0.9,
      ),
    ],
  );
}