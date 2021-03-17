import 'package:flutter/material.dart';
import 'package:rx_notifier/rx_notifier.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:unifier_mobile/app/modules/work/work_controller.dart';
import 'package:unifier_mobile/app/shared/models/chapter.dart';
import 'package:unifier_mobile/app/shared/utils/enums.dart';
import 'package:unifier_mobile/app/shared/utils/extensions.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'language_selector_sliver_app_bar_delegate.dart';

class WorkLanguageSelector extends StatelessWidget {
  final Language currentLanguage;
  final ValueChanged<Language> onChaged;
  final String type;

  const WorkLanguageSelector({
    Key? key,
    required this.currentLanguage,
    required this.onChaged,
    required this.type,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SliverPersistentHeader(
      pinned: true,
      floating: false,
      delegate: SliverAppBarDelegate(
        minHeight: 50.0,
        maxHeight: 50.0,
        child: _languageSelector(context),
      ),
    );
  }

  Widget _languageSelector(BuildContext context) {
    final controller = Modular.get<WorkController>();

    return RxBuilder(
      builder: (_) {
        List<Chapter>? chapterList = type == 'manga'
            ? controller.manga.value.chapters
            : controller.novel.value.chapters;

        return Container(
          color: Theme.of(context).scaffoldBackgroundColor,
          child: Row(
            children: Language.values.map((lang) {
              if (lang == Language.NONE) {
                return Container();
              }

              final list = chapterList!.where((c) {
                return c.language == lang;
              }).toList();
              final enabled = list.isNotEmpty;

              return IgnorePointer(
                ignoring: !enabled,
                child: Opacity(
                  opacity: enabled ? 1 : 0.4,
                  child: Row(
                    children: [
                      Radio<Language>(
                        groupValue: currentLanguage,
                        value: lang,
                        onChanged: (_) => onChaged(lang),
                      ),
                      SvgPicture.asset(
                        lang.getSVGPath,
                        height: 32,
                        width: 32,
                      )
                    ],
                  ),
                ),
              );
            }).toList(),
          ),
        );
      },
    );
  }
}