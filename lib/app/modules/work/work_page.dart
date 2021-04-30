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
      controller.getMangaInfo(workResult ?? WorkResult());
    else if (type == 'novel') controller.getNovelInfo(workResult ?? WorkResult());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(workResult?.title ?? ''),
      ),
      body: RxBuilder(
        builder: (_) {
          if (controller.state.value == RequestState.LOADING) {
            return Center(child: CircularProgressIndicator());
          }

          List<Chapter>? chapterList = type == 'manga' ? controller.manga.value.chapters : controller.novel.value.chapters;

          return RefreshIndicator(
            onRefresh: () => type == 'manga' ? controller.getMangaInfo(workResult ?? WorkResult()) : controller.getNovelInfo(workResult ?? WorkResult()),
            child: ListView(
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
                    child: Text('VER CAPÍTULOS'),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
