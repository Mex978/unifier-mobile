import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:unifier_mobile/app/modules/work/utils/enums.dart';
import 'package:unifier_mobile/app/modules/work/widgets/chapter_item/chapter_item_widget.dart';
import 'package:unifier_mobile/app/shared/models/chapter.dart';

class WorkChapters extends StatelessWidget {
  final List<Chapter> items;

  WorkChapters({Key? key, required this.items}) : super(key: key);

  final String? type = Modular.args?.data['type'];
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
                return ChapterItemWidget(
                  item: items[index],
                  state: ChapterState.idle,
                  width: double.infinity,
                  height: double.infinity,
                  onTap: () => Modular.to.pushNamed(
                    route,
                    arguments: {
                      'type': type,
                      'allWork': items,
                      'index': index,
                      'chapter': items[index]
                    },
                  ),
                );
              },
            ),
          );
  }
}
