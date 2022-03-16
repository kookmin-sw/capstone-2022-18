// 앱의 메인이 되는 방탈출 테마 리스트를 그리드형태로 보여주는 페이지
// 현재는 테마정보를 불러오는곳이지만 카페 추가하면서 Firebase에서 데이터 불러와서 구성하는 부분은 main으로 통합시킬 필요 존재.

import 'package:bangmoa/src/const/mainViewConst.dart';
import 'package:bangmoa/src/models/themaModel.dart';
import 'package:bangmoa/src/provider/themaProvider.dart';
import 'package:bangmoa/src/view/userProfileView.dart';
import 'package:bangmoa/src/widget/searchConditionMenuWidget.dart';
import 'package:bangmoa/src/widget/themaGridViewWidget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class mainView extends StatefulWidget {
  const mainView({Key? key}) : super(key: key);

  @override
  _mainViewState createState() => _mainViewState();
}

class _mainViewState extends State<mainView> {
  List<Thema> themaList = [];
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseFirestore.instance.collection('thema').snapshots(),
      builder: (context, AsyncSnapshot<QuerySnapshot> snapshot1) {
        themaList = [];
        if (snapshot1.hasError) {
          return Text('Error : ${snapshot1.error}');
        }
        if (snapshot1.connectionState == ConnectionState.waiting) {
          return mainViewLoadingIndicator();
        }
        snapshot1.data!.docs.forEach((doc) {
          themaList.add(Thema.fromDocument(doc));
        });
        Provider.of<ThemaProvider>(context, listen: false).initThemaList(themaList);
        List<Widget> _widgetOption = <Widget>[
          Column(
            children: [
              const SearchConditionMenuWidget(),
              Expanded(child: ThemaGridViewWidget(themaList: themaList)),
            ],
          ),
          Container(),
          const UserProfileView()
        ];
        return Scaffold(
          bottomNavigationBar: BottomNavigationBar(
            type: BottomNavigationBarType.fixed,
            backgroundColor: bottomNavigationBackGroundColor,
            selectedItemColor: bottomNavigationSelectedItemColor,
            unselectedItemColor: bottomNavigationUnselectedItemColor,
            selectedFontSize: bottomNavigationSelectedFontSize,
            unselectedFontSize: bottomNavigationUnselectedFontSize,
            currentIndex: _selectedIndex,
            onTap: (int index){
              _onItemTapped(index);
            },
            items: const [
              BottomNavigationBarItem(
                icon: Icon(Icons.description),
                label: "테마정보",
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.wifi),
                label: "커뮤니티"
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.person),
                label: "유저"
              ),
            ],
          ),
          body: _widgetOption[_selectedIndex],
        );
      }
    );
  }
}
