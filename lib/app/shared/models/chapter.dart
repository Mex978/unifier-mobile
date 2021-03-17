import 'package:unifier_mobile/app/shared/utils/enums.dart';
import 'package:unifier_mobile/app/shared/utils/functions.dart';

class Chapter {
  String? id;
  int? number;
  String? title;
  Language? language;
  String? chapterUrl;

  Chapter({this.id, this.number, this.title, this.language, this.chapterUrl});

  Chapter.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    number = json['number'];
    title = json['title'];
    language = Unifier.numberToLanguage(json['language']);
    chapterUrl = json['chapter_url'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['number'] = this.number;
    data['title'] = this.title;
    data['language'] = this.language;
    data['chapter_url'] = this.chapterUrl;
    return data;
  }
}
