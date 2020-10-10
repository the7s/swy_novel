class ChapterModel {
  String code;
  String message;
  List<Chapter> data;

  ChapterModel({this.code, this.message, this.data});
}

class Chapter {
  String uuid;
  String name;
  String url;

  Chapter({this.uuid, this.name, this.url});
}

class ChapterPagenation {
  int start;
  int end;
  String desc;

  ChapterPagenation({ this.start, this.end, this.desc });
}
