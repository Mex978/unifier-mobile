import 'package:flutter_modular/flutter_modular.dart';
import 'package:unifier_mobile/app/modules/home/home_module.dart';
import 'package:unifier_mobile/app/modules/manga_chapter/manga_chapter_module.dart';
import 'package:unifier_mobile/app/modules/splash/splash_module.dart';
import 'package:unifier_mobile/app/modules/work/work_module.dart';
import 'package:unifier_mobile/app/shared/client/client.dart';
import 'package:unifier_mobile/app/shared/firebase_repository/firebase_repository.dart';
import 'package:unifier_mobile/app/shared/repositories/app_repository.dart';

import 'app_controller.dart';
import 'modules/auth/auth_module.dart';
import 'modules/novel_chapter/novel_chapter_module.dart';

class AppModule extends Module {
  @override
  final List<Bind> binds = [
    Bind((i) => client),
    Bind((i) => FirebaseRepository()),
    Bind((i) => AppRepository(i.get())),
    Bind((i) => AppController(i.get(), i.get())),
  ];

  @override
  final List<ModuleRoute> routes = [
    ModuleRoute(Modular.initialRoute, module: SplashModule()),
    ModuleRoute('/login', module: AuthModule()),
    ModuleRoute('/home', module: HomeModule()),
    ModuleRoute('/work', module: WorkModule()),
    ModuleRoute('/manga_chapter', module: MangaChapterModule()),
    ModuleRoute('/novel_chapter', module: NovelChapterModule()),
  ];
}
