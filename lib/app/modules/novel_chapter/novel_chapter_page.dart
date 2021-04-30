import 'package:flutter/material.dart';
import 'package:rx_notifier/rx_notifier.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:unifier_mobile/app/modules/novel_chapter/widgets/novel_chapter_app_bar.dart';
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
  final bool reversed = Modular.args?.data['reversed'];

  int index = Modular.args?.data['index'] ?? -1;
  Chapter chapter = Modular.args?.data['chapter'] ?? Chapter();

  @override
  void initState() {
    super.initState();
    controller.getChapterContent(chapter, chapterList!);
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
                      onPreviousButtonPressed: previousChapter,
                      onNextButtonPressed: nextChapter,
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
    if (reversed) {
      if (index > 0) {
        setState(() {
          index = index - 1;
          chapter = chapterList![index];
        });
        controller.getChapterContent(chapter, chapterList!);
      } else {
        Unifier.toast(
          content: 'Esse é o último capítulo disponível',
        );
      }
    } else {
      if (index < (chapterList!.length - 1) && index != -1) {
        setState(() {
          index = index + 1;
          chapter = chapterList![index];
        });

        controller.getChapterContent(chapter, chapterList!);
      } else {
        Unifier.toast(
          content: 'Esse é o último capítulo disponível',
        );
      }
    }
  }

  void previousChapter() {
    if (reversed) {
      if (index < (chapterList!.length - 1) && index != -1) {
        setState(() {
          index = index + 1;
          chapter = chapterList![index];
        });

        controller.getChapterContent(chapter, chapterList!);
      } else {
        Unifier.toast(
          content: 'Esse é o primeiro capítulo disponível',
        );
      }
    } else {
      if (index > 0) {
        setState(() {
          index = index - 1;
          chapter = chapterList![index];
        });
        controller.getChapterContent(chapter, chapterList!);
      } else {
        Unifier.toast(
          content: 'Esse é o primeiro capítulo disponível',
        );
      }
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
