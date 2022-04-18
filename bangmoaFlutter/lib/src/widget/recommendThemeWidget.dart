import 'dart:io';

import 'package:bangmoa/src/models/reviewModel.dart';
import 'package:bangmoa/src/models/BMTheme.dart';
import 'package:bangmoa/src/provider/reviewProvider.dart';
import 'package:bangmoa/src/provider/selectedThemeProvider.dart';
import 'package:bangmoa/src/view/themeInfoView.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

Widget recommendThemeWidget(BuildContext context, List<BMTheme> recommendTheme) {
  if (recommendTheme.isEmpty) {
    return Container();
  }
  else {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0, left: 5, right: 5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.only(left: 8.0),
            child: Text("추천 테마", style: TextStyle(fontSize: 15, color: Colors.white)),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: SizedBox(
              height: 120,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemBuilder: (context, index) {
                  return InkWell(
                    onTap: () {
                      Provider.of<SelectedThemeProvider>(context, listen: false).setSelectedTheme(recommendTheme[index]);
                      Provider.of<ReviewProvider>(context, listen: false).setThemeID(recommendTheme[index].id);
                      loadReviewData(context, recommendTheme[index]);
                      sleep(const Duration(milliseconds: 100));
                      Navigator.push(context, MaterialPageRoute(builder: (context) => const ThemeInfoView()));
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Image.network(recommendTheme[index].poster, height: 100, width: 70, fit: BoxFit.fill,),
                    ),
                  );
                },
                itemCount: recommendTheme.length,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

void loadReviewData(BuildContext context, BMTheme theme) async {
  Provider.of<ReviewProvider>(context, listen: false).initList();
  await FirebaseFirestore.instance.collection('review').where("themaID", isEqualTo: theme.id).get().then((QuerySnapshot querySnapshot) {
    querySnapshot.docs.forEach((document) async {
      String writerNickName = "";
      await FirebaseFirestore.instance.collection('user').doc(document["writerID"]).get().then((value) => writerNickName = value["nickname"]);
      Provider.of<ReviewProvider>(context,listen: false).addReview(ReviewModel(document.id, document["text"], document["themaID"], document["writerID"], writerNickName, document["rating"].toDouble()));
    });
  });
}