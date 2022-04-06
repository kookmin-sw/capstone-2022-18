import 'package:cloud_firestore/cloud_firestore.dart';

class Alarm {
  late String themaID;
  late String themaName;
  late String date;

  Alarm(this.themaID, this.themaName, this.date);

  factory Alarm.fromDocument(DocumentSnapshot doc) {
    return Alarm(
      doc["themaID"],
      doc["themaName"],
      doc["date"]
    );
  }
}