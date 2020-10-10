class NovelModel {
  String code;
  String message;
  List<Novel> data;

  NovelModel({this.code, this.message, this.data});

  NovelModel.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    message = json['message'];
    if (json['data'] != null) {
      data = new List<Novel>();
      json['data'].forEach((v) {
        data.add(new Novel.fromJson(v));
      });
    }
  }
}

class Novel {
  String novelId;
  int classifyId;
  String authorName;
  String bookName;
  String bookDesc;
  String bookUrl;
  String recentChapterUrl;
  String bookImageUrl;
  String lastUpdateAt;

  Novel(
      {this.novelId,
      this.classifyId,
      this.authorName,
      this.bookName,
      this.bookDesc,
      this.bookUrl,
      this.recentChapterUrl,
      this.bookImageUrl,
      this.lastUpdateAt});

  factory Novel.fromJson(Map<String, dynamic> json) {
    return Novel(
      novelId: json['novelId'],
      classifyId: json['classifyId'],
      authorName: json['authorName'],
      bookName: json['bookName'],
      bookDesc: json['bookDesc'],
      bookImageUrl: json['bookImageUrl'],
      bookUrl: json['bookUrl'],
      recentChapterUrl:json['recentChapterUrl'],
      lastUpdateAt: json['lastUpdateAt'],
    );
  }

  toJson () {
    return {
      "novelId":novelId,
      "classifyId": classifyId,
      "bookName" : bookName,
      "authorName" : authorName,
      "bookImageUrl" : bookImageUrl,
      "lastUpdateAt": lastUpdateAt,
      "bookDesc": bookDesc,
      "recentChapterUrl":recentChapterUrl,
    };
  }
}
