import 'base_exception.dart';

class InvalidCredentials implements BaseException {
  @override
  String cause = 'Usuário e/ou senha inválidos';

  @override
  String longCause = 'O usuário e/ou senha digitados são inválidos';
}
