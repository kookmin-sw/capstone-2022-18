
import 'package:bangmoa/src/models/themaModel.dart';
import 'package:bangmoa/src/provider/selectedThemaProvider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ThemaInfoView extends StatefulWidget {
  const ThemaInfoView({Key? key}) : super(key: key);

  @override
  _ThemaInfoViewState createState() => _ThemaInfoViewState();
}

class _ThemaInfoViewState extends State<ThemaInfoView> {
  late Thema selectedThema;

  @override
  Widget build(BuildContext context) {
    selectedThema = Provider.of<SelectedThemaProvider>(context).getSelectedThema;
    return Scaffold(
      body : Column(
        children: [
          Center(
            child: Text(selectedThema.name, style: TextStyle(fontSize: 30),),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Center(
              child: Image.network(
                selectedThema.poster,
                height: MediaQuery.of(context).size.height*0.3,
                width: MediaQuery.of(context).size.width,
              )
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 10.0),
            child: Container(
              child: Text("장르 : ${selectedThema.genre}"),
              alignment: Alignment.centerRight,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 10.0),
            child: Container(
              child: Text("난이도 : ${selectedThema.difficulty.toString()}"),
              alignment: Alignment.centerRight,
            ),
          ),
          Text(selectedThema.description),
        ],
      ),
    );
  }
}
