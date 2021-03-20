import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:unifier_mobile/app/modules/work/utils/enums.dart';
import 'package:unifier_mobile/app/modules/work/widgets/chapter_item/chapter_item_widget.dart';
import 'package:unifier_mobile/app/modules/work/work_controller.dart';
import 'package:unifier_mobile/app/shared/models/chapter.dart';

class WorkChapters extends StatelessWidget {
  final List<Chapter> items;

  WorkChapters({Key? key, required this.items}) : super(key: key);

  final _workController = Modular.get<WorkController>();

  final String type = Modular.args?.data['type'];
  final kSpace = 4.0;

  @override
  Widget build(BuildContext context) {
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
                color: Color.fromRGBO(0, 0, 0, 0.56),
              ),
            ),
          )
        : Expanded(
            child: GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 6,
                childAspectRatio: 1.0,
                mainAxisSpacing: kSpace,
                crossAxisSpacing: kSpace,
              ),
              itemCount: items.length,
              padding: EdgeInsets.all(8),
              itemBuilder: (context, index) {
                return StreamBuilder<QuerySnapshot>(
                    stream: _workController.workRef
                        ?.collection('chapters')
                        .snapshots(),
                    builder: (context, snapshot) {
                      /// 0 - IDLE
                      /// 1 - OPENED
                      /// 2 - READED
                      int state = 0;

                      snapshot.data?.docs.asMap().forEach((i, doc) {
                        if (doc.id == items[index].id) {
                          final _data = doc.data() ?? {};

                          state = _data['opened'] == null ? state : 1;
                          state = _data['readed'] == null ? state : 2;
                        }
                      });
                      return ChapterItemWidget(
                        item: items[index],
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
                            'allWork': items,
                            'index': index,
                            'chapter': items[index],
                            'workRef': _workController.workRef
                          },
                        ),
                      );
                    });
              },
            ),
          );
  }
}
