import 'package:bangmoa/src/models/themaModel.dart';
import 'package:bangmoa/src/provider/themaProvider.dart';
import 'package:bangmoa/src/view/userProfileView.dart';
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
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

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
        List<Widget> _widgetOption = <Widget>[
          Column(
            children: [
              const SearchConditionMenuWidget(),
              Expanded(child: ThemaGridViewWidget(themaList: themaList)),
            ],
          ),
          Container(),
          const UserProfileView()
        ];
        return Scaffold(
          bottomNavigationBar: BottomNavigationBar(
            type: BottomNavigationBarType.fixed,
            backgroundColor: Colors.grey,
            selectedItemColor: Colors.white,
            unselectedItemColor: Colors.white.withOpacity(0.6),
            selectedFontSize: 15,
            unselectedFontSize: 14,
            currentIndex: _selectedIndex,
            onTap: (int index){
              _onItemTapped(index);
            },
            items: const [
              BottomNavigationBarItem(
                icon: Icon(Icons.description),
                label: "테마정보",
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.wifi),
                label: "커뮤니티"
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.person),
                label: "유저"
              ),
            ],
          ),
          body: _widgetOption[_selectedIndex],
        );
      }
    );
  }
}
