import 'base_exception.dart';

class NoConnectionWithServerException implements BaseException {
  @override
  String cause = 'Sem conexão com o servidor';

  @override
  String longCause =
      'Não conseguimos conexão com o servidor.\nTente novamente mais tarde.';
}
