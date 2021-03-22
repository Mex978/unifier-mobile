import 'package:dio/dio.dart';
import 'package:dio/native_imp.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:unifier_mobile/app/modules/home/utils/routes.dart';
import 'package:unifier_mobile/app/shared/models/manga_list.dart';
import 'package:unifier_mobile/app/shared/models/novel_list.dart';

class HomeRepository extends Disposable {
  final DioForNative client;

  HomeRepository(this.client);

  Future<MangaList?> fetchMangas() async {
    final Response<dynamic> response = await client.get(MANGAS_LIST);

    if (response.statusCode == 200) {
      return MangaList.fromJson(response.data);
    }

    return null;
  }

  Future<NovelList?> fetchNovels() async {
    final Response<dynamic> response = await client.get(NOVELS_LIST);

    if (response.statusCode == 200) {
      return NovelList.fromJson(response.data);
    }

    return null;
  }

  @override
  void dispose() {}
}
