class ThemeModel {
  late String id;
  late int cost;
  late String description;
  late int difficulty;
  late String genre;
  late String manager_id;
  late String name;
  late String poster;
  late int runningtime;
  late int minplayer;
  late int maxplayer;
  late List<String> timetable;

  ThemeModel(this.id, this.cost, this.description, this.difficulty, this.genre, this.manager_id, this.name, this.poster, this.runningtime, this.minplayer, this.maxplayer, this.timetable);
}