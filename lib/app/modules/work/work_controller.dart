import 'package:flutter_modular/flutter_modular.dart';
import 'package:rx_notifier/rx_notifier.dart';

import 'package:unifier_mobile/app/modules/work/repositories/work_repository.dart';
import 'package:unifier_mobile/app/shared/models/chapter.dart';
import 'package:unifier_mobile/app/shared/models/manga.dart';
import 'package:unifier_mobile/app/shared/models/novel.dart';
import 'package:unifier_mobile/app/shared/models/work_result.dart';
import 'package:unifier_mobile/app/shared/utils/enums.dart';

class WorkController with Disposable {
  late WorkRepository _repository;

  WorkController(this._repository);

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

  Future<void> getMangaInfo(WorkResult workResult) async {
    state.value = RequestState.LOADING;

    manga.value = await _repository.fetchMangaInfo(workResult.id) ?? Manga();
    setInitialLanguage();

    state.value = RequestState.SUCCESS;
  }

  Future<void> getNovelInfo(WorkResult workResult) async {
    state.value = RequestState.LOADING;

    novel.value = await _repository.fetchNovelInfo(workResult.id) ?? Novel();
    setInitialLanguage();

    state.value = RequestState.SUCCESS;
  }

  @override
  void dispose() {}
}
