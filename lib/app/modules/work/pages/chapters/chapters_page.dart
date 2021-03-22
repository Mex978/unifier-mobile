import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:rx_notifier/rx_notifier.dart';
import 'package:unifier_mobile/app/modules/work/widgets/work_chapters/work_chapters.dart';
import 'package:unifier_mobile/app/modules/work/widgets/work_language_selector/work_language_selector.dart';
import 'package:unifier_mobile/app/modules/work/work_controller.dart';
import 'package:unifier_mobile/app/shared/models/chapter.dart';

class ChaptersPage extends StatelessWidget {
  final store = Modular.get<WorkController>();
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
        title: Text(title),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            RxBuilder(
              builder: (_) {
                return WorkLanguageSelector(
                  currentLanguage: store.currentLanguage.value,
                  onChaged: store.changeLanguage,
                  type: type,
                );
              },
            ),
            SizedBox(
              height: 8,
            ),
            RxBuilder(
              builder: (context) {
                final list = chapters
                    .where((c) => c.language == store.currentLanguage.value)
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
