import 'package:flutter_modular/flutter_modular.dart';
import 'package:unifier_mobile/app/modules/auth/auth_controller.dart';
import 'package:unifier_mobile/app/modules/auth/register/register_screen.dart';

import 'login/login_screen.dart';

class AuthModule extends Module {
  @override
  final List<Bind<Object>> binds = [Bind((i) => AuthController())];

  @override
  final List<ModularRoute> routes = [
    ChildRoute(Modular.initialRoute, child: (_, __) => LoginScreen()),
    ChildRoute('/register', child: (_, __) => RegisterScreen()),
  ];
}
