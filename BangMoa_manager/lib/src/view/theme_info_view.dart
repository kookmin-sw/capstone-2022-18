import 'dart:convert';

import 'package:bangmoa_manager/src/model/theme_model.dart';
import 'package:bangmoa_manager/src/provider/login_status_provider.dart';
import 'package:bangmoa_manager/src/provider/selected_image_provider.dart';
import 'package:bangmoa_manager/src/provider/theme_info_provider.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class ThemeInfoView extends StatefulWidget {
  const ThemeInfoView({Key? key}) : super(key: key);

  @override
  State<ThemeInfoView> createState() => _ThemeInfoViewState();
}

class _ThemeInfoViewState extends State<ThemeInfoView> {
  List<ThemeModel> themeList = [];

  ThemeModel makeThemeModelFromMap(String id, dynamic data) {
    return ThemeModel(
        id,
        data["cost"],
        data["description"],
        data["difficulty"],
        data["genre"],
        data["manager_id"],
        data["name"],
        data["poster"],
        data["runningtime"],
        int.parse(data["players"][0]),
        int.parse(data["players"][2]),
        List.castFrom(data["timetable"]),
        data['bookable']=='true'
    );
  }

  @override
  Widget build(BuildContext context) {
    ThemeInfoProvider infoProvider = Provider.of<ThemeInfoProvider>(context);
    return FutureBuilder(
      future: http.post(
          Uri.parse(LoginStatusProvider.baseURL + '/manager/theme'),
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
          if (!infoProvider.getInitState) {
            themeList = [];
            Map<String, dynamic> data = json.decode(response.data!.body);
            List<String> themeIDs = data.keys.toList();
            themeIDs.forEach((String key) {
              infoProvider.addTheme(makeThemeModelFromMap(key, data[key]));
            });
            print(themeList.length);
            infoProvider.finishInit();
          }
          themeList = infoProvider.getThemeList;
          return Container(
            color: Colors.grey,
            child: ListView.builder(
              itemCount: themeList.length+1,
              itemBuilder: (BuildContext context, int index) {
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: index == themeList.length?
                  Container(
                    color: Colors.white,
                    child: IconButton(
                      onPressed: () => Navigator.pushNamed(context, '/addtheme'),
                      icon: const Icon(Icons.add),
                    ),
                  ):
                  InkWell(
                    child: Container(
                      color: Colors.white,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(themeList[index].name, style: const TextStyle(
                                fontSize: 20
                              )),
                              TextButton(
                                onPressed: () async {
                                  http.Response response = await http.post(
                                      Uri.parse(LoginStatusProvider.baseURL + '/theme/remove'),
                                      headers: <String, String> {'Content-Type': 'application/json'},
                                      body: json.encode({
                                        'id': themeList[index].id,
                                      })
                                  );
                                  setState(() {
                                    themeList.removeAt(index);
                                  });
                                },
                                child: const Text("삭제"),
                              ),
                            ],
                          ),
                          Center(
                            child: SizedBox(
                              width: MediaQuery.of(context).size.width,
                              height: MediaQuery.of(context).size.height*0.3,
                              child: Image.network(themeList[index].poster,fit: BoxFit.fill),
                            ),
                          ),
                          Center(child: Text(themeList[index].description)),
                          Text("장르 : ${themeList[index].genre}"),
                          Text("난이도 : ${themeList[index].difficulty}"),
                          Text("추천인원 : ${themeList[index].minplayer} ~ ${themeList[index].maxplayer}"),
                          Text("플레이시간 : ${themeList[index].runningtime}"),
                        ],
                      ),
                    ),
                    onTap: () {
                      Provider.of<SelectedImageProvider>(context, listen: false).reset();
                      Provider.of<ThemeInfoProvider>(context, listen: false).setTheme(themeList[index]);
                      Navigator.pushNamed(context, '/edittheme');
                    },
                  ),
                );
              }
            ),
          );
        }
      }
    );
  }
}
