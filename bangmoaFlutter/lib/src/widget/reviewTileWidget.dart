// 리뷰 타일
// 향후 별점 등 기능 추가 가능성이 존재해서 위젯화함.

import 'package:bangmoa/src/const/themaInfoViewConst.dart';
import 'package:bangmoa/src/models/reviewModel.dart';
import 'package:flutter/material.dart';

Widget reviewTileWidget(BuildContext context, ReviewModel reviewModel) {
  return Padding(
    padding: EdgeInsets.only(bottom: 2.0),
    child: Container(
      decoration: BoxDecoration(
          color: reviewTileColor,
          borderRadius: BorderRadius.circular(20)
      ),
      child: Padding(
        padding: tileRowPadding,
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
              padding: const EdgeInsets.only(right: 8.0),
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
  );
}