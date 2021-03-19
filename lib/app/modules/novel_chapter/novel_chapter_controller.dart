import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:rx_notifier/rx_notifier.dart';
import 'package:unifier_mobile/app/shared/models/chapter.dart';
import 'package:unifier_mobile/app/shared/models/novel_chapter.dart';
import 'package:unifier_mobile/app/shared/utils/enums.dart';
import 'package:unifier_mobile/app/shared/utils/functions.dart';

import 'repositories/novel_chapter_repository.dart';

class NovelChapterController with Disposable {
  final NovelChapterRepository? _repository;

  NovelChapterController(this._repository);

  final scaffKey = GlobalKey<ScaffoldState>();

  final novelChapter = RxNotifier<NovelChapter>(NovelChapter());

  final state = RxNotifier<RequestState>(RequestState.IDLE);

  final visibleHUDState = RxNotifier<bool>(true);

  void changeVisibleHUDState(bool value) {
    visibleHUDState.value = value;
    Unifier.changeSystemUiHUD(visibleHUDState.value);
  }

  getChapterContent(Chapter novel) async {
    Unifier.storeMethod(
      body: () async {
        state.value = RequestState.LOADING;

        novelChapter.value =
            await _repository!.fetchNovelChapter(novel.id) ?? NovelChapter();

        state.value = RequestState.SUCCESS;
      },
      resultState: (value) => state.value = value,
    );
  }

  @override
  void dispose() {}
}
