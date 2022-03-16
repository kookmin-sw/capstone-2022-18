// 테마의 리뷰를 모아서 보여주는 BottomSheet
// 테마 상세정보 페이지 내부에서 활용.

import 'package:bangmoa/src/const/themaInfoViewConst.dart';
import 'package:bangmoa/src/models/reviewModel.dart';
import 'package:bangmoa/src/widget/reviewTileWidget.dart';
import 'package:flutter/material.dart';

Widget reviewBottomSheet(List<ReviewModel> reviewList) {
  return SizedBox.expand(
    child: DraggableScrollableSheet(
      initialChildSize: sheetMinSize,
      minChildSize: sheetMinSize,
      maxChildSize: sheetMaxSize,
      builder: (BuildContext context, ScrollController scrollController) {
        return SingleChildScrollView(
          controller: scrollController,
          child: Container(
            decoration: BoxDecoration(
              border: Border.all(
                width: sheetBorderLineWidth,
                color: Colors.grey,
              ),
              borderRadius: sheetBorderRadius,
              color: Colors.white
            ),
            child: Column(
              children: [
                Padding(
                  padding: sheetDragBarPadding,
                  child: sheetDragBarText,
                ),
                SizedBox(
                  height: getReviewListBoxHeight(context),
                  width: getReviewListBoxWidth(context),
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
