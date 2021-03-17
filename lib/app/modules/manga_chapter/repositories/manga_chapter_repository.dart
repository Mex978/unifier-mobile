import 'package:dio/dio.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:dio/native_imp.dart';
import 'package:unifier_mobile/app/modules/manga_chapter/utils/routes.dart';
import 'package:unifier_mobile/app/shared/models/manga_chapter.dart';

class MangaChapterRepository extends Disposable {
  final DioForNative? client;

  MangaChapterRepository(this.client);

  Future<MangaChapter?> fetchMangaChapter(String? id) async {
    final Response<dynamic> response = await client!.get(MANGA_CHAPTER(id));

    if (response.statusCode == 200) {
      return MangaChapter.fromJson(response.data);
    }

    return null;
  }

  //dispose will be called automatically
  @override
  void dispose() {}
}
