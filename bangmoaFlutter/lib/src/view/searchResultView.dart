import 'package:bangmoa/src/models/cafeModel.dart';
import 'package:bangmoa/src/models/themaModel.dart';
import 'package:bangmoa/src/provider/cafeProvider.dart';
import 'package:bangmoa/src/provider/serchTextProvider.dart';
import 'package:bangmoa/src/provider/themaProvider.dart';
import 'package:bangmoa/src/widget/themaGridViewWidget.dart';
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
  List<Thema> _fullThemaList = [];
  List<Thema> _selectedThemaList = [];
  final textController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    _searchString = Provider.of<SearchTextProvider>(context).getSearchText;
    _cafeList = Provider.of<CafeProvider>(context).getCafeList;
    _fullThemaList = Provider.of<ThemaProvider>(context).getThemaList;
    _selectedThemaList = [];
    for (var thema in _fullThemaList) {
      if (thema.name.contains(_searchString)) {
        _selectedThemaList.add(thema);
        continue;
      }
      if (thema.description.contains(_searchString)) {
        _selectedThemaList.add(thema);
        continue;
      }
      if (thema.genre.contains(_searchString)) {
        _selectedThemaList.add(thema);
        continue;
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
                decoration: InputDecoration(
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
            _selectedThemaList.isEmpty ? Center(child: Text("검색 결과가 없습니다."),):
                ThemaGridViewWidget(themaList: _selectedThemaList, viewHeight: MediaQuery.of(context).size.height*0.85, viewText: "검색 결과",)
          ],
        ),
      ),
    );
  }
}
