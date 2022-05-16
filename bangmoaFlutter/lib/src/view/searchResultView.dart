import 'package:bangmoa/src/models/BMTheme.dart';
import 'package:bangmoa/src/models/manager.dart';
import 'package:bangmoa/src/provider/managerProvider.dart';
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
  List<Manager> _managerList = [];
  List<String> _selectedManagerList = [];
  List<BMTheme> _fullThemeList = [];
  List<BMTheme> _selectedThemeList = [];
  final textController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    _searchString = Provider.of<SearchTextProvider>(context).getSearchText;
    _managerList = Provider.of<ManagerProvider>(context).getManagerList;
    _fullThemeList = Provider.of<ThemeProvider>(context).getThemeList;
    _selectedManagerList = [];
    _selectedThemeList = [];
    for (var manager in _managerList) {
      if (manager.name.contains(_searchString) || manager.address.contains(_searchString)) {
        _selectedManagerList.add(manager.id);
      }
    }
    for (var theme in _fullThemeList) {
      if (_selectedManagerList.contains(theme.manager_id)) {
        _selectedThemeList.add(theme);
        continue;
      }
      else if (theme.name.contains(_searchString) || theme.description.contains(_searchString) || theme.genre.contains(_searchString)) {
        _selectedThemeList.add(theme);
      }
    }
    return Scaffold(
      backgroundColor: Colors.grey,
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: 40,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset("asset/image/bangmoaLogo.png", height: 40, width: 40, fit: BoxFit.fill,),
                  Text("방탈출 모아", style: TextStyle(fontSize: 17, fontFamily: 'POP'),),
                ],
              ),
            ),
            TextField(
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
            _selectedThemeList.isEmpty ? const Center(child: Text("검색 결과가 없습니다."),):
                ThemeGridViewWidget(themeList: _selectedThemeList, viewHeight: 320, viewText: "${_searchString} 에 대한 검색 결과",)
          ],
        ),
      ),
    );
  }
}
