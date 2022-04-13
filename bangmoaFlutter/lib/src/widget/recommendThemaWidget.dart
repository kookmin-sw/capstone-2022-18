import 'dart:io';

import 'package:bangmoa/src/models/reviewModel.dart';
import 'package:bangmoa/src/models/themaModel.dart';
import 'package:bangmoa/src/provider/reviewProvider.dart';
import 'package:bangmoa/src/provider/selectedThemaProvider.dart';
import 'package:bangmoa/src/view/themaInfoView.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

Widget RecommendThemaWidget(BuildContext context, List<Thema> recommendThema) {
  if (recommendThema.isEmpty) {
    return Container();
  }
  else {
    return Padding(
      padding: const EdgeInsets.all(6.0),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Padding(
          padding: const EdgeInsets.only(top: 8.0, left: 5, right: 5),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Padding(
                padding: EdgeInsets.only(left: 8.0),
                child: Text("추천 테마", style: TextStyle(fontSize: 15)),
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
                          Provider.of<SelectedThemaProvider>(context, listen: false).setSelectedThema(recommendThema[index]);
                          Provider.of<ReviewProvider>(context, listen: false).setThemaID(recommendThema[index].id);
                          loadReviewData(context, recommendThema[index]);
                          sleep(const Duration(milliseconds: 100));
                          Navigator.push(context, MaterialPageRoute(builder: (context) => const ThemaInfoView()));
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Image.network(recommendThema[index].poster, height: 100, width: 70, fit: BoxFit.fill,),
                        ),
                      );
                    },
                    itemCount: recommendThema.length,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

void loadReviewData(BuildContext context, Thema thema) async {
  Provider.of<ReviewProvider>(context, listen: false).initList();
  await FirebaseFirestore.instance.collection('review').where("themaID", isEqualTo: thema.id).get().then((QuerySnapshot querySnapshot) {
    querySnapshot.docs.forEach((document) async {
      String writerNickName = "";
      await FirebaseFirestore.instance.collection('user').doc(document["writerID"]).get().then((value) => writerNickName = value["nickname"]);
      Provider.of<ReviewProvider>(context,listen: false).addReview(ReviewModel(document.id, document["text"], document["themaID"], document["writerID"], writerNickName, document["rating"].toDouble()));
    });
  });
}