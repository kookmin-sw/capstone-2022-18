// 리뷰 타일
// 향후 별점 등 기능 추가 가능성이 존재해서 위젯화함.

import 'package:bangmoa/src/const/themeInfoViewConst.dart';
import 'package:bangmoa/src/models/reviewModel.dart';
import 'package:flutter/material.dart';

Widget reviewTileWidget(BuildContext context, ReviewModel reviewModel) {
  return Column(
    children: [
      Container(
        color: Colors.black,
        height: divisionLineHeight,
        width: getDivisionLineWidth(context),
      ),
      Padding(
        padding: const EdgeInsets.only(bottom: 2.0),
        child: Container(
          decoration: const BoxDecoration(
            color: Colors.white,
          ),
          child: Row(
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: SizedBox(
                  child: Text(reviewModel.writerNickName,
                    style: const TextStyle(
                        color: Colors.black
                    ),
                  ),
                  width: getNickNameBoxWidth(context),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                child: Container(
                  color: Colors.grey,
                  width: verticalDivisionLineWidth,
                  height: verticalDivisionLineHeight,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: SizedBox(
                  height: reviewTileHeight,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
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
                          Text(reviewModel.time,textAlign: TextAlign.end),
                        ],
                      ),
                      Expanded(
                          child: Text(reviewModel.text,
                            textAlign: TextAlign.start,
                            style: const TextStyle(
                                color: Colors.black
                            ),
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
    ],
  );
}