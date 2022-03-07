import 'package:flutter/material.dart';

class SearchConditionMenuWidget extends StatefulWidget {
  const SearchConditionMenuWidget({Key? key}) : super(key: key);

  @override
  _SearchConditionMenuWidgetState createState() => _SearchConditionMenuWidgetState();
}

class _SearchConditionMenuWidgetState extends State<SearchConditionMenuWidget> {
  bool _expanded = false;
  int _selectedIndex = 0;
  List<String> regionList = ["전체", "홍대", "강남", "신촌", "건대", "대학로", "경기", "대구", "부산", "인천", "기타"];

  @override
  Widget build(BuildContext context) {
    return ExpansionPanelList(
      children: [
        ExpansionPanel(
          headerBuilder: (BuildContext context, bool isOpen) {
            return const Center(
              child: Text("지역 검색", style: TextStyle(fontSize: 30),)
            );
          },
          body: Container(
                height: 200,
                child: ListView.builder(
                  itemCount: 11,
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
