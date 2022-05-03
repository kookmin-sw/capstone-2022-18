import 'dart:convert';

import 'package:bangmoa/src/provider/reserveInfoProvider.dart';
import 'package:bangmoa/src/provider/userLoginStatusProvider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_multi_formatter/flutter_multi_formatter.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

class ReserveInfoInputView extends StatefulWidget {
  const ReserveInfoInputView({Key? key}) : super(key: key);

  @override
  State<ReserveInfoInputView> createState() => _ReserveInfoInputViewState();
}

class _ReserveInfoInputViewState extends State<ReserveInfoInputView> {
  String dropdownValue = '2';
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();

  void reserveButtonCheck() {
    if (_nameController.text.isEmpty) {
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              content: const Text(
                  "예약자 성함을 입력해주세요."
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text("ok"),
                )
              ],
            );
          }
      );
    } else if (_phoneController.text.isEmpty) {
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              content: const Text(
                  "전화번호를 입력해주세요."
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text("ok"),
                )
              ],
            );
          }
      );
    } else {
      reserveButtonAction();
    }
  }
  void reserveButtonAction() async {
    ReserveInfoProvider infoProvider = Provider.of<ReserveInfoProvider>(context, listen: false);
    UserLoginStatusProvider userProvider = Provider.of<UserLoginStatusProvider>(context, listen: false);
    http.Response _res = await http.post(
        Uri.parse("http://3.39.80.150:5000/reservation/add"),
        body: json.encode(
            {
              "theme_id" : infoProvider.getTheme.id,
              "user_id" : userProvider.getUserID,
              "date" : infoProvider.getDate,
              "time" : infoProvider.getTime,
              "user_count" : dropdownValue,
              "user_name" : _nameController.text,
              "user_phone" : _phoneController.text,
            }
        ),
        headers: {"Content-Type": "application/json"}
    );
    var body = json.decode(_res.body);
    if (body["result"] == "true") {
      Navigator.pop(context);
    }
    else {
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              content: const Text("예약에 실패하였습니다."),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text("ok"),
                )
              ],
            );
          }
      );
    }
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    ReserveInfoProvider infoProvider = Provider.of<ReserveInfoProvider>(context);
    return Scaffold(
      backgroundColor: Colors.black,
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          children: [
            SizedBox(
              height: 40,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset("asset/image/bangmoaLogo.png", height: 40, width: 40, fit: BoxFit.fill,),
                  const Text("방탈출 모아", style: TextStyle(fontSize: 17, fontFamily: 'POP', color: Colors.white),),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(6.0),
              child: Container(
                decoration: const BoxDecoration(
                  color: Colors.white,
                ),
                width: MediaQuery.of(context).size.width,
                child: Column(
                  children: [
                   const Text("예약정보", style: TextStyle(fontSize: 20),),
                    Padding(
                      padding: const EdgeInsets.all(6.0),
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(6.0),
                            child: SizedBox(
                              child: ClipRRect(
                                child: Image.network(infoProvider.getTheme.poster, fit: BoxFit.fill),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              height: 200,
                              width: MediaQuery.of(context).size.width-36.0,
                            ),
                          ),
                          Row(
                            children: [
                              Container(
                                child: const Text("예약일", textAlign: TextAlign.center),
                                alignment: Alignment.center,
                                width: (MediaQuery.of(context).size.width-30.0)*0.3,
                                height: 50,
                                decoration: BoxDecoration(
                                  color: Colors.grey,
                                  border: Border.all(color: Colors.black),
                                ),
                              ),
                              Container(
                                child: Text(infoProvider.getDate, textAlign: TextAlign.center),
                                alignment: Alignment.center,
                                width: (MediaQuery.of(context).size.width-30.0)*0.7,
                                height: 50,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  border: Border.all(color: Colors.black),
                                ),
                              ),
                            ],
                            mainAxisAlignment : MainAxisAlignment.center,
                          ),
                          Row(
                            children: [
                              Container(
                                child: const Text("지점", textAlign: TextAlign.center),
                                alignment: Alignment.center,
                                width: (MediaQuery.of(context).size.width-30.0)*0.3,
                                height: 50,
                                decoration: BoxDecoration(
                                  color: Colors.grey,
                                  border: Border.all(color: Colors.black),
                                ),
                              ),
                              Container(
                                child: Text(infoProvider.getManager.name, textAlign: TextAlign.center, overflow: TextOverflow.ellipsis),
                                alignment: Alignment.center,
                                width: (MediaQuery.of(context).size.width-30.0)*0.7,
                                height: 50,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  border: Border.all(color: Colors.black),
                                ),
                              ),
                            ],
                            mainAxisAlignment : MainAxisAlignment.center,
                          ),
                          Row(
                            children: [
                              Container(
                                child: const Text("예약시간", textAlign: TextAlign.center,),
                                alignment: Alignment.center,
                                width: (MediaQuery.of(context).size.width-30.0)*0.3,
                                height: 50,
                                decoration: BoxDecoration(
                                  color: Colors.grey,
                                  border: Border.all(color: Colors.black),
                                ),
                              ),
                              Container(
                                child: Text(infoProvider.getTime, textAlign: TextAlign.center,),
                                alignment: Alignment.center,
                                width: (MediaQuery.of(context).size.width-30.0)*0.7,
                                height: 50,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  border: Border.all(color: Colors.black),
                                ),
                              ),
                            ],
                            mainAxisAlignment : MainAxisAlignment.center,
                          ),
                          Row(
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                  color: Colors.grey,
                                  border: Border.all(color: Colors.black),
                                ),
                                child: const Text("예약테마", textAlign: TextAlign.center,),
                                alignment: Alignment.center,
                                width: (MediaQuery.of(context).size.width-30.0)*0.3,
                                height: 50,
                              ),
                              Container(
                                child: Text(infoProvider.getTheme.name, textAlign: TextAlign.center, overflow: TextOverflow.ellipsis),
                                alignment: Alignment.center,
                                width: (MediaQuery.of(context).size.width-30.0)*0.7,
                                height: 50,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  border: Border.all(color: Colors.black),
                                ),
                              ),
                            ],
                            mainAxisAlignment : MainAxisAlignment.center,
                          ),
                          Row(
                            mainAxisAlignment : MainAxisAlignment.center,
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                  color: Colors.grey,
                                  border: Border.all(color: Colors.black),
                                ),
                                width: (MediaQuery.of(context).size.width-30.0)*0.3,
                                height: 50,
                                child: const Padding(
                                  padding: EdgeInsets.all(8.0),
                                  child: Text("인원", textAlign: TextAlign.center,)
                                ),
                              ),
                              Container(
                                width: (MediaQuery.of(context).size.width-30.0)*0.7,
                                height: 50,
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  border: Border.all(color: Colors.black),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: DropdownButton<String>(
                                    value: dropdownValue,
                                    icon: const Icon(Icons.arrow_downward),
                                    elevation: 16,
                                    style: const TextStyle(color: Colors.deepPurple),
                                    underline: Container(
                                      height: 2,
                                      color: Colors.deepPurpleAccent,
                                    ),
                                    onChanged: (String? newValue) {
                                      setState(() {
                                        dropdownValue = newValue!;
                                      });
                                    },
                                    items: <String>['2', '3', '4', '5', '6']
                                        .map<DropdownMenuItem<String>>((String value) {
                                      return DropdownMenuItem<String>(
                                        value: value,
                                        child: Text(value),
                                      );
                                    }).toList(),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              Container(
                                child: const Text("예약자 성함", textAlign: TextAlign.center,),
                                alignment: Alignment.center,
                                width: (MediaQuery.of(context).size.width-30.0)*0.3,
                                height: 50,
                                decoration: BoxDecoration(
                                  color: Colors.grey,
                                  border: Border.all(color: Colors.black),
                                ),
                              ),
                              Container(
                                child: TextField(
                                  controller: _nameController,
                                  decoration: const InputDecoration(
                                    hintText: "예약자 성함을 입력해주세요."
                                  ),
                                ),
                                alignment: Alignment.center,
                                width: (MediaQuery.of(context).size.width-30.0)*0.7,
                                height: 50,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  border: Border.all(color: Colors.black),
                                ),
                              ),
                            ],
                            mainAxisAlignment : MainAxisAlignment.center,
                          ),
                          Row(
                            children: [
                              Container(
                                child: const Text("전화번호", textAlign: TextAlign.center,),
                                alignment: Alignment.center,
                                width: (MediaQuery.of(context).size.width-30.0)*0.3,
                                height: 50,
                                decoration: BoxDecoration(
                                  color: Colors.grey,
                                  border: Border.all(color: Colors.black),
                                ),
                              ),
                              Container(
                                child: TextField(
                                  controller: _phoneController,
                                  decoration: const InputDecoration(
                                      hintText: "전화번호를 입력해주세요."
                                  ),
                                  inputFormatters: [
                                    MaskedInputFormatter('###-####-####')
                                  ],
                                  keyboardType: TextInputType.number,
                                ),
                                alignment: Alignment.center,
                                width: (MediaQuery.of(context).size.width-30.0)*0.7,
                                height: 50,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  border: Border.all(color: Colors.black),
                                ),
                              ),
                            ],
                            mainAxisAlignment : MainAxisAlignment.center,
                          ),
                          Row(
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                  color: Colors.grey,
                                  border: Border.all(color: Colors.black),
                                ),
                                child: const Text("총 금액", textAlign: TextAlign.center,),
                                alignment: Alignment.center,
                                width: (MediaQuery.of(context).size.width-30.0)*0.3,
                                height: 50,
                              ),
                              Container(
                                child: Text((infoProvider.getCost*int.parse(dropdownValue)).toString() + "원", textAlign: TextAlign.center, overflow: TextOverflow.ellipsis),
                                alignment: Alignment.center,
                                width: (MediaQuery.of(context).size.width-30.0)*0.7,
                                height: 50,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  border: Border.all(color: Colors.black),
                                ),
                              ),
                            ],
                            mainAxisAlignment : MainAxisAlignment.center,
                          ),
                        ],
                        mainAxisAlignment : MainAxisAlignment.center,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(right: 10.0),
                      child: Container(
                        alignment: Alignment.bottomRight,
                        child: TextButton(
                          style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all(Colors.indigo),

                          ),
                          child: const Text("예약하기", style: TextStyle(color: Colors.white),),
                          onPressed: () {
                            reserveButtonCheck();
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
