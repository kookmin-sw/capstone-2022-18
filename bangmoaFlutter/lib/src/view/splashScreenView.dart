import 'dart:async';

import 'package:bangmoa/src/view/mainView.dart';
import 'package:flutter/material.dart';

class SplashScreenView extends StatefulWidget {
  const SplashScreenView({Key? key}) : super(key: key);

  @override
  State<SplashScreenView> createState() => _SplashScreenViewState();
}

class _SplashScreenViewState extends State<SplashScreenView> {
  final String logoImage = 'lib/asset/bangmoaLogo.png';

  @override
  void initState() {
    super.initState();
    Timer(Duration(milliseconds: 1500), () {
      Navigator.push(context, MaterialPageRoute(builder: (context) => mainView()));
    });
  }

  @override
  Widget build(BuildContext context) {
    var screenHeight = MediaQuery.of(context).size.height;
    var screenWidth = MediaQuery.of(context).size.width;

    return WillPopScope(
      child: MediaQuery(
        data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
        child: Scaffold(
          body: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(height: screenHeight*0.38,),
              Container(
                child: Image(
                  image: AssetImage(logoImage),
                  height: screenHeight*0.08,
                  width: screenWidth*0.6,
                ),
              ),
            ],
          ),
        ),
      ),
      onWillPop: () async => false,
    );
  }
}
