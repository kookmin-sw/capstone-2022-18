// 메인페이지의 테마 타일을 만드는 위젯.

import 'dart:io';

import 'package:bangmoa/src/const/mainViewConst.dart';
import 'package:bangmoa/src/models/reviewModel.dart';
import 'package:bangmoa/src/models/themaModel.dart';
import 'package:bangmoa/src/provider/reviewProvider.dart';
import 'package:bangmoa/src/provider/selectedThemaProvider.dart';
import 'package:bangmoa/src/view/themaInfoView.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ThemaGridTileWidget extends StatelessWidget {
  final Thema thema;
  const ThemaGridTileWidget({Key? key, required this.thema}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: tilePadding,
      child: InkWell(
        child: Column(
          children: [
            Center(child: Image.network(thema.poster, height: imageHeight, width: 150, fit: BoxFit.fill,)),
            Padding(
              padding: themaTextPadding,
              child: Text(thema.name,style: themaTitleStyle,overflow: TextOverflow.ellipsis),
            ),
            Padding(
              padding: themaTextPadding,
              child: Text(thema.genre),
            ),
            Padding(
              padding: themaTextPadding,
              child: Text("난이도 : ${thema.difficulty.toString()}"),
            )
          ],
          crossAxisAlignment: CrossAxisAlignment.start,
        ),
        onTap: () {
          Provider.of<SelectedThemaProvider>(context, listen: false).setSelectedThema(thema);
          Provider.of<ReviewProvider>(context, listen: false).setThemaID(thema.id);
          loadReviewData(context, thema);
          sleep(Duration(milliseconds: 100));
          Navigator.push(context, MaterialPageRoute(builder: (context) => const ThemaInfoView()));
        },
      ),
    );
  }
}

void loadReviewData(BuildContext context, Thema thema) async {
  Provider.of<ReviewProvider>(context, listen: false).initList();
  await FirebaseFirestore.instance.collection('review').where("themaID", isEqualTo: thema.id).get().then((QuerySnapshot querySnapshot) {
    querySnapshot.docs.forEach((document) {
      String writerNickName = "";
      FirebaseFirestore.instance.collection('user').doc(document["writerID"]).get().then((value) => writerNickName = value["nickname"]);
      Provider.of<ReviewProvider>(context,listen: false).addReview(ReviewModel(document.id, document["text"], document["themaID"], document["writerID"], writerNickName, document["rating"].toDouble()));
    });
  });
}