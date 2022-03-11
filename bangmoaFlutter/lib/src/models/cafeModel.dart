import 'package:cloud_firestore/cloud_firestore.dart';

class Cafe {
  late String id;
  late String name;
  late String destination;
  late List<String> themes;
  late String phone;

  Cafe(this.id, this.name, this.destination, this.phone, this.themes);

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
