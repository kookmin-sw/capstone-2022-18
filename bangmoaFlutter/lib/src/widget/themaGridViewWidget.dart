// 메인페이지에 테마들을 보여주는 그리드뷰 위젯.

import 'package:bangmoa/src/const/mainViewConst.dart';
import 'package:bangmoa/src/models/themaModel.dart';
import 'package:bangmoa/src/widget/themaGridTileWidget.dart';
import 'package:flutter/material.dart';

class ThemaGridViewWidget extends StatefulWidget {
  final List<Thema> themaList;
  const ThemaGridViewWidget({Key? key, required this.themaList}) : super(key: key);

  @override
  _ThemaGridViewWidgetState createState() => _ThemaGridViewWidgetState();
}

class _ThemaGridViewWidgetState extends State<ThemaGridViewWidget> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 6.0, left: 6.0, right: 6.0),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Text("전체 테마", style: TextStyle(fontSize: 15),),
            ),
            Expanded(
              child: GridView.builder(
                itemCount: widget.themaList.length,
                gridDelegate: themaGridViewDelegate,
                itemBuilder: (BuildContext context, int index) {
                  return ThemaGridTileWidget(thema: widget.themaList[index]);
                }
              ),
            ),
          ],
        ),
      ),
    );
  }
}
