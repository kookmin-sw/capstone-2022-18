// 메인페이지의 상단 검색조건 패널
// 지역검색으로 되어있지만 종합검색으로 변경해야함.

import 'package:flutter/material.dart';

class SearchConditionMenuWidget extends StatefulWidget {
  const SearchConditionMenuWidget({Key? key}) : super(key: key);

  @override
  _SearchConditionMenuWidgetState createState() => _SearchConditionMenuWidgetState();
}

class _SearchConditionMenuWidgetState extends State<SearchConditionMenuWidget> {
  bool _expanded = false;
  int _selectedIndex = 0;
  Map<String, List<String>> regionMapping = {
    "홍대" : ["홍대", "마포구"],
    "신촌" : ["신촌", "서대문구"],
    "강남" : ["강남", "강남구", "서초구"],
    "건대" : ["건대", "광진구"],
    "대학로" : ["대학로", "혜화", "종로구"],
    "명동" : ["명동"],
    "부산" : ["부산", "서면", "해운대"],
    "인천" : ["인천", "부천"],
    "대구" : ["대구", "동성로"],
  };
  List<String> regionList = ["전체", "홍대", "신촌", "강남", "건대", "대학로", "명동", "부산", "인천", "대구", "기타"];

  @override
  Widget build(BuildContext context) {
    return ExpansionPanelList(
      children: [
        ExpansionPanel(
          headerBuilder: (BuildContext context, bool isOpen) {
            return const Padding(
                padding: EdgeInsets.only(left: 10.0),
                child: Text("지역 검색", style: TextStyle(fontSize: 30),),
              );
          },
          body: Container(
                height: 200,
                child: ListView.builder(
                  itemCount: regionList.length,
                  itemBuilder: (BuildContext context, int index) {
                    return ListTile(
                      title: Text(regionList[index]),
                      tileColor: _selectedIndex == index? Colors.blue : null,
                      onTap: () {
                        setState(() {
                          _selectedIndex = index;
                        });
                      },
                    );
                  }
                ),
              ),
          isExpanded: _expanded,
          canTapOnHeader: true,
        )
      ],
      expansionCallback: (panelIndex, isExpand) {
        _expanded = !_expanded;
        setState(() {

        });
      },
    );
  }
}
