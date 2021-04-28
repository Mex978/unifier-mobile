import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:rx_notifier/rx_notifier.dart';
import 'package:unifier_mobile/app/app_controller.dart';

import 'package:unifier_mobile/app/modules/work/repositories/work_repository.dart';
import 'package:unifier_mobile/app/shared/firebase_repository/firebase_repository.dart';
import 'package:unifier_mobile/app/shared/models/chapter.dart';
import 'package:unifier_mobile/app/shared/models/manga.dart';
import 'package:unifier_mobile/app/shared/models/novel.dart';
import 'package:unifier_mobile/app/shared/models/work_result.dart';
import 'package:unifier_mobile/app/shared/utils/enums.dart';
import 'package:unifier_mobile/app/shared/utils/functions.dart';

class WorkController with Disposable {
  late WorkRepository _repository;
  late FirebaseRepository _firebase;

  WorkController(this._repository, this._firebase);

  final _appController = Modular.get<AppController>();

  DocumentReference? workRef;

  ///
  /// Sort mode
  /// 0 -> asc
  /// 1 -> desc
  ///
  final sortMode = RxNotifier<int>(0);

  final currentLanguage = RxNotifier<Language>(Language.NONE);

  final manga = RxNotifier<Manga>(Manga());

  final novel = RxNotifier<Novel>(Novel());

  final state = RxNotifier<RequestState>(RequestState.IDLE);

  void changeLanguage(Language value) {
    currentLanguage.value = value;
  }

  void setInitialLanguage() {
    List<Chapter>? _chapters = [];
    if (manga.value.id != null && manga.value.chapters != null) {
      _chapters = manga.value.chapters;
    } else if (novel.value.id != null && novel.value.chapters != null) {
      _chapters = novel.value.chapters;
    }

    Language.values.forEach((lang) {
      if (currentLanguage.value != Language.NONE) return;

      final langChapters = _chapters?.where((c) => c.language == lang);
      if (langChapters != null && langChapters.isNotEmpty) {
        changeLanguage(lang);
      }
    });
  }

  void changeSortMode() {
    sortMode.value = sortMode.value == 1 ? 0 : 1;
  }

  Future<void> getMangaInfo(WorkResult workResult) async {
    Unifier.storeMethod(
      body: () async {
        state.value = RequestState.LOADING;

        manga.value = await _repository.fetchMangaInfo(workResult.id) ?? Manga();
        setInitialLanguage();

        final token = _appController.token.value;

        workRef = _firebase.instance.collection('users').doc(token).collection('mangas').doc(manga.value.id);

        workRef?.set(
          {
            'name': manga.value.title,
          },
          SetOptions(merge: true),
        );

        state.value = RequestState.SUCCESS;
      },
      resultState: (value) => state.value = value,
    );
  }

  Future<void> getNovelInfo(WorkResult workResult) async {
    Unifier.storeMethod(
      body: () async {
        state.value = RequestState.LOADING;

        novel.value = await _repository.fetchNovelInfo(workResult.id) ?? Novel();
        setInitialLanguage();

        final token = _appController.token.value;

        workRef = _firebase.instance.collection('users').doc(token).collection('novels').doc(novel.value.id);

        await workRef?.set(
          {
            'name': novel.value.title,
          },
          SetOptions(merge: true),
        );

        state.value = RequestState.SUCCESS;
      },
      resultState: (value) => state.value = value,
    );
  }

  @override
  void dispose() {}
}
