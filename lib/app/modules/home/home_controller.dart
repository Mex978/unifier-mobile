import 'package:asuka/asuka.dart' as asuka;
import 'package:flutter_modular/flutter_modular.dart';
import 'package:rx_notifier/rx_notifier.dart';

import 'package:unifier_mobile/app/shared/models/manga_list.dart';
import 'package:unifier_mobile/app/shared/models/novel_list.dart';
import 'package:unifier_mobile/app/shared/utils/functions.dart';
import 'package:unifier_mobile/app/shared/widgets/error_dialog/error_dialog_widget.dart';
import '../../shared/models/work_result.dart';
import '../../shared/utils/enums.dart';
import 'repositories/home_repository.dart';

class HomeController with Disposable {
  late HomeRepository? _repository;

  HomeController(this._repository);

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

  getMangas() async {
    try {
      mangaState.value = RequestState.LOADING;
      final result = await _repository!.fetchMangas();

      MangaList? mangaList = result;
      if (result != null) {
        mangaList = result;
      }

      mangaResults.clear();
      mangaResults.addAll(mangaList!.results!);

      mangaState.value = RequestState.SUCCESS;
    } catch (e) {
      mangaState.value = RequestState.SUCCESS;
      asuka.showDialog(
        builder: (context) => ErrorDialogWidget(
          title: 'Error',
          description: 'Some error occurred! Try again!',
        ),
      );
    }
  }

  getNovels() async {
    try {
      novelState.value = RequestState.LOADING;
      final result = await _repository!.fetchNovels();

      NovelList? novelList = result;
      if (result != null) {
        novelList = result;
      }

      novelResults.clear();
      novelResults.addAll(novelList!.results!);

      novelState.value = RequestState.SUCCESS;
    } catch (e) {
      novelState.value = RequestState.SUCCESS;
      asuka.showDialog(
        builder: (context) => ErrorDialogWidget(
          title: 'Error',
          description: 'Some error occurred! Try again!',
        ),
      );
    }
  }

  @override
  void dispose() {}
}
