import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:unifier_mobile/app/app_controller.dart';
import 'package:unifier_mobile/app/modules/home/home_controller.dart';
import 'package:unifier_mobile/app/shared/themes/colors.dart';

class HomeDrawerWidget extends StatelessWidget {
  final _appController = Modular.get<AppController>();
  final controller = Modular.get<HomeController>();

  @override
  Widget build(BuildContext context) {
    final String _username = _appController.user.data()?['name'] ?? 'Usuário';

    return Drawer(
      child: SafeArea(
        child: ListView(
          children: [
            DrawerHeader(
              child: Column(
                children: [
                  CircleAvatar(
                    backgroundColor: UnifierColors.secondaryColor,
                    maxRadius: 42,
                    child: CircleAvatar(
                      maxRadius: 41,
                      child: Text(_getAvatarContent(_username)),
                    ),
                  ),
                  Spacer(),
                  Flexible(
                    child: Text(
                      _username,
                      textAlign: TextAlign.center,
                    ),
                  ),
                  Spacer(),
                ],
              ),
            ),
            ListTile(
              onTap: () {
                Navigator.pop(context);
                controller.logout();
              },
              title: Text('Sair'),
              leading: Icon(
                Icons.close,
                color: Colors.red,
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _getAvatarContent(String str) {
    final _list = str.split(' ');

    return _list.first.characters.first +
        (_list.length > 1 ? str.split(' ').last.characters.first : '');
  }
}
