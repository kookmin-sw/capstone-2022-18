import 'package:flutter/material.dart';

class MainView extends StatefulWidget{
  const MainView({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _MainViewState();
}

class _MainViewState extends State<MainView> {
  bool isLoggedIn = false;
  void onClickLoginButton() {
    setState(() {
      isLoggedIn = true;
    });
  }

  Widget _loginView() => Scaffold(
    body: Container(
      padding: const EdgeInsets.all(30),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const TextField(
            decoration: InputDecoration(
              labelText: 'ID',
              border: OutlineInputBorder()
            ),
          ),
          const SizedBox(height: 10),
          const TextField(
            decoration: InputDecoration(
              labelText: 'PW',
              border: OutlineInputBorder()
            ),
            obscureText: true,
          ),
          const SizedBox(height: 20),
          ElevatedButton(child: const Text('Submit'), onPressed: onClickLoginButton)
        ],
      ),
    )
  );

  Widget _mainView() => Scaffold(
    body: Container(
      child:ElevatedButton(
        child: Text('logout'),
        onPressed: () => {
          setState(() {
            isLoggedIn = false;
          })
        },
      )
    ),
  );

  @override
  Widget build(BuildContext context) {
    if(!isLoggedIn) {
      return _loginView();
    }
    return _mainView();
  }
}