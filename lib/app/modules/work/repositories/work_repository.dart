import 'package:dio/dio.dart';
import 'package:dio/native_imp.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:unifier_mobile/app/modules/work/utils/routes.dart';
import 'package:unifier_mobile/app/shared/models/manga.dart';
import 'package:unifier_mobile/app/shared/models/novel.dart';

class WorkRepository extends Disposable {
  final DioForNative? client;

  WorkRepository(this.client);

  Future<Manga?> fetchMangaInfo(String? id) async {
    final Response<dynamic> response = await client!.get(MANGA_INFO(id));

    if (response.statusCode == 200) {
      return Manga.fromJson(response.data);
    }

    return null;
  }

  Future<Novel?> fetchNovelInfo(String? id) async {
    final Response<dynamic> response = await client!.get(NOVEL_INFO(id));

    if (response.statusCode == 200) {
      return Novel.fromJson(response.data);
    }

    return null;
  }

  //dispose will be called automatically
  @override
  void dispose() {}
}
