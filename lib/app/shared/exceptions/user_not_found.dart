import 'base_exception.dart';

class UserNotFound implements BaseException {
  @override
  String cause = 'Usuário não encontrado';

  @override
  String longCause = 'O usuário não existe';
}
