import 'package:flutter/material.dart';

Widget mainViewLoadingIndicator() {
  return const CircularProgressIndicator();
}

// Const used in Thema Grid View
SliverGridDelegate themaGridViewDelegate = const SliverGridDelegateWithFixedCrossAxisCount(
  crossAxisCount: 2,
  crossAxisSpacing: 10,
  mainAxisSpacing: 10,
  childAspectRatio: 0.7,
);

// Const used in Thema Grid Tile
EdgeInsetsGeometry tilePadding = const EdgeInsets.all(8.0);
double imageHeight = 150;
EdgeInsetsGeometry themaTextPadding = const EdgeInsets.only(left: 5.0);
TextStyle themaTitleStyle = const TextStyle(fontSize: 20);

// Const used in Bottom Navigation Bar
double bottomNavigationSelectedFontSize = 15;
double bottomNavigationUnselectedFontSize = 14;
Color bottomNavigationBackGroundColor = Colors.grey;
Color bottomNavigationSelectedItemColor = Colors.white;
Color bottomNavigationUnselectedItemColor = Colors.white.withOpacity(0.6);