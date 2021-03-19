import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:unifier_mobile/app/shared/themes/dark_theme.dart';

import 'shared/utils/functions.dart';

class AppWidget extends StatefulWidget {
  @override
  _AppWidgetState createState() => _AppWidgetState();
}

class _AppWidgetState extends State<AppWidget> {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
    ));

    return GestureDetector(
      onTap: () => Unifier.hideKeyboard(context),
      child: MaterialApp(
        title: 'Unifier',
        builder: BotToastInit(),
        navigatorObservers: [BotToastNavigatorObserver()],
        localizationsDelegates: [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: [
          const Locale('pt', 'br'),
          const Locale('en', ''), // English, no country code
        ],
        theme: darkTheme(),
      ).modular(),
    );
  }
}
