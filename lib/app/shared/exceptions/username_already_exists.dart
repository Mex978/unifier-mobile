import 'base_exception.dart';

class UsernamAlreadyExists implements BaseException {
  @override
  String cause = 'O usuário já existe';

  @override
  String longCause = 'O usuário informado já existe';
}
