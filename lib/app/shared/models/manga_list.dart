import 'work_result.dart';

class MangaList {
  int? count;
  Null next;
  Null previous;
  List<WorkResult>? results;

  MangaList({this.count, this.next, this.previous, this.results});

  MangaList.fromJson(Map<String, dynamic> json) {
    count = json['count'];
    next = json['next'];
    previous = json['previous'];
    if (json['results'] != null) {
      results = <WorkResult>[];
      json['results'].forEach((v) {
        results!.add(new WorkResult.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['count'] = this.count;
    data['next'] = this.next;
    data['previous'] = this.previous;
    if (this.results != null) {
      data['results'] = this.results!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
