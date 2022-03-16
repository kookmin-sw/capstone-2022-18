// 앱의 메인이 되는 방탈출 테마 리스트를 그리드형태로 보여주는 페이지
// 하단 NavigationBar 도 포함.
// 상단 검색조건은 searchConditionMenuWidget 으로, 중간의 그리드뷰는 themaGridViewWidget 으로 연결.

import 'package:bangmoa/src/const/mainViewConst.dart';
import 'package:bangmoa/src/models/themaModel.dart';
import 'package:bangmoa/src/provider/themaProvider.dart';
import 'package:bangmoa/src/view/userProfileView.dart';
import 'package:bangmoa/src/widget/searchConditionMenuWidget.dart';
import 'package:bangmoa/src/widget/themaGridViewWidget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class mainView extends StatefulWidget {
  const mainView({Key? key}) : super(key: key);

  @override
  _mainViewState createState() => _mainViewState();
}

class _mainViewState extends State<mainView> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    List<Thema> _themaList = Provider.of<ThemaProvider>(context).getThemaList;
    List<Widget> _widgetOption = <Widget>[
      Column(
        children: [
          const SearchConditionMenuWidget(),
          Expanded(child: ThemaGridViewWidget(themaList: _themaList)),
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
}
