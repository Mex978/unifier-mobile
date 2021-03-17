class NovelChapter {
  String? id;
  int? number;
  String? title;
  int? language;
  String? body;

  NovelChapter({this.id, this.number, this.title, this.language, this.body});

  NovelChapter.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    number = json['number'];
    title = json['title'];
    language = json['language'];
    body = json['body'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['number'] = this.number;
    data['title'] = this.title;
    data['language'] = this.language;
    data['body'] = this.body;
    return data;
  }
}
