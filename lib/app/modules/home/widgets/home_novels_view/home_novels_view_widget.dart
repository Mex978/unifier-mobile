import 'package:flutter/material.dart';
import 'package:rx_notifier/rx_notifier.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:unifier_mobile/app/modules/home/home_controller.dart';
import 'package:unifier_mobile/app/shared/models/work_result.dart';

import '../work_item/work_item_widget.dart';
import 'package:unifier_mobile/app/shared/utils/enums.dart';

class HomeNovelsViewWidget extends StatefulWidget {
  final HomeController? controller;

  const HomeNovelsViewWidget({Key? key, this.controller}) : super(key: key);

  @override
  _HomeNovelsViewWidgetState createState() => _HomeNovelsViewWidgetState();
}

class _HomeNovelsViewWidgetState extends State<HomeNovelsViewWidget> {
  @override
  void initState() {
    super.initState();
    widget.controller!.getNovels();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(child: RxBuilder(builder: (_) {
      final items = widget.controller!.novelResults;
      final empty = items.isEmpty;

      return AnimatedAlign(
        duration: Duration(milliseconds: 400),
        curve: Curves.ease,
        alignment: !empty ? Alignment.topCenter : Alignment.center,
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: SizedBox(height: 16),
            ),
            SliverPadding(
              padding: EdgeInsets.symmetric(horizontal: 8),
              sliver: SliverToBoxAdapter(
                child: empty
                    ? Container()
                    : TextField(
                        decoration: inputDecoration,
                        textCapitalization: TextCapitalization.words,
                        onChanged: widget.controller!.changeSearchNovelsField,
                      ),
              ),
            ),
            SliverToBoxAdapter(
              child: empty ? Container() : SizedBox(height: 24),
            ),
            RxBuilder(
              builder: (_) {
                if (widget.controller?.novelState.value == RequestState.LOADING)
                  return SliverToBoxAdapter(
                    child: Container(
                      height: empty ? MediaQuery.of(context).size.height : null,
                      child: Center(
                        child: CircularProgressIndicator(),
                      ),
                    ),
                  );

                if (empty) {
                  return SliverToBoxAdapter(
                    child: Container(
                      padding: EdgeInsets.all(8),
                      height: MediaQuery.of(context).size.height,
                      child: Center(
                        child: Text(
                          'Nenhum novel encontrada',
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  );
                }

                return SliverPadding(
                  padding: const EdgeInsets.all(8.0),
                  sliver: SliverGrid(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      childAspectRatio: 7 / 14,
                      crossAxisSpacing: 8,
                    ),
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        return WorkItemWidget(
                          item:
                              widget.controller?.filteredNovelResults[index] ??
                                  WorkResult(),
                          onTap: () => Modular.to.pushNamed(
                            '/chapters',
                            arguments: {
                              'type': 'novel',
                              'item': widget.controller
                                      ?.filteredNovelResults[index] ??
                                  WorkResult(),
                            },
                          ),
                        );
                      },
                      childCount:
                          widget.controller?.filteredNovelResults.length,
                    ),
                  ),
                );
              },
            ),
            SliverToBoxAdapter(
              child: SizedBox(height: 16),
            ),
          ],
        ),
      );
    }));
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
