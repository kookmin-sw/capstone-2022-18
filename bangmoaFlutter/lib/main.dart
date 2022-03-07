import 'package:bangmoa/src/provider/selectedThemaProvider.dart';
import 'package:bangmoa/src/view/mainView.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'src/provider/themaProvider.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider<ThemaProvider>(create: (BuildContext context) => ThemaProvider()),
        ChangeNotifierProvider<SelectedThemaProvider>(create: (BuildContext context) => SelectedThemaProvider())
      ],
        child : MyApp()
    )
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.grey,
      ),
      home: const mainView(),
    );
  }
}