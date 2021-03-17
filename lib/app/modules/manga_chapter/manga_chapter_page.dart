import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:rx_notifier/rx_notifier.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:unifier_mobile/app/shared/models/chapter.dart';
import 'package:unifier_mobile/app/shared/utils/enums.dart';
import 'package:unifier_mobile/app/shared/utils/functions.dart';
import 'package:unifier_mobile/app/shared/widgets/chapter_bottom_navigation_bar/chapter_bottom_navigation_bar_widget.dart';
import 'manga_chapter_controller.dart';
import 'widgets/manga_chapter_app_bar.dart';

class MangaChapterPage extends StatefulWidget {
  final String title;
  const MangaChapterPage({Key? key, this.title = "MangaChapter"})
      : super(key: key);

  @override
  _MangaChapterPageState createState() => _MangaChapterPageState();
}

class _MangaChapterPageState
    extends ModularState<MangaChapterPage, MangaChapterController> {
  // final controller = MangaChapterController(Modular.get());

  final List<Chapter>? chapterList = Modular.args?.data['allWork'];

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
              ? MangaChapterAppBar(controller: store)
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
                      child: InteractiveViewer(
                        maxScale: 5,
                        child: SingleChildScrollView(
                          child: Column(
                            children: (store.mangaChapter.value.images
                                    ?.map<Widget>(
                                  (imageUrl) {
                                    return Column(
                                      children: [
                                        Image.network(
                                          imageUrl,
                                          loadingBuilder: (context, child,
                                              loadingProgress) {
                                            if (loadingProgress == null)
                                              return child;

                                            return Padding(
                                              padding:
                                                  const EdgeInsets.all(16.0),
                                              child: CircularProgressIndicator(
                                                value: loadingProgress
                                                            .expectedTotalBytes !=
                                                        null
                                                    ? loadingProgress
                                                            .cumulativeBytesLoaded /
                                                        (loadingProgress
                                                                .expectedTotalBytes
                                                            as int)
                                                    : null,
                                              ),
                                            );
                                          },
                                          errorBuilder:
                                              (context, error, stackTrace) {
                                            return Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Center(
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment
                                                          .stretch,
                                                  children: [
                                                    Text(
                                                      'Error on load image!',
                                                      textAlign:
                                                          TextAlign.center,
                                                      style: TextStyle(
                                                        fontSize: 12,
                                                        color: Theme.of(context)
                                                            .primaryColor,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                    )
                                                  ],
                                                ),
                                              ),
                                            );
                                          },
                                        ),
                                        if (imageUrl ==
                                            store.mangaChapter.value.images
                                                ?.last)
                                          SizedBox(
                                            height: 60,
                                            width: MediaQuery.of(context)
                                                .size
                                                .width,
                                          )
                                      ],
                                    );
                                  },
                                ).toList() ??
                                <Widget>[]),
                          ),
                        ),
                      ),
                    ),
                    ChapterBottomNavigationBarWidget(
                      onPreviousButtonPressed: previousChapter,
                      onNextButtonPressed: nextChapter,
                      visible: store.visibleHUDState.value,
                      number: store.mangaChapter.value.number ?? -1,
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
    SystemChrome.setEnabledSystemUIOverlays(SystemUiOverlay.values);
    super.dispose();
  }
}
