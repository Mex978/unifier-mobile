import 'base_exception.dart';

class TimeoutException implements BaseException {
  @override
  String cause = 'Tempo de resposta excedido';

  @override
  String longCause =
      'O servidor demorou para responder.\nTente novamente mais tarde.';
}
