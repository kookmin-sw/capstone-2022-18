// cafe클래스
// id, 카페 이름, 카페 위치, 전화번호, 테마들을 포함.

import 'package:cloud_firestore/cloud_firestore.dart';

class Cafe {
  late String id;
  late String name;
  late String destination;
  late List<String> themas;
  late String phone;

  Cafe(this.id, this.name, this.destination, this.phone, this.themas);

  factory Cafe.fromDocument(DocumentSnapshot doc) {
    return Cafe(
      doc.id,
      doc["name"],
      doc["destination"],
      doc["phone"],
      doc["themes"]
    );
  }
}
