import 'package:flutter/material.dart';
import 'package:rx_notifier/rx_notifier.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:unifier_mobile/app/modules/novel_chapter/widgets/novel_chapter_app_bar.dart';
import 'package:unifier_mobile/app/modules/work/work_controller.dart';
import 'package:unifier_mobile/app/shared/models/chapter.dart';
import 'package:unifier_mobile/app/shared/utils/enums.dart';
import 'package:unifier_mobile/app/shared/utils/functions.dart';
import 'package:unifier_mobile/app/shared/widgets/chapter_bottom_navigation_bar/chapter_bottom_navigation_bar_widget.dart';

import 'novel_chapter_controller.dart';

class NovelChapterPage extends StatefulWidget {
  final String title;
  const NovelChapterPage({Key? key, this.title = "NovelChapter"}) : super(key: key);

  @override
  _NovelChapterPageState createState() => _NovelChapterPageState();
}

class _NovelChapterPageState extends ModularState<NovelChapterPage, NovelChapterController> {
  final List<Chapter>? chapterList = Modular.args?.data['allWork'];

  int index = Modular.args?.data['index'] ?? -1;
  Chapter chapter = Modular.args?.data['chapter'] ?? Chapter();

  final workController = Modular.get<WorkController>();

  final lastChapterAvaliable = 'Esse é o último capítulo disponível';
  final firstChapterAvaliable = 'Esse é o primeiro capítulo disponível';

  @override
  void initState() {
    super.initState();
    controller.getChapterContent(chapter);
  }

  @override
  Widget build(BuildContext context) {
    return RxBuilder(
      builder: (_) {
        if (controller.state.value == RequestState.LOADING)
          return Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );

        return Scaffold(
          appBar: controller.visibleHUDState.value ? NovelChapterAppBar(controller: controller) : null,
          body: SafeArea(
            child: RxBuilder(
              builder: (_) {
                if (controller.state.value == RequestState.LOADING)
                  return Center(
                    child: CircularProgressIndicator(),
                  );

                return Stack(
                  fit: StackFit.expand,
                  children: [
                    GestureDetector(
                      onTap: () {
                        controller.changeVisibleHUDState(!controller.visibleHUDState.value);
                      },
                      child: SingleChildScrollView(
                        controller: controller.scrollController,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            children: [
                              Text(
                                '${controller.novelChapter.value.body}',
                                textAlign: TextAlign.justify,
                              ),
                              SizedBox(
                                height: 60,
                                width: MediaQuery.of(context).size.width,
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                    ChapterBottomNavigationBarWidget(
                      onPreviousButtonPressed: workController.sortMode.value == 0 ? previousChapter : nextChapter,
                      onNextButtonPressed: workController.sortMode.value == 0 ? nextChapter : previousChapter,
                      visible: controller.visibleHUDState.value,
                      number: controller.novelChapter.value.number ?? -1,
                    ),
                  ],
                );
              },
            ),
          ),
        );
      },
    );
  }

  void nextChapter() {
    if (index < (chapterList!.length - 1) && index != -1) {
      setState(() {
        index = index + 1;
        chapter = chapterList![index];
      });

      controller.getChapterContent(chapter);
    } else {
      Unifier.toast(
        content: workController.sortMode.value == 0 ? lastChapterAvaliable : firstChapterAvaliable,
      );
    }
  }

  void previousChapter() {
    if (index > 0) {
      setState(() {
        index = index - 1;
        chapter = chapterList![index];
      });
      controller.getChapterContent(chapter);
    } else {
      Unifier.toast(
        content: workController.sortMode.value == 0 ? firstChapterAvaliable : lastChapterAvaliable,
      );
    }
  }

  @override
  void dispose() {
    controller.scrollController.removeListener(() => controller.scrollListener(chapter));
    controller.scrollController.dispose();
    Unifier.changeSystemUiHUD(true);
    super.dispose();
  }
}
