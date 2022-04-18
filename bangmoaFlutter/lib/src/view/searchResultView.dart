import 'package:bangmoa/src/models/cafeModel.dart';
import 'package:bangmoa/src/models/BMTheme.dart';
import 'package:bangmoa/src/provider/cafeProvider.dart';
import 'package:bangmoa/src/provider/serchTextProvider.dart';
import 'package:bangmoa/src/provider/themeProvider.dart';
import 'package:bangmoa/src/widget/themeGridViewWidget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SearchResultView extends StatefulWidget {
  const SearchResultView({Key? key}) : super(key: key);

  @override
  State<SearchResultView> createState() => _SearchResultViewState();
}

class _SearchResultViewState extends State<SearchResultView> {
  late String _searchString;
  List<Cafe> _cafeList = [];
  List<BMTheme> _fullThemeList = [];
  List<BMTheme> _selectedThemeList = [];
  List<String> _idList = [];
  final textController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    _searchString = Provider.of<SearchTextProvider>(context).getSearchText;
    _cafeList = Provider.of<CafeProvider>(context).getCafeList;
    _fullThemeList = Provider.of<ThemeProvider>(context).getThemeList;
    _selectedThemeList = [];
    for (var cafe in _cafeList) {
      if (cafe.name.contains(_searchString)) {
        for (var id in cafe.themes) {
          if (!_idList.contains(id)) {
            _idList.add(id);
          }
        }
        continue;
      }
      if (cafe.destination.contains(_searchString)) {
        for (var id in cafe.themes) {
          if (!_idList.contains(id)) {
            _idList.add(id);
          }
        }
        continue;
      }
    }
    for (var theme in _fullThemeList) {
      if (theme.name.contains(_searchString)) {
        if (!_idList.contains(theme.id)) {
          _idList.add(theme.id);
        }
        continue;
      }
      if (theme.description.contains(_searchString)) {
        if (!_idList.contains(theme.id)) {
          _idList.add(theme.id);
        }
        continue;
      }
      if (theme.genre.contains(_searchString)) {
        if (!_idList.contains(theme.id)) {
          _idList.add(theme.id);
        }
        continue;
      }
    }
    for (var theme in _fullThemeList) {
      if (_idList.contains(theme.id)) {
        _selectedThemeList.add(theme);
      }
    }
    return Scaffold(
      backgroundColor: Colors.grey,
      body: SingleChildScrollView(
        child: Column(
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
            Container(
              child: TextField(
                controller: textController,
                keyboardType: TextInputType.text,
                decoration: const InputDecoration(
                    hintText: "테마 검색",
                    border: InputBorder.none,
                    icon: Padding(
                      padding: EdgeInsets.only(left: 13),
                      child: Icon(Icons.search),
                    )
                ),
                onEditingComplete: () {
                  Provider.of<SearchTextProvider>(context, listen: false).setSearchText(textController.value.text);
                  Navigator.pop(context);
                  Navigator.push(context, MaterialPageRoute(builder: (context) => SearchResultView(),));
                  textController.clear();
                },
              ),
            ),
            _selectedThemeList.isEmpty ? Center(child: Text("검색 결과가 없습니다."),):
                ThemeGridViewWidget(themeList: _selectedThemeList, viewHeight: MediaQuery.of(context).size.height*0.85, viewText: "${_searchString} 에 대한 검색 결과",)
          ],
        ),
      ),
    );
  }
}
