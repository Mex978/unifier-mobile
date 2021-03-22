import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:rx_notifier/rx_notifier.dart';
import 'package:unifier_mobile/app/app_controller.dart';
import 'package:unifier_mobile/app/shared/utils/enums.dart';

class SplashController with Disposable {
  late RxDisposer disposer;
  final _appController = Modular.get<AppController>();

  SplashController() {
    init();
    disposer = rxObserver(() {
      if (stateLoadApp.value == RequestState.SUCCESS) {
        if (_appController.token.value.isNotEmpty) {
          Modular.to.pushReplacementNamed('/home');
        } else {
          Modular.to.pushReplacementNamed('/login');
        }
      }
    });
  }

  final stateLoadApp = RxNotifier(RequestState.IDLE);

  void init() async {
    stateLoadApp.value = RequestState.LOADING;
    await Firebase.initializeApp();
    await _appController.loadUser();
    stateLoadApp.value = RequestState.SUCCESS;
  }

  @override
  void dispose() {
    disposer();
  }
}
