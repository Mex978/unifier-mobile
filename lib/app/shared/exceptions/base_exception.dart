class BaseException implements Exception {
  final String? cause;
  final String? longCause;

  BaseException({this.cause, this.longCause});
}
