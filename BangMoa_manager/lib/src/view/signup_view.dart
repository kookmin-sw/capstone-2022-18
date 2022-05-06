import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;

import '../provider/login_status_provider.dart';


class SignUpView extends StatefulWidget{
  const SignUpView({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _SignUpViewState();

}

class _SignUpViewState extends State<SignUpView> {
  final TextEditingController _idController = TextEditingController();
  final TextEditingController _pwController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();

  void showAlertDialog(String text) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            content: Text(text),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text("ok"),
              ),
            ],
          );
        }
    );
  }

  void onClickSubmitButton() async {
    if (_idController.text.isEmpty) {
      showAlertDialog("올바른 ID를 입력해야 합니다.");
    }
    else if (_pwController.text.isEmpty) {
      showAlertDialog("올바른 PW를 입력해야 합니다.");
    }
    else if (_nameController.text.isEmpty) {
      showAlertDialog("올바른 카페이름을 입력해야 합니다.");
    }
    else if (_addressController.text.isEmpty) {
      showAlertDialog("올바른 주소를 입력해야 합니다.");
    }
    else if (_phoneController.text.isEmpty) {
      showAlertDialog("올바른 전화번호를 입력해야 합니다.");
    } else {
      String hashedPW = sha256.convert(utf8.encode(_pwController.text)).toString();

      http.Response response = await http.post(
          Uri.parse(LoginStatusProvider.baseURL + '/signup/manager'),
          headers: <String, String> {'Content-Type': 'application/json'},
          body: json.encode({
            'id': _idController.text,
            'pw': hashedPW,
            'name' : _nameController.text,
            'address' : _addressController.text,
            'phone' : _phoneController.text,
          })
      );
      if(json.decode(response.body)['result'] == 'true') {
        Navigator.pop(context);
      } else if(json.decode(response.body)['result'] == 'false') {
        // 동일한 이름의 id가 존재할 경우 경고 출력
        showAlertDialog("이미 존재하는 ID입니다.");
      }
    }
  }

  Widget buildTextInputField(String name, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(border: const OutlineInputBorder(), labelText: name),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          children: [
            const SizedBox(height: 20),
            const Text("회원정보"),
            const SizedBox(height: 20),
            buildTextInputField('ID', _idController),
            TextField(
              controller: _pwController,
              decoration: const InputDecoration(
                  labelText: 'PW',
                  border: OutlineInputBorder()
              ),
              obscureText: true,
            ),
            const SizedBox(height: 20),
            const Text("카페정보"),
            const SizedBox(height: 20),
            buildTextInputField('카페 이름', _nameController),
            buildTextInputField('주소', _addressController),
            buildTextInputField('전화번호', _phoneController),
            ElevatedButton(child: const Text('Submit'), onPressed: onClickSubmitButton),
          ],
        ),
      ),
    );
  }

}