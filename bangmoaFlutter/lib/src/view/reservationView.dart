import 'dart:convert';

import 'package:bangmoa/src/provider/selectedThemaProvider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_calendar_carousel/flutter_calendar_carousel.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

class ReservationView extends StatefulWidget {
  const ReservationView({Key? key}) : super(key: key);

  @override
  State<ReservationView> createState() => _ReservationViewState();
}

class _ReservationViewState extends State<ReservationView> {
  DateTime _currentDate = DateTime.now();
  late String _themaID;

  void _requestReserve(DateTime date) async {
    http.Response _res = await http.post(
      Uri.parse(""),
      body: json.encode(
        {
          "id" : _themaID,
          "date" : date,
        }
      ),
      headers: {"Content-Type": "application/json"}
    );
    print('response Body : ' + _res.body);

  }

  @override
  Widget build(BuildContext context) {
    SelectedThemaProvider themaProvider = Provider.of<SelectedThemaProvider>(context);
    _themaID = themaProvider.getSelectedThema.id;

    return Scaffold(
      body: Column(
        children: [
          CalendarCarousel(
            onDayPressed: (DateTime date, List<Widget> events) {
              this.setState(() => _currentDate = date);
            },
            customGridViewPhysics: NeverScrollableScrollPhysics(),
            height: 400,
            selectedDateTime: _currentDate,
          ),
          Padding(
            padding: const EdgeInsets.only(right: 10.0),
            child: Container(
              alignment: Alignment.bottomRight,
              child: TextButton(
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(Colors.indigo),

                ),
                child: Text("예약 검색", style: TextStyle(color: Colors.white),),
                onPressed: () {

                },
              ),
            ),
          )
        ],
      ),
    );
  }
}
