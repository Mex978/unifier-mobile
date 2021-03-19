import 'package:dio/dio.dart';
import 'package:unifier_mobile/app/shared/local_data/local_data.dart';
import 'package:unifier_mobile/app/shared/utils/routes.dart';

class HeaderInterceptor extends InterceptorsWrapper {
  @override
  void onRequest(
      RequestOptions options, RequestInterceptorHandler handler) async {
    final path = options.path;

    options.headers.addAll(contentTypeHeader());

    if (path != AUTH && path != REGISTER) {
      options.headers.addAll(await authHeader());
    }

    return super.onRequest(options, handler);
  }
}

Map<String, String> contentTypeHeader() {
  final header = <String, String>{};
  header['Content-Type'] = 'application/json';
  return header;
}

Future<Map<String, String>> authHeader() async {
  final header = <String, String>{};
  final token = await LocalData.readToken();
  header['Authorization'] = 'Token $token';
  return header;
}
