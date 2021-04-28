import 'package:unifier_mobile/app/modules/home/widgets/home_mangas_view/home_mangas_view_widget.dart';
import 'package:unifier_mobile/app/modules/home/widgets/home_novels_view/home_novels_view_widget.dart';

import './repositories/home_repository.dart';
import 'home_controller.dart';
import 'package:flutter_modular/flutter_modular.dart';

import 'home_page.dart';

class HomeModule extends Module {
  @override
  final List<Bind> binds = [
    Bind((i) => HomeRepository(i.get())),
    Bind((i) => HomeController(i.get())),
  ];

  @override
  final List<ModularRoute> routes = [
    ChildRoute(
      Modular.initialRoute,
      child: (_, args) => HomePage(),
      children: [
        ChildRoute(
          '/mangas',
          child: (_, __) => HomeMangasViewWidget(),
          transition: TransitionType.fadeIn,
        ),
        ChildRoute(
          '/novels',
          child: (_, __) => HomeNovelsViewWidget(),
          transition: TransitionType.fadeIn,
        ),
      ],
    ),
  ];
}
