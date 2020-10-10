class ShelfModel {
  String code;
  String message;
  List<Shelf> data;

  ShelfModel({this.code, this.message, this.data});

  ShelfModel.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    message = json['message'];
    if (json['data'] != null) {
      data = new List<Shelf>();
      json['data'].forEach((v) {
        data.add(new Shelf.fromJson(v));
      });
    }
  }
}

class Shelf {
  int novelId;
  String authorName;
  String bookName;
  String bookDesc;
  String bookCoverUrl;
  String recentChapterUrl;
  String lastUpdateAt;

  Shelf(
      {this.novelId,
      this.authorName,
      this.bookName,
      this.bookDesc,
      this.bookCoverUrl,
      this.recentChapterUrl,
      this.lastUpdateAt});

  factory Shelf.fromJson(Map<String, dynamic> json) {
    return Shelf(
      novelId: json['novelId'],
      authorName: json['authorName'],
      bookName: json['bookName'],
      bookDesc: json['bookDesc'],
      bookCoverUrl: json['bookCoverUrl'],
      recentChapterUrl: json['recentChapterUrl'],
      lastUpdateAt: json['lastUpdateAt'],
    );
  }
  toJson () {
    return {
      "bookName" : bookName,
      "authorName" : authorName,
      "bookCoverUrl" : bookCoverUrl,
      "lastUpdateAt": lastUpdateAt,
      "bookDesc": bookDesc,
      "recentChapterUrl":recentChapterUrl,
    };
  }
}
