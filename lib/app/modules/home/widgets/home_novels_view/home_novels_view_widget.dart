import 'package:flutter/material.dart';
import 'package:rx_notifier/rx_notifier.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:unifier_mobile/app/modules/home/home_controller.dart';
import 'package:unifier_mobile/app/shared/models/work_result.dart';

import '../work_item/work_item_widget.dart';
import 'package:unifier_mobile/app/shared/utils/enums.dart';

class HomeNovelsViewWidget extends StatefulWidget {
  const HomeNovelsViewWidget({Key? key}) : super(key: key);

  @override
  _HomeNovelsViewWidgetState createState() => _HomeNovelsViewWidgetState();
}

class _HomeNovelsViewWidgetState extends State<HomeNovelsViewWidget> {
  final controller = Modular.get<HomeController>();
  late TextEditingController novelsTextController;

  @override
  void initState() {
    super.initState();
    novelsTextController = TextEditingController();
  }

  @override
  void dispose() {
    super.dispose();
    controller.searchNovelsField.value = '';
    novelsTextController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: RefreshIndicator(
          onRefresh: () async => controller.getNovels(),
          child: RxBuilder(
            builder: (_) {
              final items = controller.novelResults;
              final empty = items.isEmpty;

              return AnimatedAlign(
                duration: Duration(milliseconds: 400),
                curve: Curves.ease,
                alignment: !empty ? Alignment.topCenter : Alignment.center,
                child: OrientationBuilder(
                  builder: (_, orientation) => Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8),
                    child: Listener(
                      onPointerUp: (y) => controller.unlock(),
                      onPointerMove: (moveEvent) {
                        if (orientation == Orientation.portrait) controller.changeSearchView(true, 0);

                        if (orientation == Orientation.landscape) {
                          if (moveEvent.delta.dy > 0) {
                            controller.lock(1);
                            controller.changeSearchView(true, 1);
                          } else if (moveEvent.delta.dy < 0) {
                            controller.lock(2);
                            controller.changeSearchView(false, 2);
                          }
                        }
                      },
                      child: Column(
                        children: [
                          empty
                              ? Container()
                              : RxBuilder(
                                  builder: (context) => AnimatedContainer(
                                    duration: Duration(milliseconds: 200),
                                    height: controller.searchView.value ? 32 + 62 : 0,
                                    curve: Curves.ease,
                                    child: AnimatedOpacity(
                                      duration: Duration(milliseconds: 150),
                                      opacity: controller.searchView.value ? 1 : 0,
                                      child: Column(
                                        children: [
                                          Flexible(child: SizedBox(height: 16)),
                                          Expanded(
                                            flex: 4,
                                            child: TextField(
                                              decoration: inputDecoration,
                                              controller: novelsTextController,
                                              textCapitalization: TextCapitalization.words,
                                              onChanged: controller.changeSearchNovelsField,
                                            ),
                                          ),
                                          Flexible(child: SizedBox(height: 16)),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
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
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            'Nenhuma novel encontrada',
                                            textAlign: TextAlign.center,
                                          ),
                                          SizedBox(height: 16),
                                          ElevatedButton.icon(
                                            onPressed: controller.getNovels,
                                            icon: Icon(Icons.refresh),
                                            label: Text('Tentar novamente'),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              }

                              final axisCount = (MediaQuery.of(context).size.width / 100).truncate();

                              return Expanded(
                                child: GridView.count(
                                  padding: EdgeInsets.all(8),
                                  crossAxisCount: axisCount,
                                  childAspectRatio: axisCount / ((axisCount * 2) + 0.2),
                                  crossAxisSpacing: 8,
                                  children: controller.filteredNovelResults
                                      .map((element) => WorkItemWidget(
                                            itemsInPage: axisCount,
                                            item: element ?? WorkResult(),
                                            onTap: () => Modular.to.pushNamed(
                                              '/work',
                                              arguments: {
                                                'type': element?.type ?? '',
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
                  ),
                ),
              );
            },
          ),
        ),
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
