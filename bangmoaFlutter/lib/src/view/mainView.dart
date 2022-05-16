// 앱의 메인이 되는 방탈출 테마 리스트를 그리드형태로 보여주는 페이지
// 하단 NavigationBar 도 포함.
// 상단 검색조건은 searchConditionMenuWidget 으로, 중간의 그리드뷰는 themeGridViewWidget 으로 연결.

import 'package:bangmoa/src/const/commonConst.dart';
import 'package:bangmoa/src/models/BMTheme.dart';
import 'package:bangmoa/src/provider/serchTextProvider.dart';
import 'package:bangmoa/src/provider/themeProvider.dart';
import 'package:bangmoa/src/provider/userLoginStatusProvider.dart';
import 'package:bangmoa/src/view/searchResultView.dart';
import 'package:bangmoa/src/view/userProfileView.dart';
import 'package:bangmoa/src/widget/recommendThemeWidget.dart';
import 'package:bangmoa/src/widget/themeGridViewWidget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MainView extends StatefulWidget {
  const MainView({Key? key}) : super(key: key);

  @override
  _MainViewState createState() => _MainViewState();
}

class _MainViewState extends State<MainView> {
  List<BMTheme> recommendList = [];
  List<String> _recommendIDList = [];
  final textController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    List<BMTheme> _themeList = Provider.of<ThemeProvider>(context).getThemeList;
    if (context.read<UserLoginStatusProvider>().getLogin) {
      _recommendIDList = context.read<UserLoginStatusProvider>().getRecommend;
    }
    for (var element in _themeList) {
      if (_recommendIDList.contains(element.id)) {
        recommendList.add(element);
      }
    }
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) => const UserProfileView()));
        },
        child: const Icon(Icons.person),
      ),
      backgroundColor: Colors.black,
      body: SingleChildScrollView(
        child: Column(
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
            TextField(
              controller: textController,
              keyboardType: TextInputType.text,
              style: const TextStyle(color: Colors.white),
              decoration: const InputDecoration(
                hintText: "테마 검색",
                hintStyle: TextStyle(color: Colors.white),
                border: InputBorder.none,
                icon: Padding(
                  padding: EdgeInsets.only(left: 13),
                  child: Icon(Icons.search, color: Colors.white),
                )
              ),
              onEditingComplete: () {
                if (textController.value.text.isEmpty) {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        content: const Text("정확한 검색어를 입력해주세요."),
                        actions: [
                          TextButton(onPressed: () {Navigator.pop(context);}, child: const Text("close"))
                        ],
                      );
                    }
                  );
                } else {
                  Provider.of<SearchTextProvider>(context, listen: false).setSearchText(textController.value.text);
                  Navigator.push(context, MaterialPageRoute(builder: (context) => const SearchResultView(),));
                  textController.clear();
                }
              },
            ),
            recommendList.isNotEmpty?recommendThemeWidget(context, recommendList):Container(),
            ThemeGridViewWidget(themeList: _themeList, viewHeight: 320, viewText: "전체 테마"),
          ],
        ),
        scrollDirection: Axis.vertical,
      ),
    );
  }
}
