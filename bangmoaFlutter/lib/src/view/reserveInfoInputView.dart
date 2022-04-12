import 'package:bangmoa/src/provider/reserveInfoProvider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ReserveInfoInputView extends StatefulWidget {
  const ReserveInfoInputView({Key? key}) : super(key: key);

  @override
  State<ReserveInfoInputView> createState() => _ReserveInfoInputViewState();
}

class _ReserveInfoInputViewState extends State<ReserveInfoInputView> {
  String dropdownValue = '2';

  @override
  Widget build(BuildContext context) {
    ReserveInfoProvider infoProvider = Provider.of<ReserveInfoProvider>(context);
    return Scaffold(
      backgroundColor: Colors.grey,
      body: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Column(
          children: [
            SizedBox(
              height: 40,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset("asset/image/bangmoaLogo.png", height: 40, width: 40, fit: BoxFit.fill,),
                  Text("방탈출 모아", style: TextStyle(fontSize: 17, fontFamily: 'POP'),),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(6.0),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(Radius.circular(20)),
                ),
                width: MediaQuery.of(context).size.width-12.0,
                child: Column(
                  children: [
                   Text("예약정보", style: TextStyle(fontSize: 20),),
                    Padding(
                      padding: const EdgeInsets.all(6.0),
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(6.0),
                            child: SizedBox(
                              child: ClipRRect(
                                child: Image.network(infoProvider.getThema.poster, fit: BoxFit.fill),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              height: 200,
                              width: MediaQuery.of(context).size.width-36.0,
                            ),
                          ),
                          Row(
                            children: [
                              Container(
                                child: Text("예약일", textAlign: TextAlign.center),
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
                                child: Text("지점", textAlign: TextAlign.center),
                                alignment: Alignment.center,
                                width: (MediaQuery.of(context).size.width-30.0)*0.3,
                                height: 50,
                                decoration: BoxDecoration(
                                  color: Colors.grey,
                                  border: Border.all(color: Colors.black),
                                ),
                              ),
                              Container(
                                child: Text(infoProvider.getCafe.name, textAlign: TextAlign.center, overflow: TextOverflow.ellipsis),
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
                                child: Text("예약시간", textAlign: TextAlign.center,),
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
                                child: Text("예약테마", textAlign: TextAlign.center,),
                                alignment: Alignment.center,
                                width: (MediaQuery.of(context).size.width-30.0)*0.3,
                                height: 50,
                              ),
                              Container(
                                child: Text(infoProvider.getThema.name, textAlign: TextAlign.center, overflow: TextOverflow.ellipsis),
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
                            Navigator.pop(context);
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
