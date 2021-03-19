import 'package:dio/dio.dart';
import 'package:unifier_mobile/app/shared/utils/error_handle.dart';

class ErrorInterceptor extends InterceptorsWrapper {
  @override
  Future onError(DioError err, ErrorInterceptorHandler handler) async {
    ErrorHandle.handle(err);
  }
}
