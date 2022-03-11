import 'package:bangmoa/src/models/themaModel.dart';
import 'package:bangmoa/src/provider/themaProvider.dart';
import 'package:bangmoa/src/widget/searchConditionMenuWidget.dart';
import 'package:bangmoa/src/widget/themaGridViewWidget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class mainView extends StatefulWidget {
  const mainView({Key? key}) : super(key: key);

  @override
  _mainViewState createState() => _mainViewState();
}

class _mainViewState extends State<mainView> {
  List<Thema> themaList = [];

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseFirestore.instance.collection('thema').snapshots(),
      builder: (context, AsyncSnapshot<QuerySnapshot> snapshot1) {
        themaList = [];
        if (snapshot1.hasError) {
          return Text('Error : ${snapshot1.error}');
        }
        if (snapshot1.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator(),);
        }
        snapshot1.data!.docs.forEach((doc) {
          themaList.add(Thema.fromDocument(doc));
        });
        Provider.of<ThemaProvider>(context, listen: false).initThemaList(themaList);
        return Scaffold(
          bottomNavigationBar: BottomNavigationBar(
            type: BottomNavigationBarType.fixed,
            backgroundColor: Colors.grey,
            selectedItemColor: Colors.white,
            unselectedItemColor: Colors.white.withOpacity(0.6),
            selectedFontSize: 15,
            unselectedFontSize: 14,
            items: const [
              BottomNavigationBarItem(
                icon: Icon(Icons.description),
                label: "테마정보"
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.calendar_today_outlined),
                label: "예약현황"
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.person),
                label: "유저"
              ),
            ],
          ),
          body: Column(
            children: [
              SearchConditionMenuWidget(),
              Expanded(child: ThemaGridViewWidget(themaList: themaList)),
            ],
          ),
        );
      }
    );
  }
}
