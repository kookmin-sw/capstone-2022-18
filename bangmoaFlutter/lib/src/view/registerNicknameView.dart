// 닉네임 설정을 위한 페이지.
// 닉네임 입력창과 버튼 하나로 구성.
// 버튼 클릭시 입력된 닉네임으로 유저 id를 파이어베이스에 등록.
// 닉네임 변경기능을 추가할 시 뷰 재활용 가능할지 고려해봐야 함.

import 'package:bangmoa/src/provider/userLoginStatusProvider.dart';
import 'package:bangmoa/src/view/mainView.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class RegisterNicknameView extends StatefulWidget {
  const RegisterNicknameView({Key? key}) : super(key: key);

  @override
  State<RegisterNicknameView> createState() => _RegisterNicknameViewState();
}

class _RegisterNicknameViewState extends State<RegisterNicknameView> {
  final TextEditingController _textController = TextEditingController();
  late String? _userID;
  String? _location = "서울";

  @override
  Widget build(BuildContext context) {
    _userID = Provider.of<UserLoginStatusProvider>(context, listen: false).getUserID;
    CollectionReference users = FirebaseFirestore.instance.collection('user');
    return Scaffold(
      appBar: AppBar(
        title: const Text("닉네임 설정"),
      ),
      body: SingleChildScrollView(
        child: SizedBox(
          height: MediaQuery.of(context).size.height*0.9,
          child: Column(
            children: [
              SizedBox(height: MediaQuery.of(context).size.height*0.35,),
              Center(
                child: TextField(
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: "NickName",
                  ),
                  controller: _textController,
                ),
              ),
              SizedBox(height: MediaQuery.of(context).size.height*0.05,),
              Row(
                children: [
                  const Text("지역 : ", style: TextStyle(fontSize: 20)),
                  SizedBox(width: 20),
                  DropdownButton<String>(
                    value: _location,
                    items: <String>["서울", "경기도", "강원도", "충청남도", "충청북도", "경상남도", "경상북도", "전라남도", "전라북도"].map((String value) {
                      return DropdownMenuItem<String>(child: Text(value), value: value,);
                    }).toList(),
                    onChanged: (String? value) {
                      setState(() {
                        _location = value;
                      });
                    }
                  ),
                ],
              ),
              Expanded(child: Container()),
              ElevatedButton(
                onPressed: () {
                  if (_textController.text.isEmpty) {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          content: const Text("닉네임을 입력해주세요."),
                          actions: <Widget>[
                            TextButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: const Text("Close"),
                            ),
                          ],
                        );
                      }
                    );
                  }
                  else {
                    Provider.of<UserLoginStatusProvider>(context, listen: false).setUserNickName(_textController.text);
                    users.doc(_userID).set({"nickname" : _textController.text, "alarms" : [], "recommand" : []});
                    Navigator.pop(context);
                    Navigator.push(context, MaterialPageRoute(builder: (context) => MainView()));
                  }
                },
                child: const Text("완료"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
