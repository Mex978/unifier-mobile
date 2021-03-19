import 'package:flutter_modular/flutter_modular.dart';
import 'package:rx_notifier/rx_notifier.dart';
import 'package:unifier_mobile/app/app_controller.dart';
import 'package:unifier_mobile/app/shared/utils/enums.dart';

class AuthController extends Disposable {
  final _appController = Modular.get<AppController>();

  final stateLogin = RxNotifier<RequestState>(RequestState.IDLE);
  final stateRegister = RxNotifier<RequestState>(RequestState.IDLE);

  void login({required String username, required String password}) {
    stateLogin.value = RequestState.LOADING;
    _appController.login(username: username, password: password);
    stateLogin.value = RequestState.SUCCESS;
  }

  void register({
    required String name,
    required String username,
    required String email,
    required String password,
  }) {
    stateRegister.value = RequestState.LOADING;
    _appController.register(
        username: username, email: email, password: password);
    stateRegister.value = RequestState.SUCCESS;
  }

  @override
  void dispose() {}
}
