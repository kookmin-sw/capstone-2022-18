// 메인페이지의 테마 타일을 만드는 위젯.

import 'dart:io';

import 'package:bangmoa/src/const/mainViewConst.dart';
import 'package:bangmoa/src/models/reviewModel.dart';
import 'package:bangmoa/src/models/BMTheme.dart';
import 'package:bangmoa/src/provider/reviewProvider.dart';
import 'package:bangmoa/src/provider/selectedThemeProvider.dart';
import 'package:bangmoa/src/view/themeInfoView.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ThemeGridTileWidget extends StatelessWidget {
  final BMTheme thema;
  const ThemeGridTileWidget({Key? key, required this.thema}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: tilePadding,
      child: InkWell(
        child: Column(
          children: [
            Center(child: Image.network(thema.poster, height: imageHeight, width: 175, fit: BoxFit.fill,)),
            Padding(
              padding: themeTextPadding,
              child: Text(thema.name,style: TextStyle(fontSize: 20, color: themeGridViewStringColor),overflow: TextOverflow.ellipsis),
            ),
            Padding(
              padding: themeTextPadding,
              child: Text(thema.genre, style: TextStyle(color: themeGridViewStringColor)),
            ),
            Padding(
              padding: themeTextPadding,
              child: Text("난이도 : ${thema.difficulty.toString()}", style: TextStyle(color: themeGridViewStringColor)),
            )
          ],
          crossAxisAlignment: CrossAxisAlignment.start,
        ),
        onTap: () {
          Provider.of<SelectedThemeProvider>(context, listen: false).setSelectedTheme(thema);
          Provider.of<ReviewProvider>(context, listen: false).setThemeID(thema.id);
          loadReviewData(context, thema);
          sleep(Duration(milliseconds: 100));
          Navigator.push(context, MaterialPageRoute(builder: (context) => const ThemeInfoView()));
        },
      ),
    );
  }
}

void loadReviewData(BuildContext context, BMTheme thema) async {
  Provider.of<ReviewProvider>(context, listen: false).initList();
  await FirebaseFirestore.instance.collection('review').where("themaID", isEqualTo: thema.id).get().then((QuerySnapshot querySnapshot) {
    querySnapshot.docs.forEach((document) async {
      String writerNickName = "";
      await FirebaseFirestore.instance.collection('user').doc(document["writerID"]).get().then((value) => writerNickName = value["nickname"]);
      Provider.of<ReviewProvider>(context,listen: false).addReview(ReviewModel(document.id, document["text"], document["themaID"], document["writerID"], writerNickName, document["rating"].toDouble()));
    });
  });
}