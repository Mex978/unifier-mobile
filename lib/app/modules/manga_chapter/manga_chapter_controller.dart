import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:rx_notifier/rx_notifier.dart';
import 'package:unifier_mobile/app/modules/manga_chapter/repositories/manga_chapter_repository.dart';
import 'package:unifier_mobile/app/shared/models/chapter.dart';
import 'package:unifier_mobile/app/shared/models/manga_chapter.dart';
import 'package:unifier_mobile/app/shared/utils/enums.dart';
import 'package:unifier_mobile/app/shared/utils/functions.dart';

class MangaChapterController with Disposable {
  final MangaChapterRepository _repository;

  MangaChapterController(this._repository) {
    workRef = Modular.args?.data['workRef'];
  }

  DocumentReference? workRef;

  DocumentReference? currentChapterRef;

  final scaffKey = GlobalKey<ScaffoldState>();

  final mangaChapter = RxNotifier<MangaChapter>(MangaChapter());

  final state = RxNotifier<RequestState>(RequestState.IDLE);

  final visibleHUDState = RxNotifier<bool>(true);

  final scrollController = ScrollController();

  bool _readed = false;

  scrollListener(Chapter chapter) {
    if (!_readed) {
      if (scrollController.offset + 340.0 >= scrollController.position.maxScrollExtent &&
          !scrollController.position.outOfRange) {
        Unifier.toast(content: 'Você chegou ao fim do capítulo');
        _readed = true;
        readChapter(chapter);
      }
    }
  }

  void changeVisibleHUDState(bool value) {
    visibleHUDState.value = value;
    Unifier.changeSystemUiHUD(visibleHUDState.value);
  }

  readChapter(Chapter chapter) {
    currentChapterRef?.set(
      {
        'title': chapter.title,
        'number': 0,
        'readed': true,
      },
      SetOptions(merge: true),
    );
  }

  Future<void> checkReadedChapterStatus() async {
    final _data = await currentChapterRef?.get();
    _readed = _data?.data()?['readed'] ?? false;
  }

  getChapterContent(Chapter chapter, List<Chapter> chapterList) async {
    Unifier.storeMethod(
      body: () async {
        state.value = RequestState.LOADING;

        mangaChapter.value = await _repository.fetchMangaChapter(chapter.id) ?? MangaChapter();

        currentChapterRef = workRef?.collection('chapters').doc(mangaChapter.value.id);

        await checkReadedChapterStatus();

        final chaptersRef = workRef?.collection('chapters');

        final sortedChapters = await chaptersRef?.orderBy('number').get();

        final previousChapterIndex = chapterList.indexOf(chapter) - 1;

        if (previousChapterIndex >= 0) {
          QueryDocumentSnapshot? previousChapterReference;

          try {
            previousChapterReference = sortedChapters?.docs.firstWhere(
              (element) => element.id == chapterList[previousChapterIndex].id,
            );
          } catch (e) {
            previousChapterReference = null;
          }

          if (previousChapterReference != null) {
            final previousChapterData = previousChapterReference.data();
            if (previousChapterData['readed'] == true) {
              final previousNumber = previousChapterData['number'];
              await currentChapterRef?.set(
                {
                  'title': chapter.title,
                  'number': previousNumber + 1,
                  'opened': true,
                },
                SetOptions(merge: true),
              );
            }
          }
        } else {
          await currentChapterRef?.set(
            {
              'title': chapter.title,
              'number': 1,
              'opened': true,
            },
            SetOptions(merge: true),
          );
        }

        scrollController.addListener(() => scrollListener(chapter));

        state.value = RequestState.SUCCESS;
      },
      resultState: (value) => state.value = value,
    );
  }

  @override
  void dispose() {}
}
