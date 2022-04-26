import 'package:flutter/material.dart';

// Const used in themeInfo
Widget themeInfoViewLoadingIndicator() {
  return const CircularProgressIndicator();
}

double getPosterImageHeight(BuildContext context) {
  return MediaQuery.of(context).size.height*0.5;
}

double getPosterImageWidth(BuildContext context) {
  return MediaQuery.of(context).size.width;
}

double getBottomPaddingHeight(BuildContext context) {
  return MediaQuery.of(context).size.height*0.1;
}

const double themeTitleSize = 25;
const double reservationButtonHeight = 35;
const double reservationButtonWidth = 80;
const double intervalSize = 15;

// Const used in reviewBottomSheet
const double divisionLineHeight = 1;
const double verticalDivisionLineWidth = 1;
const double verticalDivisionLineHeight = 60;
const double reviewTileHeight = 60;

double getDivisionLineWidth(BuildContext context) {
  return MediaQuery.of(context).size.width*0.95;
}

double getReviewListBoxHeight(BuildContext context) {
  return MediaQuery.of(context).size.height*0.92;
}

double getReviewListBoxWidth(BuildContext context) {
  return MediaQuery.of(context).size.width;
}

// Const used in reviewTile
double getNickNameBoxWidth(BuildContext context) {
  return MediaQuery.of(context).size.width*0.25;
}