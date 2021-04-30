import 'package:auto_animated/auto_animated.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:rx_notifier/rx_notifier.dart';
import 'package:unifier_mobile/app/modules/work/utils/enums.dart';
import 'package:unifier_mobile/app/modules/work/widgets/chapter_item/chapter_item_widget.dart';
import 'package:unifier_mobile/app/modules/work/work_controller.dart';
import 'package:unifier_mobile/app/shared/models/chapter.dart';
import 'package:unifier_mobile/app/shared/themes/colors.dart';

class WorkChapters extends StatelessWidget {
  final List<Chapter> items;

  WorkChapters({Key? key, required this.items}) : super(key: key);

  final _workController = Modular.get<WorkController>();

  final String type = Modular.args?.data['type'];
  final kSpace = 4.0;

  final options = LiveOptions(
    showItemInterval: Duration(milliseconds: 10),
    showItemDuration: Duration(milliseconds: 250),
    visibleFraction: 0.05,
    reAnimateOnVisibility: false,
  );

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    final axisCount = size.width / 60;

    String route;

    if (type == 'manga') {
      route = '/manga_chapter';
    } else {
      route = '/novel_chapter';
    }

    return items.isEmpty
        ? Center(
            child: Text(
              'Nenhum capítulo encontrado!',
              style: TextStyle(
                color: UnifierColors.secondaryColor,
              ),
            ),
          )
        : Expanded(
            child: StreamBuilder<QuerySnapshot>(
                stream: _workController.workRef?.collection('chapters').snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState != ConnectionState.active) return Center(child: CircularProgressIndicator());

                  Widget buildAnimatedItem(
                    BuildContext context,
                    int index,
                    Animation<double> animation,
                  ) {
                    return RxBuilder(builder: (_) {
                      final _value = Modular.get<WorkController>().sortMode.value;
                      final reversed = _value == 1;
                      final itemsList = reversed ? items.reversed.toList() : items;

                      /// 0 - IDLE
                      /// 1 - OPENED
                      /// 2 - READED
                      int state = 0;

                      snapshot.data?.docs.asMap().forEach((i, doc) {
                        if (doc.id == itemsList[index].id) {
                          final _data = doc.data() ?? {};

                          final opened = _data['opened'] ?? false;
                          final readed = _data['readed'] ?? false;

                          if (readed)
                            state = 2;
                          else if (opened)
                            state = 1;
                          else
                            state = 0;
                        }
                      });

                      return FadeTransition(
                        opacity: Tween<double>(
                          begin: 0,
                          end: 1,
                        ).animate(animation),
                        // And slide transition
                        child: SlideTransition(
                          position: Tween<Offset>(
                            begin: Offset(0, -0.1),
                            end: Offset.zero,
                          ).animate(animation),
                          // Paste you Widget
                          child: ChapterItemWidget(
                            item: itemsList[index],
                            state: state == 0
                                ? ChapterState.idle
                                : state == 1
                                    ? ChapterState.incomplete
                                    : ChapterState.readed,
                            width: double.infinity,
                            height: double.infinity,
                            onTap: () => Modular.to.pushNamed(
                              route,
                              arguments: {
                                'type': type,
                                'allWork': itemsList,
                                'reversed': reversed,
                                'index': index,
                                'chapter': itemsList[index],
                                'workRef': _workController.workRef,
                              },
                            ),
                          ),
                        ),
                      );
                    });
                  }

                  return LiveGrid.options(
                    options: options,
                    itemBuilder: buildAnimatedItem,
                    itemCount: items.length,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: axisCount.truncate(),
                      childAspectRatio: 1.0,
                      mainAxisSpacing: kSpace,
                      crossAxisSpacing: kSpace,
                    ),
                    padding: EdgeInsets.all(8),
                  );
                }),
          );
  }
}
