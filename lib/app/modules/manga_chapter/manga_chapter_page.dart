import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:rx_notifier/rx_notifier.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:unifier_mobile/app/modules/manga_chapter/widgets/manga_page_image.dart';
import 'package:unifier_mobile/app/shared/models/chapter.dart';
import 'package:unifier_mobile/app/shared/utils/enums.dart';
import 'package:unifier_mobile/app/shared/utils/functions.dart';
import 'package:unifier_mobile/app/shared/widgets/chapter_bottom_navigation_bar/chapter_bottom_navigation_bar_widget.dart';
import 'manga_chapter_controller.dart';
import 'widgets/manga_chapter_app_bar.dart';

class MangaChapterPage extends StatefulWidget {
  final String title;
  const MangaChapterPage({Key? key, this.title = "MangaChapter"}) : super(key: key);

  @override
  _MangaChapterPageState createState() => _MangaChapterPageState();
}

class _MangaChapterPageState extends ModularState<MangaChapterPage, MangaChapterController> {
  final List<Chapter>? chapterList = Modular.args?.data['allWork'];

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
          appBar: controller.visibleHUDState.value ? MangaChapterAppBar(controller: controller) : null,
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
                      child: InteractiveViewer(
                        maxScale: 5,
                        child: ListView.builder(
                          addAutomaticKeepAlives: true,
                          controller: controller.scrollController,
                          itemCount: controller.mangaChapter.value.images?.length ?? 0,
                          itemBuilder: (context, index) => MangaPageImage(index: index),
                        ),
                      ),
                    ),
                    ChapterBottomNavigationBarWidget(
                      onPreviousButtonPressed: previousChapter,
                      onNextButtonPressed: nextChapter,
                      visible: controller.visibleHUDState.value,
                      number: controller.mangaChapter.value.number ?? -1,
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

      controller.getChapterContent(chapter, chapterList!);
    } else {
      Unifier.toast(
        content: 'Esse é o último capítulo disponível',
      );
    }
  }

  void previousChapter() {
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

  @override
  void dispose() {
    controller.scrollController.removeListener(() => controller.scrollListener(chapter));
    controller.scrollController.dispose();
    SystemChrome.setEnabledSystemUIOverlays(SystemUiOverlay.values);
    super.dispose();
  }
}
