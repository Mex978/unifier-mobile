import 'package:dio/dio.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:dio/native_imp.dart';
import 'package:unifier_mobile/app/modules/novel_chapter/utils/routes.dart';
import 'package:unifier_mobile/app/shared/models/novel_chapter.dart';

class NovelChapterRepository extends Disposable {
  final DioForNative? client;

  NovelChapterRepository(this.client);

  Future<NovelChapter?> fetchNovelChapter(String? id) async {
    final Response<dynamic> response = await client!.get(NOVEL_CHAPTER(id));

    if (response.statusCode == 200) {
      return NovelChapter.fromJson(response.data);
    }

    return null;
  }

  //dispose will be called automatically
  @override
  void dispose() {}
}
