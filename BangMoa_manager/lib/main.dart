import 'package:bangmoa_manager/src/provider/login_status_provider.dart';
import 'package:bangmoa_manager/src/view/main_view.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() => runApp(MultiProvider(
  providers: [
    ChangeNotifierProvider<LoginStatusProvider>(create: (BuildContext context) => LoginStatusProvider())
  ], child: const MyApp()
));

class MyApp extends StatelessWidget {
  static const String baseURL = 'http://3.39.80.150:5000';

  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      initialRoute: '/',
      routes: {
        '/': (context) => const MainView(),
      },
    );
  }
}
