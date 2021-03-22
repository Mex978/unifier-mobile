import 'package:dio/dio.dart';

class LogInterceptor extends InterceptorsWrapper {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    print(
        'REQUEST[${options.method}] => URL: ${options.baseUrl} => PATH: ${options.path} => HEADER: ${options.headers} => BODY: ${options.data}');
    return super.onRequest(options, handler);
  }

  @override
  Future onResponse(Response response, ResponseInterceptorHandler handler) {
    print(
        'RESPONSE[${response.statusCode}] => PATH: ${response.requestOptions.path} => DATA: ${response.data}');
    return super.onResponse(response, handler) as Future;
  }

  @override
  Future onError(DioError err, ErrorInterceptorHandler handler) {
    print(
        'ERROR[${err.response?.statusCode}] => PATH: ${err.requestOptions.path} => MESSAGE: ${err.message} => DATA: ${err.response?.data}');

    return super.onError(err, handler) as Future;
  }
}
