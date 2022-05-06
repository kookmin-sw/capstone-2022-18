import 'package:cloud_firestore/cloud_firestore.dart';

class Manager {
  late String id;
  late String name;
  late String address;
  late String phone;

  Manager(this.id, this.name, this.address, this.phone);

  factory Manager.fromDocument(DocumentSnapshot doc) {
    return Manager(
        doc.id,
        doc["name"],
        doc["address"],
        doc["phone"]
    );
  }
}
