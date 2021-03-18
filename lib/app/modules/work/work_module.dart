import 'package:flutter_modular/flutter_modular.dart';

import 'pages/chapters/chapters_page.dart';
import 'repositories/work_repository.dart';
import 'work_controller.dart';
import 'work_page.dart';

class WorkModule extends Module {
  @override
  final List<Bind> binds = [
    Bind((i) => WorkRepository(i.get())),
    Bind((i) => WorkController(i.get())),
  ];

  @override
  final List<ModularRoute> routes = [
    ChildRoute(Modular.initialRoute, child: (_, args) => WorkPage()),
    ChildRoute('/chapters', child: (_, args) => ChaptersPage()),
  ];
}
