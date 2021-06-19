import 'package:dio/dio.dart';
import 'package:dio/native_imp.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:unifier_mobile/app/modules/home/utils/routes.dart';
import 'package:unifier_mobile/app/shared/models/favorites_list.dart';
import 'package:unifier_mobile/app/shared/models/manga_list.dart';
import 'package:unifier_mobile/app/shared/models/novel_list.dart';

class HomeRepository extends Disposable {
  final DioForNative client;

  HomeRepository(this.client);

  Future<bool> addToFavorites(String id) async {
    final Response<dynamic> response = await client.post(
      FAVORITES_LIST,
      data: {
        'id': id,
      },
    );

    if (response.statusCode == 200) {
      return true;
    }

    return false;
  }

  Future<bool> removeFromFavorites(String id) async {
    final Response<dynamic> response = await client.delete(
      FAVORITES_LIST,
      data: {
        'id': id,
      },
    );

    if (response.statusCode == 200) {
      return true;
    }

    return false;
  }

  Future<FavoritesList?> fetchFavorites() async {
    final Response<dynamic> response = await client.get(
      FAVORITES_LIST,
    );

    if (response.statusCode == 200) {
      return FavoritesList.fromJson(response.data);
    }

    return null;
  }

  Future<MangaList?> fetchMangas({int page = 1}) async {
    final Response<dynamic> response = await client.get(
      MANGAS_LIST,
      queryParameters: {
        'page': page,
      },
    );

    if (response.statusCode == 200) {
      return MangaList.fromJson(response.data);
    }

    return null;
  }

  Future<NovelList?> fetchNovels({int page = 1}) async {
    final Response<dynamic> response = await client.get(
      NOVELS_LIST,
      queryParameters: {
        'page': page,
      },
    );

    if (response.statusCode == 200) {
      return NovelList.fromJson(response.data);
    }

    return null;
  }

  @override
  void dispose() {}
}
