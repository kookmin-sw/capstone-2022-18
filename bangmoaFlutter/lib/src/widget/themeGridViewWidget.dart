// 메인페이지에 테마들을 보여주는 그리드뷰 위젯.

import 'package:bangmoa/src/const/mainViewConst.dart';
import 'package:bangmoa/src/models/BMTheme.dart';
import 'package:bangmoa/src/widget/themeGridTileWidget.dart';
import 'package:flutter/material.dart';

class ThemeGridViewWidget extends StatefulWidget {
  final List<BMTheme> themeList;
  final double viewHeight;
  final String viewText;
  const ThemeGridViewWidget({Key? key, required this.themeList, required double this.viewHeight, required this.viewText}) : super(key: key);

  @override
  _ThemeGridViewWidgetState createState() => _ThemeGridViewWidgetState();
}

class _ThemeGridViewWidgetState extends State<ThemeGridViewWidget> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: widget.viewHeight,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Text(widget.viewText, style: TextStyle(fontSize: 15, color: themeGridViewStringColor),),
          ),
          Expanded(
            child: GridView.builder(
              itemCount: widget.themeList.length,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: themeGridViewDelegate,
              itemBuilder: (BuildContext context, int index) {
                return ThemeGridTileWidget(thema: widget.themeList[index]);
              }
            ),
          ),
        ],
      ),
    );
  }
}
