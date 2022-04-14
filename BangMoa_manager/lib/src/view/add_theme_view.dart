import 'package:flutter/material.dart';

class AddThemeView extends StatefulWidget{
  const AddThemeView({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _AddThemeViewState();
}

class _AddThemeViewState extends State<AddThemeView> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  @override
  Widget build(BuildContext context) {
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
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('테마 이름'),
          TextField(
            controller: _nameController,
            decoration: const InputDecoration(border: OutlineInputBorder()),
          ),
          const SizedBox(height: 20,),
          const Text('설명'),
          TextField(
            controller: _descriptionController,
            decoration: const InputDecoration(border: OutlineInputBorder()),
          ),
        ],
      ),
    );
  }

}