import 'package:flutter_modular/flutter_modular.dart';
import 'package:rx_notifier/rx_notifier.dart';
import 'package:unifier_mobile/app/app_controller.dart';
import 'package:unifier_mobile/app/shared/local_data/local_data.dart';
import 'package:unifier_mobile/app/shared/models/manga_list.dart';
import 'package:unifier_mobile/app/shared/models/novel_list.dart';
import 'package:unifier_mobile/app/shared/utils/functions.dart';

import '../../shared/models/work_result.dart';
import '../../shared/utils/enums.dart';
import 'repositories/home_repository.dart';

class HomeController with Disposable {
  late HomeRepository _repository;

  HomeController(this._repository) {
    getMangas();
    getNovels(showDialog: false);
  }

  final _appController = Modular.get<AppController>();

  final searchMangasField = RxNotifier<String>('');

  final searchNovelsField = RxNotifier<String>('');

  final novelState = RxNotifier<RequestState>(RequestState.IDLE);

  final mangaState = RxNotifier<RequestState>(RequestState.IDLE);

  final mangaResults = RxList<WorkResult>();

  final novelResults = RxList<WorkResult>();

  final searchView = RxNotifier<bool>(true);
  final directionLocked = RxNotifier<int>(1);
  final lockSearchView = RxNotifier<bool>(false);

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

  changeSearchMangasField(String value) {
    searchMangasField.value = value;
  }

  changeSearchNovelsField(String value) {
    searchNovelsField.value = value;
  }

  void getMangas({bool showDialog = true}) {
    Unifier.storeMethod(
      body: () async {
        int page = 1;

        if (showDialog) mangaState.value = RequestState.LOADING;

        MangaList? result = await _repository.fetchMangas();

        MangaList mangaList = result ?? MangaList();

        mangaResults.clear();

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
