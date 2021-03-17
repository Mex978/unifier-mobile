import 'package:dio/native_imp.dart';
import 'package:unifier_mobile/app/shared/client/custom_interceptor.dart';
import 'package:unifier_mobile/app/shared/utils/constants.dart';

DioForNative client = DioForNative()
  ..options.baseUrl = BASE_URL
  ..interceptors.add(CustomInterceptor());
