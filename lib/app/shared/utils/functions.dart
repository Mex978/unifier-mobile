import 'package:bot_toast/bot_toast.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:unifier_mobile/app/shared/utils/enums.dart';
import 'package:unifier_mobile/app/shared/utils/error_handle.dart';

class Unifier {
  static Language? numberToLanguage(int? number) {
    switch (number) {
      case 0:
        return Language.ENGLISH_US;
      case 1:
        return Language.PORTUGUESE_BR;
      default:
        return null;
    }
  }

  static void hideKeyboard(BuildContext context) {
    FocusManager.instance.primaryFocus?.unfocus();
  }

  static bool stringSimilarity({required String test, required String target}) {
    bool result = false;

    final testSplitted = test.toLowerCase().split(' ');
    final targetSplitted = target.toLowerCase().split(' ');

    for (var i = 0; i < testSplitted.length; i++) {
      final testWord = testSplitted[i];
      for (var j = 0; j < targetSplitted.length; j++) {
        final targetWord = targetSplitted[j];

        if (testWord.length > targetWord.length) result = false;
        if (targetWord.contains(testWord)) {
          result = true;
          break;
        }

        result = false;
      }
    }

    return result;
  }

  static void changeSystemUiHUD(bool visible) {
    SystemChrome.setEnabledSystemUIOverlays(
        visible ? SystemUiOverlay.values : [SystemUiOverlay.bottom]);
  }

  static void toast(BuildContext context, {required String content}) {
    Fluttertoast.showToast(
      msg: content,
      gravity: ToastGravity.BOTTOM,
      backgroundColor: Colors.black.withOpacity(.64),
    );
  }

  static String capitalize(String string) {
    return '${string[0].toUpperCase()}${string.substring(1)}';
  }

  static String? parseTitle(String? title) {
    if (title == null || title.isEmpty) return null;

    String aux;

    aux = Unifier.capitalize(title);
    aux = aux.replaceAll('Chapter', 'Capítulo');
    aux = aux.replaceAll('Chap.', 'Capítulo');
    aux = aux.replaceAll('Chap', 'Capítulo');
    aux = aux.replaceAll('Chap', 'Capítulo');
    aux = aux.replaceAll('Ch.', 'Capítulo ');
    aux = aux.replaceAll('\\\'', '\'');

    List<String> stringList = aux.split('-');

    List<String> newStringList = [];
    stringList.forEach((s) => newStringList.add(s.trim()));

    aux = newStringList.join(' - ');

    stringList = aux.split('-');

    return aux;
  }

  static void storeMethod({
    required Future Function() body,
    bool showNotification = true,
    ValueChanged<RequestState>? resultState,
  }) async {
    try {
      await body();
    } catch (error) {
      if (error is DioError) {
        ErrorHandle.handle(error);
      } else {
        errorNotification(content: 'Algum erro aconteceu');
      }

      if (resultState != null) resultState(RequestState.ERROR);
    }
  }

  static void errorNotification({String content = 'Algum erro aconteceu'}) {
    BotToast.showSimpleNotification(
      title: 'Erro',
      subTitle: content,
      duration: Duration(seconds: 2, milliseconds: 500),
      backgroundColor: Colors.red,
    );
  }

  static void successNotification(
      {String content = 'Ação realizada com sucesso'}) {
    BotToast.showSimpleNotification(
      title: 'Sucesso',
      subTitle: content,
      duration: Duration(seconds: 2, milliseconds: 500),
      backgroundColor: Colors.green,
    );
  }
}
