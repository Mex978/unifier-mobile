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

  RxList<WorkResult?> get filteredMangaResults =>
      searchMangasField.value.isEmpty
          ? mangaResults
          : mangaResults
              .where((r) {
                final similarityResult = Unifier.stringSimilarity(
                    test: searchMangasField.value, target: r.title!);
                return similarityResult;
              })
              .toList()
              .asRx();

  RxList<WorkResult?> get filteredNovelResults =>
      searchNovelsField.value.isEmpty
          ? novelResults
          : novelResults
              .where((r) {
                final similarityResult = Unifier.stringSimilarity(
                    test: searchNovelsField.value, target: r.title!);
                return similarityResult;
              })
              .toList()
              .asRx();

  changeSearchMangasField(String value) {
    searchMangasField.value = value;
  }

  changeSearchNovelsField(String value) {
    searchNovelsField.value = value;
  }

  void getMangas({bool showDialog = true}) {
    Unifier.storeMethod(
      body: () async {
        mangaState.value = RequestState.LOADING;

        final result = await _repository.fetchMangas();

        MangaList mangaList = result ?? MangaList();

        mangaResults.clear();
        mangaResults.addAll(mangaList.results!);

        mangaState.value = RequestState.SUCCESS;
      },
      resultState: (value) => mangaState.value = value,
    );
  }

  void getNovels({bool showDialog = true}) {
    Unifier.storeMethod(
      body: () async {
        novelState.value = RequestState.LOADING;
        final result = await _repository.fetchNovels();

        NovelList novelList = result ?? NovelList();

        novelResults.clear();
        novelResults.addAll(novelList.results!);

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
