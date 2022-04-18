// 테마 클래스
// id, 테마이름, 상세설명, 장르, 난이도, 포스터 포함
// 포스터의 경우는 해당 포스터의 인터넷 주소로 사용시 Image.network로 불러와야 함.

import 'package:cloud_firestore/cloud_firestore.dart';

class BMTheme {
  late String id;
  late String name;
  late String description;
  late String genre;
  late int difficulty;
  late String poster;
  late String url;

  BMTheme(this.id, this.name, this.description, this.genre, this.difficulty, this.poster, this.url);

  factory BMTheme.fromDocument(DocumentSnapshot doc) {
    return BMTheme(
      doc.id,
      doc.get("name").toString(),
      doc.get("description").toString(),
      doc.get("genre").toString(),
      doc.get("difficulty"),
      doc.get("poster").toString(),
      doc.get("url").toString(),
    );
  }
}