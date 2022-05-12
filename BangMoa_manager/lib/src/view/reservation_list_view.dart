import 'dart:convert';

import 'package:bangmoa_manager/src/provider/login_status_provider.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class ReservationListView extends StatefulWidget {
  const ReservationListView({Key? key}) : super(key: key);

  @override
  State<ReservationListView> createState() => _ReservationListViewState();
}

class _ReservationListViewState extends State<ReservationListView> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: http.post(
          Uri.parse(LoginStatusProvider.baseURL + '/reservation/manager/status'),
          headers: <String, String> {'Content-Type': 'application/json'},
          body: json.encode({
            'id' : context.read<LoginStatusProvider>().getId,
            'date' : DateFormat('yyyy-MM-dd').format(DateTime.now())
          })
      ),
      builder: (BuildContext context, AsyncSnapshot<http.Response> response) {
        if (response.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (response.hasError) {
          print(response.error);
          return Text(response.error.toString());
        } else {
          var result = json.decode(response.data!.body)["result"];
          return ListView.builder(
            itemCount: result.length,
            scrollDirection: Axis.vertical,
            itemBuilder: (BuildContext context, int index) {
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.black),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Center(
                            child: Text(
                              "${result[index]["date"]!} 예약${index+1}",
                              style: const TextStyle(fontSize: 20),
                            )
                        ),
                        Text("예약 테마 : ${result[index]["theme_name"]!}"),
                        Text("예약 시간 : ${result[index]["time"]!}"),
                        Text("예약 인원 : ${result[index]["user_count"]!}"),
                        Text("예약자 명 : ${result[index]["user_name"]!}"),
                      ],
                    ),
                  ),
                ),
              );
            }
          );
        }
      }
    );
  }
}
