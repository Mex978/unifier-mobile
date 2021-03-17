import 'repositories/novel_chapter_repository.dart';
import 'novel_chapter_controller.dart';
import 'package:flutter_modular/flutter_modular.dart';

import 'novel_chapter_page.dart';

class NovelChapterModule extends Module {
  @override
  final List<Bind> binds = [
    Bind((i) => NovelChapterRepository(i.get())),
    Bind((i) => NovelChapterController(i.get())),
  ];

  @override
  final List<ModularRoute> routes = [
    ChildRoute(Modular.initialRoute, child: (_, args) => NovelChapterPage()),
  ];
}
