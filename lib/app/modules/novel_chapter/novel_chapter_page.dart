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
  const NovelChapterPage({Key? key, this.title = "NovelChapter"})
      : super(key: key);

  @override
  _NovelChapterPageState createState() => _NovelChapterPageState();
}

class _NovelChapterPageState
    extends ModularState<NovelChapterPage, NovelChapterController> {
  final List<Chapter>? chapterList = Modular.args?.data['allChapters'];
  int? index = Modular.args?.data['index'];
  Chapter? chapter = Modular.args?.data['chapter'];

  @override
  void initState() {
    super.initState();
    store.getChapterContent(chapter!);
  }

  @override
  Widget build(BuildContext context) {
    return RxBuilder(
      builder: (_) {
        if (store.state.value == RequestState.LOADING)
          return Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );

        return Scaffold(
          appBar: store.visibleHUDState.value
              ? NovelChapterAppBar(controller: store)
              : null,
          body: SafeArea(
            child: RxBuilder(
              builder: (_) {
                if (store.state.value == RequestState.LOADING)
                  return Center(
                    child: CircularProgressIndicator(),
                  );

                return Stack(
                  fit: StackFit.expand,
                  children: [
                    GestureDetector(
                      onTap: () {
                        store.changeVisibleHUDState(
                            !store.visibleHUDState.value);
                      },
                      child: SingleChildScrollView(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            children: [
                              Text(
                                '${store.novelChapter.value.body}',
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
                      visible: store.visibleHUDState.value,
                      number: store.novelChapter.value.number ?? -1,
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
    if (index! < (chapterList!.length - 1)) {
      setState(() {
        index = index! + 1;
        chapter = chapterList![index!];
      });

      store.getChapterContent(chapter!);
    } else {
      Unifier.toast(
        context,
        content: 'Esse é o último capítulo disponível',
      );
    }
  }

  void previousChapter() {
    if (index! > 0) {
      setState(() {
        index = index! - 1;
        chapter = chapterList![index!];
      });
      store.getChapterContent(chapter!);
    } else {
      Unifier.toast(
        context,
        content: 'Esse é o primeiro capítulo disponível',
      );
    }
  }

  @override
  void dispose() {
    Unifier.changeSystemUiHUD(true);
    super.dispose();
  }
}
