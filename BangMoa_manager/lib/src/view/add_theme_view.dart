import 'package:bangmoa_manager/src/function/theme_info_function.dart';
import 'package:bangmoa_manager/src/provider/login_status_provider.dart';
import 'package:bangmoa_manager/src/provider/selected_image_provider.dart';
import 'package:bangmoa_manager/src/provider/theme_info_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:http_parser/http_parser.dart';

import 'package:http/http.dart' as http;

class AddThemeView extends StatefulWidget{
  const AddThemeView({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _AddThemeViewState();
}

class _AddThemeViewState extends State<AddThemeView> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _genreController = TextEditingController();
  final TextEditingController _costController = TextEditingController();
  final TextEditingController _runningTimeController = TextEditingController();
  int _difficulty = 1;
  int _minPlayer = 1;
  int _maxPlayer = 6;
  int _hour = 24;
  int _minute = 0;
  late bool isPosterSelected;
  bool bookable = true;
  List<String> timeList = [];

  void addButtonAction() {
    String hour = _hour.toString();
    String minute = _minute.toString();
    if (hour.length == 1) {
      hour = '0'+hour;
    }
    if (minute.length == 1) {
      minute = '0'+minute;
    }
    String time = hour + ':' + minute;
    if (!timeList.contains(time)) {
      timeList.add(time);
      timeList.sort();
      setState(() {

      });
    }
  }

  Future<void> submitButtonAction() async {
    var request = http.MultipartRequest("POST", Uri.parse(LoginStatusProvider.baseURL + "/theme/add"));

    request.fields['name'] = _nameController.text;
    request.fields['genre'] = _genreController.text;
    request.fields['description'] = _descriptionController.text;
    request.fields['cost'] = _costController.text;
    request.fields['players'] = _minPlayer.toString() + "~" + _maxPlayer.toString() + " players";
    request.fields['difficulty'] = _difficulty.toString();
    request.fields['timetable'] = timeList.toString();
    request.fields['runningtime'] = _runningTimeController.text;
    request.fields['manager_id'] = context.read<LoginStatusProvider>().getId;
    request.fields['bookable'] = bookable.toString();
    request.files.add(await http.MultipartFile.fromPath('poster' ,context.read<SelectedImageProvider>().getImage.path, contentType: MediaType('image', context.read<SelectedImageProvider>().getImage.path.split('.').last)));
    var response = await request.send();
    context.read<ThemeInfoProvider>().resetState();
    if (response.statusCode == 200) {
      setState(() {

      });
      Navigator.pop(context);
    }
  }

  @override
  void initState() {
    Provider.of<SelectedImageProvider>(context, listen: false).reset();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    isPosterSelected = Provider.of<SelectedImageProvider>(context).getSelectedState;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text("?????? ??????")
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("?????????"),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: InkWell(
                child: isPosterSelected?
                SizedBox(
                  height: MediaQuery.of(context).size.width,
                  width: MediaQuery.of(context).size.width,
                  child: Image.file(context.read<SelectedImageProvider>().getImage, fit: BoxFit.fill),
                ):
                Container(
                  height: 300,
                  width: 300,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                  ),
                  child: const Icon(Icons.add, color: Colors.grey),
                ),
                onTap: () {
                  posterSelectAction(context);
                },
              ),
            ),
            const SizedBox(height: 20,),
            buildTextInputField("?????? ??????", _nameController),
            buildTextInputField("??????", _descriptionController),
            buildTextInputField("??????", _genreController),
            Row(
              children: [
                Flexible(child: buildNumberInputField("??????", _costController)),
                const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text("???", style: TextStyle(fontSize: 30)),
                ),
              ],
            ),
            Row(
              children: [
                Flexible(child: buildNumberInputField("????????????", _runningTimeController)),
                const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text("???", style: TextStyle(fontSize: 30)),
                ),
              ],
            ),
            const Text('????????????'),
            Row(
              children: [
                DropdownButton(
                    hint: const Text("????????????"),
                    items: <int>[1, 2, 3, 4, 5, 6].map((int value) {
                      return DropdownMenuItem<int>(
                        child: Text(value.toString()),
                        value: value,
                      );
                    }).toList(),
                    value: _minPlayer,
                    onChanged: (int? newValue) {
                      setState(() {
                        _minPlayer = newValue!;
                      });
                    }
                ),
                const Text("~"),
                DropdownButton(
                    hint: const Text("????????????"),
                    items: <int>[1, 2, 3, 4, 5, 6].map((int value) {
                      return DropdownMenuItem<int>(
                        child: Text(value.toString()),
                        value: value,
                      );
                    }).toList(),
                    value: _maxPlayer,
                    onChanged: (int? newValue) {
                      setState(() {
                        _maxPlayer = newValue!;
                      });
                    }
                ),
                const Text("???"),
              ],
            ),
            const SizedBox(height: 20,),
            const Text('?????????'),
            DropdownButton(
              hint: const Text("?????????"),
              items: <int>[1, 2, 3, 4, 5].map((int value) {
                return DropdownMenuItem<int>(
                  child: Text(value.toString()),
                  value: value,
                );
              }).toList(),
              value: _difficulty,
              onChanged: (int? newValue) {
                setState(() {
                  _difficulty = newValue!;
                });
              }
            ),
            const SizedBox(height: 20,),
            const Text('?????? ?????? ??????'),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                DropdownButton(
                    hint: const Text("???"),
                    items: List<int>.generate(24, (index) => index+1).map((int value) {
                      return DropdownMenuItem<int>(
                        child: Text(value.toString()),
                        value: value,
                      );
                    }).toList(),
                    value: _hour,
                    onChanged: (int? newValue) {
                      setState(() {
                        _hour = newValue!;
                      });
                    }
                ),
                const Text(":"),
                DropdownButton(
                    hint: const Text("???"),
                    items: List<int>.generate(60, (index) => index).map((int value) {
                      return DropdownMenuItem<int>(
                        child: Text(value.toString()),
                        value: value,
                      );
                    }).toList(),
                    value: _minute,
                    onChanged: (int? newValue) {
                      setState(() {
                        _minute = newValue!;
                      });
                    }
                ),
                TextButton(
                  onPressed: addButtonAction,
                  child: const Text("??????"),
                ),
                Expanded(child: Container()),
                const Text('?????? ?????? ??????'),
                Switch(
                    value: bookable,
                    onChanged: (value) {
                      setState(() {
                        bookable = value;
                      });
                    }
                ),
              ],
            ),
            SizedBox(
              height: (timeList.length/6).ceil()*50,
              child: GridView.builder(
                physics: const NeverScrollableScrollPhysics(),
                itemCount: timeList.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 6,
                  childAspectRatio: 2,
                  mainAxisSpacing: 6,
                  crossAxisSpacing: 6
                ),
                itemBuilder: (BuildContext context, int index) {
                  return InkWell(
                    onTap: () {
                      timeList.removeAt(index);
                      setState(() {

                      });
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey)
                      ),
                      child: Center(child: Text(timeList[index])),
                    ),
                  );
                },
              ),
            ),
            Center(child: ElevatedButton(child: const Text('Submit'), onPressed: submitButtonAction)),
          ],
        ),
      ),
    );
  }

}