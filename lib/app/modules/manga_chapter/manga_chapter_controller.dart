import 'package:flutter/material.dart';
import 'package:asuka/asuka.dart' as asuka;
import 'package:flutter_modular/flutter_modular.dart';
import 'package:rx_notifier/rx_notifier.dart';

import 'package:unifier_mobile/app/modules/manga_chapter/repositories/manga_chapter_repository.dart';
import 'package:unifier_mobile/app/shared/models/chapter.dart';
import 'package:unifier_mobile/app/shared/models/manga_chapter.dart';
import 'package:unifier_mobile/app/shared/utils/enums.dart';
import 'package:unifier_mobile/app/shared/utils/functions.dart';
import 'package:unifier_mobile/app/shared/widgets/error_dialog/error_dialog_widget.dart';

class MangaChapterController with Disposable {
  final MangaChapterRepository _repository;

  MangaChapterController(this._repository);

  final scaffKey = GlobalKey<ScaffoldState>();

  final mangaChapter = RxNotifier<MangaChapter>(MangaChapter());

  final state = RxNotifier<RequestState>(RequestState.IDLE);

  final visibleHUDState = RxNotifier<bool>(true);

  void changeVisibleHUDState(bool value) {
    visibleHUDState.value = value;
    Unifier.changeSystemUiHUD(visibleHUDState.value);
  }

  getChapterContent(Chapter manga) async {
    try {
      state.value = RequestState.LOADING;

      mangaChapter.value =
          await _repository.fetchMangaChapter(manga.id) ?? MangaChapter();

      state.value = RequestState.SUCCESS;
    } catch (e) {
      print(e);
      state.value = RequestState.ERROR;
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
