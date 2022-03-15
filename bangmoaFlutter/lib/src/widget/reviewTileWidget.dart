// 리뷰 타일
// 향후 별점 등 기능 추가 가능성이 존재해서 위젯화함.

import 'package:bangmoa/src/models/reviewModel.dart';
import 'package:flutter/material.dart';

Widget reviewTileWidget(BuildContext context, ReviewModel reviewModel) {
  return Container(
    color: const Color.fromRGBO(22, 32, 45, 1),
    child: Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          SizedBox(
            child: Text(reviewModel.writerNickName,
            style: const TextStyle(
                color: Colors.white
              ),
            ),
            width: MediaQuery.of(context).size.width*0.25,
          ),
          Container(
            width: 1,
            color: Colors.black,
          ),
          Expanded(
            child: Text(reviewModel.text,
              style: const TextStyle(
                  color: Colors.white
              ),
            )
          )
        ],
      ),
    ),
  );
}