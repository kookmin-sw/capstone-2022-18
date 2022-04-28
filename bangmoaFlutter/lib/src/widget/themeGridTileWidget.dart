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
      padding: const EdgeInsets.all(8.0),
      child: InkWell(
        child: Column(
          children: [
            Center(child: Image.network(thema.poster, height: posterHeight, width: posterWidth, fit: BoxFit.fill,)),
            Padding(
              padding: const EdgeInsets.only(left: 5.0),
              child: Text(thema.name,style: const TextStyle(fontSize: themeTitleFontSize, color: Colors.white),overflow: TextOverflow.ellipsis),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 5.0),
              child: Text(thema.genre, style: const TextStyle(color: Colors.white)),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 5.0),
              child: Text("난이도 : ${thema.difficulty.toString()}", style: const TextStyle(color: Colors.white)),
            )
          ],
          crossAxisAlignment: CrossAxisAlignment.start,
        ),
        onTap: () {
          Provider.of<SelectedThemeProvider>(context, listen: false).setSelectedTheme(thema);
          Provider.of<ReviewProvider>(context, listen: false).setThemeID(thema.id);
          loadReviewData(context, thema);
          sleep(const Duration(milliseconds: 100));
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
      Provider.of<ReviewProvider>(context,listen: false).addReview(ReviewModel(document.id, document["text"], document["themaID"], document["writerID"], writerNickName, document["rating"].toDouble(), document["time"]));
    });
  });
}