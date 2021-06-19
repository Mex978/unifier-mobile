import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:rx_notifier/rx_notifier.dart';
import 'package:unifier_mobile/app/modules/home/home_controller.dart';
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
  final homeController = Modular.get<HomeController>();

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
        title: AutoSizeText(
          workResult?.title ?? '',
          maxLines: 2,
          textAlign: TextAlign.center,
          maxFontSize: 16,
        ),
        actions: [
          RxBuilder(
            builder: (context) => IconButton(
              icon:
                  homeController.isFavorite(workResult?.id ?? '') ? Icon(Icons.favorite) : Icon(Icons.favorite_border),
              onPressed: () {
                final id = workResult?.id ?? '';

                if (homeController.isFavorite(id)) {
                  homeController.removeFromFavorites(id);
                } else {
                  homeController.addToFavorites(id);
                }
              },
            ),
          ),
        ],
      ),
      body: RxBuilder(
        builder: (_) {
          if (controller.state.value == RequestState.LOADING) {
            return Center(child: CircularProgressIndicator());
          }

          List<Chapter>? chapterList =
              type == 'manga' ? controller.manga.value.chapters : controller.novel.value.chapters;

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
