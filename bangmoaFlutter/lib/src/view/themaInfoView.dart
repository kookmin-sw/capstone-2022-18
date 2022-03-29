// 테마 상세정보 페이지
// 테마 설명부분과 하단 댓글 Bottom Sheet 로 구성되어 있음.
// 하단 Bottom Sheet 은 reviewBottomSheet 위젯 사용.

import 'package:bangmoa/src/const/themaInfoViewConst.dart';
import 'package:bangmoa/src/models/cafeModel.dart';
import 'package:bangmoa/src/models/themaModel.dart';
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
      stream: FirebaseFirestore.instance.collection('cafe').where("themes", arrayContains: selectedThema.id).snapshots(),
      builder: (context, AsyncSnapshot<QuerySnapshot> cafeSnapshot) {
        cafeList = [];
        if (cafeSnapshot.hasError) {
          return Text('Error : ${cafeSnapshot.error}');
        }
        if (cafeSnapshot.connectionState == ConnectionState.waiting) {
          return themaInfoViewLoadingIndicator();
        }
        cafeSnapshot.data?.docs.forEach((element) {
          cafeList.add(Cafe.fromDocument(element));
        });
        Provider.of<ThemaCafeListProvider>(context).setCafeList(cafeList);
        return Scaffold(
          backgroundColor: Colors.grey,
          body : Column(
            children: [
              Container(
                height: 40,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset("asset/image/bangmoaLogo.png", height: 40, width: 40, fit: BoxFit.fill,),
                    Text("방탈출 모아", style: TextStyle(fontSize: 17, fontFamily: 'POP'),),
                  ],
                ),
              ),
              Expanded(
                child: SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(6.0),
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(6.0),
                                child: Container(
                                  decoration: BoxDecoration(
                                      color: Colors.white
                                  ),
                                  child: Center(
                                    child: Padding(
                                      padding: const EdgeInsets.all(5.0),
                                      child: Text(selectedThema.name, style: themaTitleStyle, overflow: TextOverflow.ellipsis,),
                                    ),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: imagePadding,
                                child: Center(
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(20),
                                      child: Image.network(
                                        selectedThema.poster,
                                        height: getPosterImageHeight(context),
                                        width: getPosterImageWidth(context),
                                        fit: BoxFit.fill,
                                      ),
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
                              Center(
                                child: Padding(
                                  padding: descriptionPadding,
                                  child: Text(selectedThema.description),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: Colors.grey,
                                    borderRadius: BorderRadius.circular(20)
                                  ),
                                  height: 35,
                                  width: 80,
                                  alignment: Alignment.center,
                                  child: TextButton(
                                    child: Text("예약 확인", style: TextStyle(color: Colors.white),),
                                    onPressed: () {
                                      Navigator.push(context, MaterialPageRoute(builder: (context) => ReservationView()));
                                    },
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      reviewBottomSheet(context),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      }
    );
  }
}
