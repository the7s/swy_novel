class IntroModel {
  String code;
  String message;
  Intro data;

  IntroModel({this.code, this.message, this.data});

  IntroModel.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    message = json['message'];
    data = Intro.fromJson(json['data']);
  }
}

class Intro {
  String novelId;
  String bookUrl;
  String bookName;
  String authorName;
  String classifyName;
  String lastUpdateAt;
  String bookDesc;
  String recentChapterUrl;
  String bookImageUrl;

  Intro(
      {
      this.novelId,
      this.bookUrl,
      this.bookName,
      this.authorName,
      this.classifyName,
      this.lastUpdateAt,
      this.bookDesc,
      this.recentChapterUrl,
      this.bookImageUrl});

  factory Intro.fromJson(Map<String, dynamic> json) {
    return Intro(
      bookUrl: json['bookUrl'],
      bookName: json['bookName'],
      authorName: json['authorName'],
      classifyName: json['classifyName'],
      lastUpdateAt: json['lastUpdateAt'],
      bookDesc: json['bookDesc'],
      recentChapterUrl: json['recentChapterUrl'],
    );
  }
}
