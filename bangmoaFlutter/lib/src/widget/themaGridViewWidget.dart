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
    return GridView.builder(
      itemCount: widget.themaList.length,
      gridDelegate: themaGridViewDelegate,
      itemBuilder: (BuildContext context, int index) {
        return ThemaGridTileWidget(thema: widget.themaList[index]);
      }
    );
  }
}
