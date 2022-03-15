// 테마의 리뷰를 모아서 보여주는 BottomSheet
// 테마 상세정보 페이지 내부에서 활용.

import 'package:bangmoa/src/models/reviewModel.dart';
import 'package:bangmoa/src/widget/reviewTileWidget.dart';
import 'package:flutter/material.dart';

Widget reviewBottomSheet(List<ReviewModel> reviewList) {
  return SizedBox.expand(
    child: DraggableScrollableSheet(
      initialChildSize: 0.08,
      minChildSize: 0.08,
      maxChildSize: 1,
      builder: (BuildContext context, ScrollController scrollController) {
        return SingleChildScrollView(
          controller: scrollController,
          child: Container(
            decoration: BoxDecoration(
              border: Border.all(
                width: 1,
                color: Colors.grey,
              ),
              borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
              color: Colors.white
            ),
            child: Column(
              children: [
                const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text("댓글", style: TextStyle(fontSize: 18),)
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height*0.92,
                  width: MediaQuery.of(context).size.width,
                  child: ListView.builder(
                    itemCount: reviewList.length,
                    itemBuilder: (BuildContext context, int index) {
                      return reviewTileWidget(context, reviewList[index]);
                    }
                  ),
                )
              ],
            ),
          ),
        );
      }
    ),
  );
}
