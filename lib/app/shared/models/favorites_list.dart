import 'package:unifier_mobile/app/shared/models/work_result.dart';

class FavoritesList {
  List<WorkResult>? mangas;
  List<WorkResult>? novels;

  FavoritesList({this.mangas, this.novels});

  FavoritesList.fromJson(Map<String, dynamic> json) {
    if (json['mangas'] != null) {
      mangas = <WorkResult>[];
      json['mangas'].forEach((v) {
        mangas?.add(WorkResult.fromJson(v));
      });
    }
    if (json['novels'] != null) {
      novels = <WorkResult>[];
      json['novels'].forEach((v) {
        novels?.add(WorkResult.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    if (this.mangas != null) {
      data['mangas'] = this.mangas?.map((v) => v.toJson()).toList();
    }
    if (this.novels != null) {
      data['novels'] = this.novels?.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
