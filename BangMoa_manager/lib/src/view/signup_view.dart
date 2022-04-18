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

  void onClickSubmitButton() async {
    String hashedPW = sha256.convert(utf8.encode(_pwController.text)).toString();

    http.Response response = await http.post(
        Uri.parse(LoginStatusProvider.baseURL + '/signup/manager'),
        headers: <String, String> {'Content-Type': 'application/json'},
        body: json.encode({
          'id': _idController.text,
          'pw': hashedPW
        })
    );
    if(json.decode(response.body)['result'] == 'true') {
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          TextField(
            controller: _idController,
            decoration: const InputDecoration(
                labelText: 'ID',
                border: OutlineInputBorder()
            ),
          ),
          const SizedBox(height: 10),
          TextField(
            controller: _pwController,
            decoration: const InputDecoration(
                labelText: 'PW',
                border: OutlineInputBorder()
            ),
            obscureText: true,
          ),
          const SizedBox(height: 20),
          ElevatedButton(child: const Text('Submit'), onPressed: onClickSubmitButton),
        ],
      ),
    );
  }

}