import 'package:flutter/material.dart';

// Const used in themaInfo
Widget themaInfoViewLoadingIndicator() {
  return const CircularProgressIndicator();
}
TextStyle themaTitleStyle = const TextStyle(fontSize: 30);
EdgeInsetsGeometry imagePadding = const EdgeInsets.all(8.0);
EdgeInsetsGeometry genreAndDifficultyPadding = const EdgeInsets.only(right: 10.0);
EdgeInsetsGeometry descriptionPadding = const EdgeInsets.all(8.0);

double getPosterImageHeight(BuildContext context) {
  return MediaQuery.of(context).size.height*0.3;
}

double getPosterImageWidth(BuildContext context) {
  return MediaQuery.of(context).size.width;
}

double getBottomPaddingHeight(BuildContext context) {
  return MediaQuery.of(context).size.height*0.1;
}

// Const used in reviewBottomSheet
double sheetMinSize = 0.08;
double sheetMaxSize = 1;
double sheetBorderLineWidth = 1;
BorderRadiusGeometry sheetBorderRadius = const BorderRadius.vertical(top: Radius.circular(20));
EdgeInsetsGeometry sheetDragBarPadding = const EdgeInsets.all(8.0);
Text sheetDragBarText = const Text("댓글", style: TextStyle(fontSize: 18),);

double getReviewListBoxHeight(BuildContext context) {
  return MediaQuery.of(context).size.height*0.92;
}

double getReviewListBoxWidth(BuildContext context) {
  return MediaQuery.of(context).size.width;
}

// Const used in reviewTile
Color reviewTileColor = const Color.fromRGBO(22, 32, 45, 1);
EdgeInsetsGeometry tileRowPadding = const EdgeInsets.only(top: 8.0);
TextStyle reviewTextStyle = const TextStyle(
    color: Colors.white
);

double getNickNameBoxWidth(BuildContext context) {
  return MediaQuery.of(context).size.width*0.25;
}