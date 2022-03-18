// 리뷰 타일
// 향후 별점 등 기능 추가 가능성이 존재해서 위젯화함.

import 'package:bangmoa/src/const/themaInfoViewConst.dart';
import 'package:bangmoa/src/models/reviewModel.dart';
import 'package:flutter/material.dart';

Widget reviewTileWidget(BuildContext context, ReviewModel reviewModel) {
  return Container(
    color: reviewTileColor,
    child: Padding(
      padding: tileRowPadding,
      child: Row(
        children: [
          SizedBox(
            child: Text(reviewModel.writerNickName,
            style: reviewTextStyle,
            ),
            width: getNickNameBoxWidth(context),
          ),
          Expanded(
            child: Text(reviewModel.text,
              style: reviewTextStyle,
            )
          )
        ],
      ),
    ),
  );
}