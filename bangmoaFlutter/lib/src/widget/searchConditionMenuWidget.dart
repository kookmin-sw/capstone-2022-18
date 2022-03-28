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
  List<String> regionList = ["전체", "홍대", "신촌", "강남", "건대", "대학로", "명동", "부산", "인천", "대구", "기타"];

  @override
  Widget build(BuildContext context) {
    return ExpansionPanelList(
      children: [
        ExpansionPanel(
          backgroundColor: Colors.amberAccent,
          headerBuilder: (BuildContext context, bool isOpen) {
            return const Padding(
                padding: EdgeInsets.all(10.0),
                child: Text("검색", style: TextStyle(fontSize: 20),),
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
