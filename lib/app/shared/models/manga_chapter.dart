class MangaChapter {
  String? id;
  int? number;
  String? title;
  int? language;
  List<String>? images;

  MangaChapter({this.id, this.number, this.title, this.language, this.images});

  MangaChapter.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    number = json['number'];
    title = json['title'];
    language = json['language'];
    images = json['images'].cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['number'] = this.number;
    data['title'] = this.title;
    data['language'] = this.language;
    data['images'] = this.images;
    return data;
  }
}
