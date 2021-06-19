import 'package:flutter_modular/flutter_modular.dart';
import 'package:rx_notifier/rx_notifier.dart';
import 'package:unifier_mobile/app/app_controller.dart';
import 'package:unifier_mobile/app/shared/local_data/local_data.dart';
import 'package:unifier_mobile/app/shared/models/favorites_list.dart';
import 'package:unifier_mobile/app/shared/models/manga_list.dart';
import 'package:unifier_mobile/app/shared/models/novel_list.dart';
import 'package:unifier_mobile/app/shared/utils/functions.dart';

import '../../shared/models/work_result.dart';
import '../../shared/utils/enums.dart';
import 'repositories/home_repository.dart';

class HomeController with Disposable {
  late HomeRepository _repository;

  HomeController(this._repository) {
    getFavorites();
    getMangas(showDialog: false);
    getNovels(showDialog: false);
  }

  final _appController = Modular.get<AppController>();

  final searchWorksField = RxNotifier<String>('');

  final searchMangasField = RxNotifier<String>('');

  final searchNovelsField = RxNotifier<String>('');

  final workState = RxNotifier<RequestState>(RequestState.IDLE);

  final novelState = RxNotifier<RequestState>(RequestState.IDLE);

  final mangaState = RxNotifier<RequestState>(RequestState.IDLE);

  final workResults = RxList<WorkResult>();

  final mangaResults = RxList<WorkResult>();

  final novelResults = RxList<WorkResult>();

  final searchView = RxNotifier<bool>(true);
  final directionLocked = RxNotifier<int>(1);
  final lockSearchView = RxNotifier<bool>(false);

  RxList<WorkResult?> get filteredWorkResults => searchWorksField.value.isEmpty
      ? workResults
      : workResults
          .where((r) {
            final similarityResult = Unifier.stringSimilarity(test: searchWorksField.value, target: r.title!);
            return similarityResult;
          })
          .toList()
          .asRx();

  RxList<WorkResult?> get filteredMangaResults => searchMangasField.value.isEmpty
      ? mangaResults
      : mangaResults
          .where((r) {
            final similarityResult = Unifier.stringSimilarity(test: searchMangasField.value, target: r.title!);
            return similarityResult;
          })
          .toList()
          .asRx();

  RxList<WorkResult?> get filteredNovelResults => searchNovelsField.value.isEmpty
      ? novelResults
      : novelResults
          .where((r) {
            final similarityResult = Unifier.stringSimilarity(test: searchNovelsField.value, target: r.title!);
            return similarityResult;
          })
          .toList()
          .asRx();

  void lock(int direction) {
    if (lockSearchView.value != true && directionLocked.value != 0) {
      directionLocked.value = direction;
      lockSearchView.value = true;
    }
  }

  void unlock() {
    lockSearchView.value = false;
  }

  void changeSearchView(bool newValue, int direction) {
    if (lockSearchView.value && direction != directionLocked.value) return;

    searchView.value = newValue;
  }

  changeSearcWorksField(String value) {
    searchWorksField.value = value;
  }

  changeSearchMangasField(String value) {
    searchMangasField.value = value;
  }

  changeSearchNovelsField(String value) {
    searchNovelsField.value = value;
  }

  bool isFavorite(String id) =>
      workResults.firstWhere((element) => element.id == id, orElse: () => WorkResult()).id != null;

  void addToFavorites(String id) async {
    await _repository.addToFavorites(id);
    getFavorites(showDialog: false);
  }

  void removeFromFavorites(String id) async {
    await _repository.removeFromFavorites(id);
    getFavorites(showDialog: false);
  }

  void getFavorites({bool showDialog = true}) {
    Unifier.storeMethod(
      body: () async {
        if (showDialog) workState.value = RequestState.LOADING;

        FavoritesList? result = await _repository.fetchFavorites();

        FavoritesList favoritesList = result ?? FavoritesList();

        workResults.clear();

        favoritesList.mangas?.forEach((element) => element.type = 'manga');
        favoritesList.novels?.forEach((element) => element.type = 'novel');

        workResults.addAll(favoritesList.mangas ?? []);
        workResults.addAll(favoritesList.novels ?? []);

        workResults.sort((WorkResult a, WorkResult b) => (a.title ?? '').compareTo(b.title ?? ''));

        workState.value = RequestState.SUCCESS;
      },
      resultState: (value) => workState.value = value,
    );
  }

  void getMangas({bool showDialog = true}) {
    Unifier.storeMethod(
      body: () async {
        int page = 1;

        if (showDialog) mangaState.value = RequestState.LOADING;

        MangaList? result = await _repository.fetchMangas();

        MangaList mangaList = result ?? MangaList();

        mangaResults.clear();

        mangaList.results?.forEach((element) => element.type = 'manga');

        mangaResults.addAll(mangaList.results ?? []);

        while (mangaList.next != null) {
          page += 1;
          result = await _repository.fetchMangas(page: page);
          mangaList = result ?? MangaList();
          mangaResults.addAll(mangaList.results ?? []);
        }

        mangaResults.sort((WorkResult a, WorkResult b) => (a.title ?? '').compareTo(b.title ?? ''));

        mangaState.value = RequestState.SUCCESS;
      },
      resultState: (value) => mangaState.value = value,
    );
  }

  void getNovels({bool showDialog = true}) {
    Unifier.storeMethod(
      body: () async {
        int page = 1;

        if (showDialog) novelState.value = RequestState.LOADING;
        NovelList? result = await _repository.fetchNovels();

        NovelList novelList = result ?? NovelList();

        novelResults.clear();
        novelList.results?.forEach((element) => element.type = 'novel');
        novelResults.addAll(novelList.results ?? []);

        while (novelList.next != null) {
          page += 1;
          result = await _repository.fetchNovels(page: page);
          novelList = result ?? NovelList();
          mangaResults.addAll(novelList.results ?? []);
        }

        novelResults.sort((WorkResult a, WorkResult b) => (a.title ?? '').compareTo(b.title ?? ''));

        novelState.value = RequestState.SUCCESS;
      },
      resultState: (value) => novelState.value = value,
    );
  }

  void logout() {
    LocalData.saveToken('');
    _appController.token.value = '';
    Modular.to.pushReplacementNamed('/login');
  }

  @override
  void dispose() {}
}
