import 'package:cloud_firestore/cloud_firestore.dart';

class Thema {
  late String id;
  late String name;
  late String description;
  late String genre;
  late int difficulty;
  late String poster;
  late List<dynamic> reviews;

  Thema(this.id, this.name, this.description, this.genre, this.difficulty, this.poster, this.reviews);

  factory Thema.fromDocument(DocumentSnapshot doc) {
    return Thema(
      doc.id,
      doc.get("name").toString(),
      doc.get("description").toString(),
      doc.get("genre").toString(),
      doc.get("difficulty"),
      doc.get("poster").toString(),
      doc.get("reviews")
    );
  }
}