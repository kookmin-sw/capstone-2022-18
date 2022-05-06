// 리뷰 클래스
// id, 리뷰 내용, 해당 테마의 id, 작성자의 id, 작성자의 닉네임을 포함
// 작성자의 닉네임은 review 컬렉션이 아닌 user 컬렉션에서 받아오는 외부키이기때문에 fromDocument 사용불가, 필요할 때마다 정의해서 사용할 필요 있음.

class ReviewModel{
  late String id;
  late String text;
  late String time;
  late String themaID;
  late String writerID;
  late String writerNickName;
  late double rating;

  ReviewModel(this.id, this.text, this.themaID, this.writerID, this.writerNickName, this.rating, this.time);
}