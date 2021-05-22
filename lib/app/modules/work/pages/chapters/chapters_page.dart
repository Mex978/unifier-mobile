import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:rx_notifier/rx_notifier.dart';
import 'package:unifier_mobile/app/modules/work/widgets/work_chapters/work_chapters.dart';
import 'package:unifier_mobile/app/modules/work/widgets/work_language_selector/work_language_selector.dart';
import 'package:unifier_mobile/app/modules/work/work_controller.dart';
import 'package:unifier_mobile/app/shared/models/chapter.dart';

class ChaptersPage extends StatelessWidget {
  final controller = Modular.get<WorkController>();
  final args = Modular.args?.data;

  @override
  Widget build(BuildContext context) {
    late List<Chapter> chapters;
    late String type;
    late String title;

    if (args != null && args.isNotEmpty) {
      title = args['title'];
      chapters = args['chapters'];
      type = args['type'];
    }

    return Scaffold(
      appBar: AppBar(
        title: AutoSizeText(
          title,
          maxLines: 2,
          textAlign: TextAlign.center,
          maxFontSize: 16,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            RxBuilder(
              builder: (_) {
                return WorkLanguageSelector(
                  currentLanguage: controller.currentLanguage.value,
                  onChaged: controller.changeLanguage,
                  type: type,
                );
              },
            ),
            SizedBox(height: 8),
            RxBuilder(
              builder: (context) {
                if (type == 'manga') {
                  chapters = [];
                  controller.filteredChaptersResult?.forEach((v) {
                    chapters.add(v);
                  });
                }

                final list = (type == 'manga' ? controller.filteredChaptersResult?.sublist(0) ?? [] : chapters)
                    .where((c) => c.language == controller.currentLanguage.value)
                    .toList();

                return WorkChapters(items: list);
              },
            ),
          ],
        ),
      ),
    );
  }
}
