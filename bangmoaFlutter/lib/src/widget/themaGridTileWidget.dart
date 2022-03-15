// 메인페이지의 테마 타일을 만드는 위젯.

import 'package:bangmoa/src/models/themaModel.dart';
import 'package:bangmoa/src/provider/selectedThemaProvider.dart';
import 'package:bangmoa/src/view/themaInfoView.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ThemaGridTileWidget extends StatelessWidget {
  final Thema thema;
  const ThemaGridTileWidget({Key? key, required this.thema}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: InkWell(
        child: Column(
          children: [
            Center(child: Image.network(thema.poster, height: 150,)),
            Padding(
              padding: const EdgeInsets.only(left: 5.0),
              child: Text(thema.name,style: TextStyle(fontSize: 20)),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 5.0),
              child: Text(thema.genre),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 5.0),
              child: Text("난이도 : ${thema.difficulty.toString()}"),
            )
          ],
          crossAxisAlignment: CrossAxisAlignment.start,
        ),
        onTap: () {
          Provider.of<SelectedThemaProvider>(context, listen: false).setSelectedThema(thema);
          Navigator.push(context, MaterialPageRoute(builder: (context) => ThemaInfoView()));
        },
      ),
    );
  }
}
