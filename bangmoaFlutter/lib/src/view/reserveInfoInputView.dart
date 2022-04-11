import 'package:bangmoa/src/provider/reserveInfoProvider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ReserveInfoInputView extends StatefulWidget {
  const ReserveInfoInputView({Key? key}) : super(key: key);

  @override
  State<ReserveInfoInputView> createState() => _ReserveInfoInputViewState();
}

class _ReserveInfoInputViewState extends State<ReserveInfoInputView> {
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
                      child: Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(right: 6.0),
                            child: SizedBox(
                              child: ClipRRect(
                                child: Image.network(infoProvider.getThema.poster, fit: BoxFit.fill),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              height: 200,
                              width: (MediaQuery.of(context).size.width-30.0)*0.25,
                            ),
                          ),
                          Column(
                            children: [
                              Row(
                                children: [
                                  Container(
                                    child: Text("예약일", textAlign: TextAlign.center),
                                    alignment: Alignment.center,
                                    width: (MediaQuery.of(context).size.width-30.0)*0.25,
                                    height: 50,
                                    decoration: BoxDecoration(
                                      color: Colors.grey,
                                      border: Border.all(color: Colors.black),
                                    ),
                                  ),
                                  Container(
                                    child: Text(infoProvider.getDate, textAlign: TextAlign.center),
                                    alignment: Alignment.center,
                                    width: (MediaQuery.of(context).size.width-30.0)*0.5,
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
                                    width: (MediaQuery.of(context).size.width-30.0)*0.25,
                                    height: 50,
                                    decoration: BoxDecoration(
                                      color: Colors.grey,
                                      border: Border.all(color: Colors.black),
                                    ),
                                  ),
                                  Container(
                                    child: Text(infoProvider.getCafe.name, textAlign: TextAlign.center, overflow: TextOverflow.ellipsis),
                                    alignment: Alignment.center,
                                    width: (MediaQuery.of(context).size.width-30.0)*0.5,
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
                                    width: (MediaQuery.of(context).size.width-30.0)*0.25,
                                    height: 50,
                                    decoration: BoxDecoration(
                                      color: Colors.grey,
                                      border: Border.all(color: Colors.black),
                                    ),
                                  ),
                                  Container(
                                    child: Text(infoProvider.getTime, textAlign: TextAlign.center,),
                                    alignment: Alignment.center,
                                    width: (MediaQuery.of(context).size.width-30.0)*0.5,
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
                                    width: (MediaQuery.of(context).size.width-30.0)*0.25,
                                    height: 50,
                                  ),
                                  Container(
                                    child: Text(infoProvider.getThema.name, textAlign: TextAlign.center, overflow: TextOverflow.ellipsis),
                                    alignment: Alignment.center,
                                    width: (MediaQuery.of(context).size.width-30.0)*0.5,
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
                          )
                        ],
                      ),
                    )
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
