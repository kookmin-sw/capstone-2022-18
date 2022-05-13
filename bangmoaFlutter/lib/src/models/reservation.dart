import 'package:cloud_firestore/cloud_firestore.dart';

class Reservation{
  late String id;
  late String date;
  late String theme_id;
  late String theme_name;
  late String time;
  late int user_count;
  late String user_id;
  late String user_name;
  late String user_phone;

  Reservation(this.id, this.date, this.theme_id, this.theme_name, this.time, this.user_count, this.user_id, this.user_name, this.user_phone);
}