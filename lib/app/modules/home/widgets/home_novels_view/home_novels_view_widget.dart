import 'package:flutter/material.dart';
import 'package:rx_notifier/rx_notifier.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:unifier_mobile/app/modules/home/home_controller.dart';
import 'package:unifier_mobile/app/shared/models/work_result.dart';

import '../work_item/work_item_widget.dart';
import 'package:unifier_mobile/app/shared/utils/enums.dart';

class HomeNovelsViewWidget extends StatelessWidget {
  const HomeNovelsViewWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = Modular.get<HomeController>();

    return SafeArea(
      child: RxBuilder(
        builder: (_) {
          final items = controller.novelResults;
          final empty = items.isEmpty;

          return AnimatedAlign(
            duration: Duration(milliseconds: 400),
            curve: Curves.ease,
            alignment: !empty ? Alignment.topCenter : Alignment.center,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 8),
              child: Column(
                children: [
                  SizedBox(height: 16),
                  empty
                      ? Container()
                      : TextField(
                          decoration: inputDecoration,
                          textCapitalization: TextCapitalization.words,
                          onChanged: controller.changeSearchNovelsField,
                        ),
                  empty ? Container() : SizedBox(height: 16),
                  RxBuilder(
                    builder: (_) {
                      if (controller.novelState.value == RequestState.LOADING)
                        return Expanded(
                          child: Center(
                            child: CircularProgressIndicator(),
                          ),
                        );

                      if (empty) {
                        return Expanded(
                          child: Padding(
                            padding: EdgeInsets.all(16),
                            child: Center(
                              child: Text(
                                'Nenhuma novel encontrada',
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                        );
                      }

                      return Expanded(
                        child: GridView.count(
                          padding: EdgeInsets.all(8),
                          crossAxisCount: 3,
                          childAspectRatio: 7 / 14,
                          crossAxisSpacing: 8,
                          children: controller.filteredNovelResults
                              .map((element) => WorkItemWidget(
                                    item: element ?? WorkResult(),
                                    onTap: () => Modular.to.pushNamed(
                                      '/work',
                                      arguments: {
                                        'type': 'novel',
                                        'item': element ?? WorkResult(),
                                      },
                                    ),
                                  ))
                              .toList(),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  InputDecoration get inputDecoration {
    return InputDecoration(
      labelText: 'Obra',
      hintText: 'Digite o nome da obra',
      suffixIcon: Icon(Icons.search),
      border: OutlineInputBorder(
        borderSide: BorderSide(width: 1),
      ),
    );
  }
}
