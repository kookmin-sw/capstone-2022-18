// 테마 상세정보 페이지
// 테마 설명부분과 하단 댓글 Bottom Sheet 로 구성되어 있음.
// 하단 Bottom Sheet 은 reviewBottomSheet 위젯 사용.

import 'package:bangmoa/src/const/themaInfoViewConst.dart';
import 'package:bangmoa/src/models/cafeModel.dart';
import 'package:bangmoa/src/models/reviewModel.dart';
import 'package:bangmoa/src/models/themaModel.dart';
import 'package:bangmoa/src/provider/reviewProvider.dart';
import 'package:bangmoa/src/provider/selectedThemaProvider.dart';
import 'package:bangmoa/src/provider/themaCafeListProvider.dart';
import 'package:bangmoa/src/view/reservationView.dart';
import 'package:bangmoa/src/widget/reviewBottomSheetWidget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ThemaInfoView extends StatefulWidget {
  const ThemaInfoView({Key? key}) : super(key: key);

  @override
  _ThemaInfoViewState createState() => _ThemaInfoViewState();
}

class _ThemaInfoViewState extends State<ThemaInfoView> {
  late Thema selectedThema;
  List<Cafe> cafeList = [];

  @override
  Widget build(BuildContext context) {
    selectedThema = Provider.of<SelectedThemaProvider>(context).getSelectedThema;
    return StreamBuilder(
      stream: FirebaseFirestore.instance.collection('review').where("themaID", isEqualTo: selectedThema.id).snapshots(),
      builder: (context, AsyncSnapshot<QuerySnapshot> reviewSnapshot) {
        return StreamBuilder(
          stream: FirebaseFirestore.instance.collection('cafe').where("themes", arrayContains: selectedThema.id).snapshots(),
          builder: (context, AsyncSnapshot<QuerySnapshot> cafeSnapshot) {
            if (reviewSnapshot.hasError) {
              return Text('Error : ${reviewSnapshot.error}');
            }
            if (cafeSnapshot.hasError) {
              return Text('Error : ${cafeSnapshot.error}');
            }
            if (reviewSnapshot.connectionState == ConnectionState.waiting) {
              return themaInfoViewLoadingIndicator();
            }
            if (cafeSnapshot.connectionState == ConnectionState.waiting) {
              return themaInfoViewLoadingIndicator();
            }
            cafeSnapshot.data?.docs.forEach((element) {
              cafeList.add(Cafe.fromDocument(element));
            });
            Provider.of<ThemaCafeListProvider>(context).setCafeList(cafeList);
            reviewSnapshot.data?.docs.forEach((QueryDocumentSnapshot element) async {
              late String writerNickName;
              await FirebaseFirestore.instance.collection('user').doc(element.get("writerID")).get().then((value) => writerNickName = value["nickname"]);
              if(Provider.of<ReviewProvider>(context, listen: false).reviewIDCheck(element.id)) {
                Provider.of<ReviewProvider>(context, listen: false).addReview(ReviewModel(element.id, element["text"], element["themaID"], element["writerID"], writerNickName, element["rating"].toDouble()));
              }
            });
            return Scaffold(
              backgroundColor: Colors.white,
              body : Stack(
                children: [
                  Column(
                    children: [
                      Center(
                        child: Text(selectedThema.name, style: themaTitleStyle, overflow: TextOverflow.ellipsis,),
                      ),
                      Padding(
                        padding: imagePadding,
                        child: Center(
                            child: Image.network(
                              selectedThema.poster,
                              height: getPosterImageHeight(context),
                              width: getPosterImageWidth(context),
                            )
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: List.generate(cafeList.length+1,
                              (index) {
                                if (index == 0) {
                                  return const Padding(
                                    padding: EdgeInsets.only(right: 8.0),
                                    child: Text("지점 :"),
                                  );
                                }
                                return Padding(
                                  padding: const EdgeInsets.only(right: 8.0),
                                  child: Text(cafeList[index-1].name),
                                );
                              }
                        ),
                      ),
                      Padding(
                        padding: genreAndDifficultyPadding,
                        child: Container(
                          child: Text("장르 : ${selectedThema.genre}"),
                          alignment: Alignment.centerRight,
                        ),
                      ),
                      Padding(
                        padding: genreAndDifficultyPadding,
                        child: Container(
                          child: Text("난이도 : ${selectedThema.difficulty.toString()}"),
                          alignment: Alignment.centerRight,
                        ),
                      ),
                      Expanded(
                        child: SingleChildScrollView(
                          child: Padding(
                            padding: descriptionPadding,
                            child: Text(selectedThema.description),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(right: 10.0),
                        child: Container(
                          height: 50,
                          alignment: Alignment.bottomRight,
                          child: IconButton(
                            icon: Icon(Icons.calendar_today),
                            onPressed: () {
                              Navigator.push(context, MaterialPageRoute(builder: (context) => ReservationView()));
                            },
                          ),
                        ),
                      ),
                      Container(
                        height: getBottomPaddingHeight(context),
                      ),
                    ],
                  ),
                  ReviewBottomSheet(),
                ],
              ),
            );
          }
        );
      }
    );
  }
}
