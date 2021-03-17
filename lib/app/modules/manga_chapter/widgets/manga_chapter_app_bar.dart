import 'package:flutter/material.dart';
import 'package:rx_notifier/rx_notifier.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:unifier_mobile/app/shared/utils/functions.dart';

import '../manga_chapter_controller.dart';

class MangaChapterAppBar extends StatelessWidget
    implements PreferredSizeWidget {
  final MangaChapterController controller;

  const MangaChapterAppBar({Key? key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      leading: Tooltip(
        message: 'Lista de capítulos',
        child: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Modular.to.pop(),
        ),
      ),
      title: Row(
        children: [
          Flexible(
            child: RxBuilder(
              builder: (_) {
                return Text(
                  Unifier.parseTitle(controller.mangaChapter.value.title) ??
                      'Manga Chapter',
                  overflow: TextOverflow.visible,
                  maxLines: 2,
                  softWrap: true,
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(56);
}
