// 테마의 리뷰를 모아서 보여주는 BottomSheet
// 테마 상세정보 페이지 내부에서 활용.

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

class ReviewBottomSheet extends StatefulWidget {
  const ReviewBottomSheet({Key? key}) : super(key: key);

  @override
  State<ReviewBottomSheet> createState() => _ReviewBottomSheetState();
}

class _ReviewBottomSheetState extends State<ReviewBottomSheet> {
  final TextEditingController _textEditingController = TextEditingController();
  late List<ReviewModel> reviewList;
  CollectionReference review = FirebaseFirestore.instance.collection('review');
  double _rating = 3.0;

  @override
  Widget build(BuildContext context) {
    ReviewProvider reviewProvider = Provider.of<ReviewProvider>(context, listen: false);
    reviewList = reviewProvider.getReviewList;
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
                padding: sheetDragBarPadding,
                child: sheetDragBarText,
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
              TextField(
                maxLines: 2,
                decoration: InputDecoration(
                    suffixIcon: IconButton(
                        onPressed: () async {
                          await review.add({
                            'text' : _textEditingController.text,
                            'themaID' : Provider.of<SelectedThemaProvider>(context, listen: false).getSelectedThema.id,
                            'writerID' : Provider.of<UserLoginStatusProvider>(context, listen: false).getUserID,
                            'rating' : _rating,
                          });
                          reviewProvider.resetList();
                          _textEditingController.clear();
                          // setState(() {
                          //
                          // });
                          // scrollController.jumpTo(MediaQuery.of(context).size.height*0.2);
                        },
                        icon: const Icon(Icons.arrow_forward_ios_rounded)
                    ),
                    border: const OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10.0))
                    )
                ),
                controller: _textEditingController,
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
}

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
              padding: sheetDragBarPadding,
              child: sheetDragBarText,
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
            TextField(
              maxLines: 2,
              decoration: InputDecoration(
                  suffixIcon: IconButton(
                      onPressed: () async {
                        await review.add({
                          'text' : _textEditingController.text,
                          'themaID' : Provider.of<SelectedThemaProvider>(context, listen: false).getSelectedThema.id,
                          'writerID' : Provider.of<UserLoginStatusProvider>(context, listen: false).getUserID,
                          'rating' : _rating,
                        });
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