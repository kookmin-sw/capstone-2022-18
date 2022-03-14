import 'package:bangmoa/src/provider/selectedThemaProvider.dart';
import 'package:bangmoa/src/provider/userLoginStatusProvider.dart';
import 'package:bangmoa/src/view/mainView.dart';
import 'package:bangmoa/src/view/registerNicknameView.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
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
        ChangeNotifierProvider<SelectedThemaProvider>(create: (BuildContext context) => SelectedThemaProvider()),
        ChangeNotifierProvider<UserLoginStatusProvider>(create: (BuildContext context) => UserLoginStatusProvider()),
      ],
        child : MyApp()
    )
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (BuildContext context, AsyncSnapshot<User?> snapshot) {
        if (snapshot.data == null) {
          Provider.of<UserLoginStatusProvider>(context).logout();
        } else {
          Provider.of<UserLoginStatusProvider>(context).login();
          print(snapshot.data?.uid);
          return FutureBuilder(
            future : FirebaseFirestore.instance.collection('user').doc(snapshot.data?.uid).get(),
            builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot1) {
              if (snapshot1.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator(),);
              }
              print(snapshot1.data!.exists);
              if (snapshot1.data!.exists) {
                Provider.of<UserLoginStatusProvider>(context, listen: false).setUserID(snapshot.data!.uid);
                Provider.of<UserLoginStatusProvider>(context, listen: false).setUserNickName(snapshot1.data!["nickname"]);
              } else {
                Provider.of<UserLoginStatusProvider>(context).setUserID(snapshot.data!.uid);
                return MaterialApp(
                  title: 'BangMoa',
                  theme: ThemeData(
                    primarySwatch: Colors.grey,
                  ),
                  home: const RegisterNicknameView(),
                );
              }
              return MaterialApp(
                title: 'BangMoa',
                theme: ThemeData(
                  primarySwatch: Colors.grey,
                ),
                home: const mainView(),
              );
            }
          );
        }
        return MaterialApp(
          title: 'BangMoa',
          theme: ThemeData(
            primarySwatch: Colors.grey,
          ),
          home: const mainView(),
        );
      }
    );
  }
}