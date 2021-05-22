import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:rx_notifier/rx_notifier.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:unifier_mobile/app/modules/work/work_controller.dart';
import 'package:unifier_mobile/app/shared/models/chapter.dart';
import 'package:unifier_mobile/app/shared/themes/colors.dart';
import 'package:unifier_mobile/app/shared/utils/enums.dart';
import 'package:unifier_mobile/app/shared/utils/extensions.dart';
import 'package:flutter_svg/flutter_svg.dart';

class WorkLanguageSelector extends StatefulWidget {
  final Language currentLanguage;
  final ValueChanged<Language> onChaged;
  final String type;

  WorkLanguageSelector({
    Key? key,
    required this.currentLanguage,
    required this.onChaged,
    required this.type,
  }) : super(key: key);

  @override
  _WorkLanguageSelectorState createState() => _WorkLanguageSelectorState();
}

class _WorkLanguageSelectorState extends State<WorkLanguageSelector> {
  final controller = Modular.get<WorkController>();
  final focus = FocusNode();

  final _shadow = BoxShadow(
    color: Colors.black.withOpacity(.32),
    blurRadius: 3,
    spreadRadius: 3,
  );

  bool isSearching = false;

  @override
  void initState() {
    focus.addListener(focusListener);
    super.initState();
  }

  @override
  void dispose() {
    focus.removeListener(focusListener);
    focus.dispose();
    super.dispose();
  }

  void focusListener() {
    if (!focus.hasFocus) {
      setState(() {
        isSearching = false;
        controller.changeSearchChaptersField('');
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return RxBuilder(
      builder: (_) {
        List<Chapter>? chapterList =
            widget.type == 'manga' ? controller.manga.value.chapters : controller.novel.value.chapters;

        return Container(
          decoration: BoxDecoration(color: UnifierColors.tertiaryColor, boxShadow: [_shadow]),
          child: Row(
            children: isSearching
                ? []
                : Language.values.map((lang) {
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
                              groupValue: widget.currentLanguage,
                              value: lang,
                              onChanged: (_) => widget.onChaged(lang),
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
                  }).toList()
              ..addAll([
                if (!isSearching) Spacer(),
                RxBuilder(
                  builder: (context) {
                    return ClipRRect(
                      borderRadius: BorderRadius.circular(100),
                      child: Material(
                        color: Colors.transparent,
                        child: ClipRRect(
                          child: IconButton(
                            icon: Icon(controller.sortMode.value == 0
                                ? MaterialCommunityIcons.sort_numeric_descending
                                : MaterialCommunityIcons.sort_numeric_ascending),
                            onPressed: controller.changeSortMode,
                          ),
                        ),
                      ),
                    );
                  },
                ),
                isSearching
                    ? Expanded(
                        child: Padding(
                          padding: EdgeInsets.all(8),
                          child: TextField(
                            focusNode: focus,
                            decoration: inputDecoration,
                            keyboardType: TextInputType.number,
                            textCapitalization: TextCapitalization.words,
                            onChanged: controller.changeSearchChaptersField,
                          ),
                        ),
                      )
                    : ClipRRect(
                        borderRadius: BorderRadius.circular(100),
                        child: Material(
                          color: Colors.transparent,
                          child: ClipRRect(
                            child: IconButton(
                              icon: Icon(Icons.search),
                              onPressed: () {
                                setState(() {
                                  isSearching = !isSearching;

                                  if (isSearching) focus.requestFocus();
                                });
                              },
                            ),
                          ),
                        ),
                      ),
              ]),
          ),
        );
      },
    );
  }

  InputDecoration get inputDecoration {
    return InputDecoration(
      labelText: 'Número do capítulo',
      hintText: 'Digite o número',
      suffixIcon: Icon(Icons.search),
      border: OutlineInputBorder(
        borderSide: BorderSide(width: 1),
      ),
    );
  }
}
