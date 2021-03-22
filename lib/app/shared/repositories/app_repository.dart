import 'package:dio/native_imp.dart';
import 'package:unifier_mobile/app/shared/utils/routes.dart';

class AppRepository {
  final DioForNative _client;

  AppRepository(this._client);

  Future<Map<String, dynamic>> createUser({
    required String username,
    required String email,
    required String password,
  }) async {
    final response = await _client.post(REGISTER, data: {
      'username': username,
      'email': email,
      'password': password,
    });

    return response.data ?? {};
  }

  Future<Map<String, dynamic>> authToken({
    required String username,
    required String password,
  }) async {
    final response = await _client.post(
      AUTH,
      data: {
        'username': username,
        'password': password,
      },
    );

    return response.data ?? {};
  }
}
