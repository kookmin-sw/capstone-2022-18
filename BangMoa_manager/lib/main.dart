import 'package:bangmoa_manager/src/provider/login_status_provider.dart';
import 'package:bangmoa_manager/src/provider/selected_image_provider.dart';
import 'package:bangmoa_manager/src/provider/theme_info_provider.dart';
import 'package:bangmoa_manager/src/view/add_theme_view.dart';
import 'package:bangmoa_manager/src/view/edit_theme_view.dart';
import 'package:bangmoa_manager/src/view/main_view.dart';
import 'package:bangmoa_manager/src/view/select_poster_view.dart';
import 'package:bangmoa_manager/src/view/signup_view.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() => runApp(MultiProvider(
  providers: [
    ChangeNotifierProvider<LoginStatusProvider>(create: (BuildContext context) => LoginStatusProvider()),
    ChangeNotifierProvider<SelectedImageProvider>(create: (BuildContext context) => SelectedImageProvider()),
    ChangeNotifierProvider<ThemeInfoProvider>(create: (BuildContext context) => ThemeInfoProvider()),
  ], child: const MyApp()
));

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      initialRoute: '/',
      routes: {
        '/': (context) => const MainView(),
        '/signup': (context) => const SignUpView(),
        '/addtheme': (context) => const AddThemeView(),
        '/selectposter': (context) => const SelectPosterView(),
        '/edittheme' : (context) => const EditThemeView(),
      },
    );
  }
}
