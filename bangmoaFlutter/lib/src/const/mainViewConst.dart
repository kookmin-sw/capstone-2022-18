import 'package:flutter/material.dart';

Widget mainViewLoadingIndicator() {
  return const CircularProgressIndicator();
}

// Const used in Theme Grid View
Color themeGridViewStringColor = Colors.white;
SliverGridDelegate themeGridViewDelegate = const SliverGridDelegateWithFixedCrossAxisCount(
  crossAxisCount: 2,
  crossAxisSpacing: 10,
  mainAxisSpacing: 5,
  childAspectRatio: 0.75,
);

// Const used in Theme Grid Tile
EdgeInsetsGeometry tilePadding = const EdgeInsets.all(8.0);
double imageHeight = 175;
EdgeInsetsGeometry themeTextPadding = const EdgeInsets.only(left: 5.0);

// Const used in Bottom Navigation Bar
double bottomNavigationSelectedFontSize = 15;
double bottomNavigationUnselectedFontSize = 14;
Color bottomNavigationBackGroundColor = Colors.grey;
Color bottomNavigationSelectedItemColor = Colors.white;
Color bottomNavigationUnselectedItemColor = Colors.white.withOpacity(0.6);