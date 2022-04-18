import 'package:cloud_firestore/cloud_firestore.dart';

class Alarm {
  late String themeID;
  late String themeName;
  late String date;

  Alarm(this.themeID, this.themeName, this.date);

  factory Alarm.fromDocument(DocumentSnapshot doc) {
    return Alarm(
      doc["themeID"],
      doc["themeName"],
      doc["date"]
    );
  }
}