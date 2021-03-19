import 'package:dio/native_imp.dart';
import 'package:unifier_mobile/app/shared/client/error_interceptor.dart';
import 'package:unifier_mobile/app/shared/client/log_interceptor.dart' as l;
import 'package:unifier_mobile/app/shared/utils/constants.dart';

import 'header_interceptor.dart';

DioForNative client = DioForNative()
  ..options.baseUrl = BASE_URL
  ..interceptors.add(HeaderInterceptor())
  ..interceptors.add(l.LogInterceptor())
  ..interceptors.add(ErrorInterceptor());
