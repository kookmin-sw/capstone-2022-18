// 테마 상세정보 페이지
// 테마 설명부분과 하단 댓글 Bottom Sheet 로 구성되어 있음.
// 하단 Bottom Sheet 은 reviewBottomSheet 위젯 사용.

import 'package:bangmoa/src/const/commonConst.dart';
import 'package:bangmoa/src/const/themeInfoViewConst.dart';
import 'package:bangmoa/src/models/BMTheme.dart';
import 'package:bangmoa/src/models/manager.dart';
import 'package:bangmoa/src/provider/selectedThemeProvider.dart';
import 'package:bangmoa/src/view/reservationView.dart';
import 'package:bangmoa/src/widget/reviewBottomSheetWidget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ThemeInfoView extends StatefulWidget {
  const ThemeInfoView({Key? key}) : super(key: key);

  @override
  _ThemeInfoViewState createState() => _ThemeInfoViewState();
}

class _ThemeInfoViewState extends State<ThemeInfoView> {
  late BMTheme selectedTheme;
  late Manager manager;

  @override
  Widget build(BuildContext context) {
    selectedTheme = Provider.of<SelectedThemeProvider>(context).getSelectedTheme;
    return StreamBuilder<QuerySnapshot>(
      stream : FirebaseFirestore.instance.collection('manager').where("id", isEqualTo: selectedTheme.manager_id).snapshots(),
      builder: (context, AsyncSnapshot<QuerySnapshot> managerSnapshot) {
        if (managerSnapshot.hasError) {
          return Text('Error : ${managerSnapshot.error}');
        }
        if (managerSnapshot.connectionState == ConnectionState.waiting) {
          return themeInfoViewLoadingIndicator();
        }
        manager = Manager.fromDocument(managerSnapshot.data!.docs.first);
        return Scaffold(
          backgroundColor: Colors.black,
          body : Column(
            children: [
              SizedBox(
                height: appBarSize,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset("asset/image/bangmoaLogo.png", height: logoHeight, width: logoWidth, fit: BoxFit.fill,),
                    const Text("방탈출 모아", style: TextStyle(fontSize: titleSize, fontFamily: 'POP', color: Colors.white),),
                  ],
                ),
              ),
              Expanded(
                child: SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: Column(
                    children: [
                      Container(
                        color: Colors.white,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Center(
                                child: ClipRRect(
                                  child: Image.network(
                                    selectedTheme.poster,
                                    height: getPosterImageHeight(context),
                                    width: getPosterImageWidth(context),
                                    fit: BoxFit.fill,
                                  ),
                                )
                            ),
                            Padding(
                              padding: const EdgeInsets.all(6.0),
                              child: Center(
                                child: Padding(
                                  padding: const EdgeInsets.all(5.0),
                                  child: Text(selectedTheme.name, style: const TextStyle(fontSize: themeTitleSize), overflow: TextOverflow.ellipsis, ),
                                ),
                              ),
                            ),
                            Text("지점 : "),
                            Padding(
                              padding: const EdgeInsets.only(right: 10.0),
                              child: Container(
                                child: Text("장르 : ${selectedTheme.genre}"),
                                alignment: Alignment.centerRight,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(right: 10.0),
                              child: Container(
                                child: Text("난이도 : ${selectedTheme.difficulty.toString()}"),
                                alignment: Alignment.centerRight,
                              ),
                            ),
                            Center(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(selectedTheme.description),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.grey,
                                  borderRadius: BorderRadius.circular(5)
                                ),
                                height: reservationButtonHeight,
                                width: reservationButtonWidth,
                                alignment: Alignment.center,
                                child: TextButton(
                                  child: const Text("예약 확인", style: TextStyle(color: Colors.white),),
                                  onPressed: () {
                                    Provider.of<SelectedThemeProvider>(context, listen: false).setManager(manager);
                                    Navigator.push(context, MaterialPageRoute(builder: (context) => const ReservationView()));
                                  },
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: intervalSize,
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
