import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:rx_notifier/rx_notifier.dart';
import 'package:unifier_mobile/app/shared/models/chapter.dart';
import 'package:unifier_mobile/app/shared/models/work_result.dart';
import 'package:unifier_mobile/app/shared/utils/enums.dart';

import 'widgets/work_info/work_info_widget.dart';
import 'work_controller.dart';

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

          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 2.0),
                  child: WorkInfoWidget(
                    item: workResult,
                    space: 12,
                  ),
                ),
                Container(
                  height: 64,
                  padding: const EdgeInsets.all(8.0),
                  child: ElevatedButton(
                    onPressed: () {
                      Modular.to.pushNamed('/work/chapters', arguments: {
                        'title': workResult?.title ?? '',
                        'chapters': chapterList,
                        'type': type,
                      });
                    },
                    child: Text(
                      'VER CAPÍTULOS',
                      // style: TextStyle(
                      //   color: UnifierColors.tertiaryColor,
                      // ),
                    ),
                  ),
                ),

                // Container(
                //   padding: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                //   child: Row(
                //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                //     children: [
                //       Text(
                //         'Capítulos',
                //         textAlign: TextAlign.start,
                //         style: TextStyle(
                //           fontWeight: FontWeight.w400,
                //           fontSize: 22,
                //         ),
                //       ),
                //     ],
                //   ),
                // ),
                // RxBuilder(
                //   builder: (_) {
                //     return WorkLanguageSelector(
                //       currentLanguage: store.currentLanguage.value,
                //       onChaged: store.changeLanguage,
                //       type: type!,
                //     );
                //   },
                // ),
                // RxBuilder(builder: (context) {
                //   final list = chapterList!
                //       .where((c) => c.language == store.currentLanguage.value)
                //       .toList();

                //   return WorkChapters(items: list);
                // })
              ],
            ),
          );
        },
      ),
    );
  }
}
