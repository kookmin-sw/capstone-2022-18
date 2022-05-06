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
  final BMTheme theme;
  const ThemeGridTileWidget({Key? key, required this.theme}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: InkWell(
        child: Container(
          color: Colors.white,
          child: Column(
            children: [
              Center(child: Image.network(theme.poster, height: posterHeight, width: posterWidth, fit: BoxFit.fill,)),
              Padding(
                padding: const EdgeInsets.only(left: 5.0),
                child: Text(theme.name,style: const TextStyle(fontSize: themeTitleFontSize),overflow: TextOverflow.ellipsis),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 5.0),
                child: Text(theme.genre),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 5.0),
                    child: Text("난이도 : ${theme.difficulty.toString()}"),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 5.0),
                    child: Text("${theme.runningtime.toString()}분"),
                  ),
                ],
              )
            ],
            crossAxisAlignment: CrossAxisAlignment.start,
          ),
        ),
        onTap: () {
          Provider.of<SelectedThemeProvider>(context, listen: false).setSelectedTheme(theme);
          Provider.of<ReviewProvider>(context, listen: false).setThemeID(theme.id);
          loadReviewData(context, theme);
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