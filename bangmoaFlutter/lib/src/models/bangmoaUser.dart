// 유저 클래스
// id, 닉네임으로 구성

import 'package:cloud_firestore/cloud_firestore.dart';

class BangmoaUser {
  late String id;
  late String nickName;
  late List<String> alarms;
  late List<String> recommend;

  BangmoaUser(this.id, this.nickName, this.alarms, this.recommend);

  factory BangmoaUser.fromDocument(DocumentSnapshot doc){
    return BangmoaUser(
      doc.id,
      doc["nickname"],
      List.castFrom(doc.get("alarms")),
      List.castFrom(doc.get("recommand"),)
    );
  }
}