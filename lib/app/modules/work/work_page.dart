import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:rx_notifier/rx_notifier.dart';
import 'package:unifier_mobile/app/modules/work/widgets/work_chapters/work_chapters.dart';
import 'package:unifier_mobile/app/modules/work/widgets/work_language_selector/work_language_selector.dart';
import 'package:unifier_mobile/app/shared/models/chapter.dart';
import 'package:unifier_mobile/app/shared/models/work_result.dart';
import 'package:unifier_mobile/app/shared/themes/colors.dart';
import 'package:unifier_mobile/app/shared/utils/enums.dart';
import 'utils/enums.dart';
import 'widgets/chapter_item/chapter_item_widget.dart';
import 'work_controller.dart';
import 'widgets/work_info/work_info_widget.dart';

class WorkPage extends StatefulWidget {
  const WorkPage({Key? key}) : super(key: key);

  @override
  _WorkPageState createState() => _WorkPageState();
}

class _WorkPageState extends ModularState<WorkPage, WorkController> {
  late String? type = Modular.args?.data['type'];
  late WorkResult? workResult = Modular.args?.data['item'];

  @override
  void initState() {
    super.initState();
    foo();
  }

  void foo() {
    if (type == 'manga')
      store.getMangaInfo(workResult ?? WorkResult());
    else if (type == 'novel') store.getNovelInfo(workResult ?? WorkResult());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(workResult?.title ?? ''),
      ),
      body: RxBuilder(
        builder: (_) {
          if (store.state.value == RequestState.LOADING) {
            return Center(child: CircularProgressIndicator());
          }

          List<Chapter>? chapterList = type == 'manga'
              ? store.manga.value.chapters
              : store.novel.value.chapters;

          return CustomScrollView(
            slivers: [
              SliverToBoxAdapter(
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Informações',
                        textAlign: TextAlign.start,
                        style: TextStyle(
                          fontWeight: FontWeight.w400,
                          fontSize: 22,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: WorkInfoWidget(
                  item: workResult,
                ),
              ),
              SliverToBoxAdapter(
                child: SizedBox(height: 16),
              ),
              SliverToBoxAdapter(
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Capítulos',
                        textAlign: TextAlign.start,
                        style: TextStyle(
                          fontWeight: FontWeight.w400,
                          fontSize: 22,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              RxBuilder(
                builder: (_) {
                  return WorkLanguageSelector(
                    currentLanguage: store.currentLanguage.value,
                    onChaged: store.changeLanguage,
                    type: type!,
                  );
                },
              ),
              RxBuilder(builder: (context) {
                final list = chapterList!
                    .where((c) => c.language == store.currentLanguage.value)
                    .toList();

                return WorkChapters(items: list);
              }),
            ],
          );
        },
      ),
    );
  }
}
