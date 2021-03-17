import 'package:flutter_modular/flutter_modular.dart';

import 'login/login_screen.dart';

class AuthModule extends Module {
  @override
  final List<Bind<Object>> binds = [];

  @override
  final List<ModularRoute> routes = [
    ChildRoute(Modular.initialRoute, child: (_, __) => LoginScreen()),
  ];
}
