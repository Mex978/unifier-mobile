import 'package:flutter_modular/flutter_modular.dart';
import 'package:unifier_mobile/app/modules/home/home_module.dart';
import 'package:unifier_mobile/app/modules/manga_chapter/manga_chapter_module.dart';
import 'package:unifier_mobile/app/modules/work/work_module.dart';
import 'package:unifier_mobile/app/shared/client/client.dart';

import 'app_controller.dart';
import 'modules/novel_chapter/novel_chapter_module.dart';

class AppModule extends Module {
  @override
  final List<Bind> binds = [
    Bind((i) => client),
    Bind((i) => AppController()),
  ];

  @override
  final List<ModuleRoute> routes = [
    ModuleRoute(Modular.initialRoute, module: HomeModule()),
    ModuleRoute(
      '/chapters',
      module: WorkModule(),
    ),
    ModuleRoute(
      '/manga_chapter',
      module: MangaChapterModule(),
    ),
    ModuleRoute(
      '/novel_chapter',
      module: NovelChapterModule(),
    ),
  ];
}
