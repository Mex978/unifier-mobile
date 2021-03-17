import 'manga_chapter_controller.dart';
import 'repositories/manga_chapter_repository.dart';
import 'package:flutter_modular/flutter_modular.dart';

import 'manga_chapter_page.dart';

class MangaChapterModule extends Module {
  @override
  final List<Bind> binds = [
    Bind(
      (i) => MangaChapterRepository(i.get()),
    ),
    Bind((i) => MangaChapterController(i.get())),
  ];

  @override
  final List<ModularRoute> routes = [
    ChildRoute(Modular.initialRoute, child: (_, args) => MangaChapterPage()),
  ];
}
