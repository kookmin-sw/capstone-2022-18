import 'package:bangmoa_manager/src/provider/selected_image_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AddThemeView extends StatefulWidget{
  const AddThemeView({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _AddThemeViewState();
}

class _AddThemeViewState extends State<AddThemeView> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _genreController = TextEditingController();
  int _difficulty = 1;
  int _minPlayer = 1;
  int _maxPlayer = 6;
  late bool isPosterSelected;

  Widget buildTextInputField(String name, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(border: const OutlineInputBorder(), labelText: name),
      ),
    );
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
        title: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            ElevatedButton(
              child: const Text('취소'),
              onPressed: () => Navigator.pop(context), )
          ],
        ),
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: Center(child: Text("테마 정보")),
            ),
            buildTextInputField("테마 이름", _nameController),
            buildTextInputField("설명", _descriptionController),
            buildTextInputField("장르", _genreController),
            const Text('추천인원'),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                DropdownButton(
                    hint: const Text("난이도"),
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
                    hint: const Text("난이도"),
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
                const Text("명"),
              ],
            ),
            const SizedBox(height: 20,),
            const Text('난이도'),
            DropdownButton(
              hint: const Text("난이도"),
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
            const Text("포스터"),
            InkWell(
              child: isPosterSelected?
              SizedBox(
                height: MediaQuery.of(context).size.height*0.3,
                width: MediaQuery.of(context).size.width,
                child: Image.file(context.read<SelectedImageProvider>().getImage, fit: BoxFit.fill),
              ):
              Container(
                height: MediaQuery.of(context).size.height*0.3,
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.black),
                ),
              ),
              onTap: () {
                Navigator.pushNamed(context, '/selectposter');
              },
            ),
            Center(child: ElevatedButton(child: const Text('Submit'), onPressed: () {})),
          ],
        ),
      ),
    );
  }

}