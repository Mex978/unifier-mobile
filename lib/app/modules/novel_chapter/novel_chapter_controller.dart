import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:asuka/asuka.dart' as asuka;
import 'package:rx_notifier/rx_notifier.dart';

import 'package:unifier_mobile/app/shared/models/chapter.dart';
import 'package:unifier_mobile/app/shared/models/novel_chapter.dart';
import 'package:unifier_mobile/app/shared/utils/enums.dart';
import 'package:unifier_mobile/app/shared/utils/functions.dart';
import 'package:unifier_mobile/app/shared/widgets/error_dialog/error_dialog_widget.dart';
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
    try {
      state.value = RequestState.LOADING;

      novelChapter.value =
          await _repository!.fetchNovelChapter(novel.id) ?? NovelChapter();

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
