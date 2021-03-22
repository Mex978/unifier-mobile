import 'dart:io';

import 'package:connectivity/connectivity.dart';
import 'package:dio/dio.dart';
import 'package:unifier_mobile/app/shared/exceptions/base_exception.dart';
import 'package:unifier_mobile/app/shared/exceptions/invalid_credentials.dart';
import 'package:unifier_mobile/app/shared/exceptions/no_connection_exception.dart';
import 'package:unifier_mobile/app/shared/exceptions/no_connection_with_server_exception.dart';
import 'package:unifier_mobile/app/shared/exceptions/timeout_exception.dart';
import 'package:unifier_mobile/app/shared/exceptions/username_already_exists.dart';

import 'functions.dart';

class ErrorHandle {
  static handle(DioError err) async {
    var exception;

    if (await _testNoConnectionException()) {
      exception = NoConnectionException();
    } else if (_testTimeoutException(err)) {
      exception = TimeoutException();
    } else if (_testNoConnectionWithServerException(err)) {
      exception = NoConnectionWithServerException();
    } else if (_testInvalidCredentialsException(err)) {
      exception = InvalidCredentials();
    } else if (_testUsernamAlreadyExistsException(err)) {
      exception = UsernamAlreadyExists();
    } else {
      exception = BaseException(
        cause: 'Algum erro inesperado ocorreu.',
        longCause:
            'Algum erro inesperado ocorreu.\nTente novamente mais tarde.',
      );
    }

    Unifier.errorNotification(content: exception.cause);
  }

  static Future<bool> _testNoConnectionException() async {
    final status = await Connectivity().checkConnectivity();
    return status == ConnectivityResult.none;
  }

  static bool _testTimeoutException(DioError err) {
    return err.type == DioErrorType.connectTimeout ||
        err.type == DioErrorType.receiveTimeout;
  }

  static bool _testNoConnectionWithServerException(DioError err) {
    return err.error is SocketException;
  }

  static bool _testInvalidCredentialsException(DioError err) {
    final data = err.response?.data;
    return (data is Map && data.containsKey('non_field_errors'));
  }

  static bool _testUsernamAlreadyExistsException(DioError err) {
    final data = err.response?.data;
    return (data is Map && data.containsKey('username'));
  }
}
