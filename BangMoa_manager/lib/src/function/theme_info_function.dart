import 'package:flutter/material.dart';

Widget buildTextInputField(String name, TextEditingController controller) {
  return Padding(
    padding: const EdgeInsets.only(bottom: 20),
    child: TextField(
      controller: controller,
      decoration: InputDecoration(border: const OutlineInputBorder(), labelText: name),
    ),
  );
}

Widget buildNumberInputField(String name, TextEditingController controller) {
  return Padding(
    padding: const EdgeInsets.only(bottom: 20),
    child: TextField(
      keyboardType: TextInputType.number,
      controller: controller,
      decoration: InputDecoration(labelText: name),
    ),
  );
}

void posterSelectAction(BuildContext context) {
  Navigator.pushNamed(context, '/selectposter');
}

